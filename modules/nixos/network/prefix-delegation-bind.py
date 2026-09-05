"""Point Kea's delegation pool at the prefix networkd was leased.

networkd receives the prefix and re-derives its own addresses when it
moves, but can't delegate onward. Kea delegates but can't learn a new
prefix at runtime. This joins them, and does nothing else.
"""

import ipaddress
import json
import socket
import subprocess
import sys

plan = json.load(open(sys.argv[1]))


def ip(*args):
    return subprocess.run(["ip", *args], capture_output=True, text=True,
                          check=True).stdout


def kea(command, arguments=None):
    request = {"command": command}
    if arguments is not None:
        request["arguments"] = arguments
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(plan["socket"])
        s.sendall(json.dumps(request).encode())
        s.shutdown(socket.SHUT_WR)
        reply = json.loads(b"".join(iter(lambda: s.recv(65536), b"")))
    if reply.get("result", 1) != 0:
        raise SystemExit(f"kea {command}: {reply.get('text')}")
    return reply.get("arguments", {})


def reconcile():
    # networkd publishes the lease as an unreachable route covering the
    # whole delegation, so it doesn't loop traffic for unassigned parts
    # back upstream. That route is the observable form of the lease.
    routes = json.loads(ip("-j", "-6", "route", "show",
                           "type", "unreachable", "proto", "dhcp") or "[]")
    if not routes:
        return "no delegation yet"
    if len(routes) > 1:
        raise SystemExit(f"multiple delegated prefixes: {routes}")
    pd = ipaddress.IPv6Network(routes[0]["dst"])

    slices = {}
    for name, d in plan["downstream"].items():
        subnets = list(pd.subnets(new_prefix=d["prefixLength"]))
        if d["subnetId"] >= len(subnets):
            raise SystemExit(f"{name}: subnetId {d['subnetId']} outside {pd}"
                             f" at /{d['prefixLength']}")
        slices[name] = subnets[d["subnetId"]]

    # Find our pools by marker, not by subnet id or position, so the rest
    # of Kea's config can be reordered or renumbered around us.
    config = kea("config-get")
    config.pop("hash", None)
    changed = False
    for subnet in config.get("Dhcp6", {}).get("subnet6", []):
        for pool in subnet.get("pd-pools", []):
            name = (pool.get("user-context") or {}).get("psyclyx-delegation")
            if name not in slices:
                continue
            want = (str(slices[name].network_address), slices[name].prefixlen)
            if (pool.get("prefix"), pool.get("prefix-len")) != want:
                pool["prefix"], pool["prefix-len"] = want
                changed = True
    if changed:
        kea("config-set", config)

    for name, d in plan["downstream"].items():
        # `replace`, so the slice is never briefly unreachable mid-renumber.
        ip("-6", "route", "replace", str(slices[name]),
           "via", d["via"], "dev", d["interface"])

    return f"{pd} -> " + ", ".join(f"{n}={p}" for n, p in sorted(slices.items()))


print(reconcile(), flush=True)

# Follow netlink rather than poll. The unfiltered form carries both
# markers matched on here; a withdrawal arrives as the same line prefixed
# "Deleted", which reconciles to "no delegation yet" rather than tearing
# the downstream's prefix away.
monitor = subprocess.Popen(["ip", "-6", "monitor", "route"],
                           stdout=subprocess.PIPE, text=True)
for line in monitor.stdout:
    if "unreachable" in line and "proto dhcp" in line:
        print(reconcile(), flush=True)
