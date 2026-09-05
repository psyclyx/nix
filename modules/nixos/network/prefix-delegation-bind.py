"""Join systemd-networkd's DHCPv6-PD lease to Kea's delegation pools.

Reads the prefix networkd learned, derives a slice per downstream
router, replaces that slice in Kea's pool, and routes it to the router.
Then follows netlink and does it again whenever the prefix moves.

Idempotent by construction: every pass computes the desired state from
the live prefix and applies only what differs, so re-running after a Kea
restart, a link flap or a renumber all take the same path.
"""

import ipaddress
import json
import os
import socket
import subprocess
import sys


def upstream_prefix():
    """The prefix networkd was delegated, or None if we have no lease.

    networkd installs an unreachable route covering the whole delegation
    so that traffic to unassigned parts of it doesn't loop back upstream.
    That route is the observable form of the lease.
    """
    out = subprocess.run(
        ["ip", "-j", "-6", "route", "show", "type", "unreachable", "proto", "dhcp"],
        capture_output=True, text=True, check=True,
    ).stdout
    routes = json.loads(out or "[]")
    prefixes = [ipaddress.IPv6Network(r["dst"]) for r in routes if "dst" in r]
    if not prefixes:
        return None
    if len(prefixes) > 1:
        # More than one delegation is a situation this module has no
        # policy for — picking one arbitrarily would silently hand a
        # downstream the wrong prefix half the time.
        raise SystemExit(f"multiple delegated prefixes: {prefixes}")
    return prefixes[0]


def slice_for(prefix, subnet_id, length):
    """The subnet_id'th sub-prefix of `length` bits within `prefix`."""
    if length < prefix.prefixlen:
        raise SystemExit(
            f"slice /{length} is larger than the delegation {prefix}")
    available = 1 << (length - prefix.prefixlen)
    if subnet_id >= available:
        raise SystemExit(
            f"subnetId {subnet_id} is outside {prefix} at /{length} "
            f"({available} slices available)")
    return next(
        s for i, s in enumerate(prefix.subnets(new_prefix=length))
        if i == subnet_id
    )


# ── Kea ───────────────────────────────────────────────────────────────

def kea(sock_path, command, arguments=None):
    """One command over Kea's control socket."""
    request = {"command": command}
    if arguments is not None:
        request["arguments"] = arguments
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(sock_path)
        s.sendall(json.dumps(request).encode())
        s.shutdown(socket.SHUT_WR)
        chunks = []
        while chunk := s.recv(65536):
            chunks.append(chunk)
    reply = json.loads(b"".join(chunks))
    if reply.get("result", 1) != 0:
        raise SystemExit(f"kea {command}: {reply.get('text')}")
    return reply.get("arguments", {})


def owned_pools(config, name):
    """Every pd-pool tagged as belonging to this downstream.

    Found by marker rather than by subnet id or position, so Kea's
    configuration can be reordered or renumbered around us.
    """
    for subnet in config.get("Dhcp6", {}).get("subnet6", []):
        for pool in subnet.get("pd-pools", []):
            context = pool.get("user-context") or {}
            if context.get("psyclyx-delegation") == name:
                yield pool


def sync_kea(sock_path, wanted):
    """Point each tagged pool at its slice. Returns True if anything moved."""
    config = kea(sock_path, "config-get")
    config.pop("hash", None)

    changed = False
    for name, prefix in wanted.items():
        pools = list(owned_pools(config, name))
        if not pools:
            raise SystemExit(
                f"no pd-pool tagged psyclyx-delegation={name!r} in Kea's "
                f"configuration — the pool has to be declared, this only "
                f"keeps its prefix current")
        for pool in pools:
            want = str(prefix.network_address)
            if (pool.get("prefix"), pool.get("prefix-len")) != (want, prefix.prefixlen):
                pool["prefix"] = want
                pool["prefix-len"] = prefix.prefixlen
                changed = True

    if changed:
        kea(sock_path, "config-set", config)
    return changed


# ── Routing ───────────────────────────────────────────────────────────

def sync_route(prefix, via, interface):
    """Route the slice to the router that holds it.

    `route replace` rather than add-then-delete: the delegated prefix
    should never be momentarily unreachable during a renumber.
    """
    subprocess.run(
        ["ip", "-6", "route", "replace", str(prefix),
         "via", via, "dev", interface],
        check=True,
    )


# ── Main ──────────────────────────────────────────────────────────────

def reconcile(plan):
    prefix = upstream_prefix()
    if prefix is None:
        # No lease yet. Nothing to derive and nothing to withdraw: the
        # downstream keeps its last prefix until networkd has a new one,
        # which is better than tearing it down and back up.
        return "no delegation received yet"

    wanted = {}
    for name, d in plan["downstream"].items():
        wanted[name] = slice_for(prefix, d["subnetId"], d["prefixLength"])

    changed = sync_kea(plan["socket"], wanted)
    for name, d in plan["downstream"].items():
        sync_route(wanted[name], d["via"], d["interface"])

    slices = ", ".join(f"{n}={p}" for n, p in sorted(wanted.items()))
    return f"{prefix} -> {slices}" + ("" if changed else " (unchanged)")


def notify(state):
    """sd_notify, so the unit is only 'started' once a pass has succeeded."""
    addr = os.environ.get("NOTIFY_SOCKET")
    if not addr:
        return
    if addr.startswith("@"):
        addr = "\0" + addr[1:]
    with socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM) as s:
        s.connect(addr)
        s.sendall(state.encode())


def main():
    plan = json.loads(open(sys.argv[1]).read())

    print(reconcile(plan), flush=True)
    notify("READY=1")

    # Follow netlink rather than polling: the delegation changing is an
    # event, and a renumber should be picked up in the time it takes the
    # kernel to install the new route.
    monitor = subprocess.Popen(
        ["ip", "-6", "monitor", "route"],
        stdout=subprocess.PIPE, text=True,
    )
    for line in monitor.stdout:
        # Only the delegation itself matters; every other route change on
        # a router is noise. The unfiltered form carries both markers —
        #   unreachable 2601:db8:...::/60 dev lo proto dhcp metric 1024
        # — and a withdrawal arrives as the same line prefixed "Deleted",
        # which reconciles to "no delegation" rather than tearing the
        # downstream down.
        if "unreachable" in line and "proto dhcp" in line:
            print(reconcile(plan), flush=True)


if __name__ == "__main__":
    main()
