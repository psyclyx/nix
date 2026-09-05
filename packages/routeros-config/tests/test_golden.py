#!/usr/bin/env python3
"""Golden regression tests for routeros_config.

Freezes generate() and diff() output for real switch fixtures
(mdf-agg01 = L3 aggregation, mdf-brk01 = L2 media converter) so the
schema refactor is provably behaviour-preserving — and so the no-reboot
diff/apply flow can't silently drift.

    python3 tests/test_golden.py     # standalone (prints unified diffs)
    pytest tests/test_golden.py      # or via pytest
"""
import difflib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))  # import routeros_config from parent

import routeros_config as rc  # noqa: E402

FIX = os.path.join(HERE, "fixtures")
GOLD = os.path.join(HERE, "golden")


def _read(p):
    with open(p) as f:
        return f.read()


def _load(name):
    return json.loads(_read(os.path.join(FIX, name)))


def run_generate(cfg_name, golden_name):
    got = rc.generate(_load(cfg_name))
    want = _read(os.path.join(GOLD, golden_name))
    return got == want, want, got


def run_diff(cfg_name, state_name, golden_name):
    cfg = _load(cfg_name)
    current = rc.parse_state(_read(os.path.join(FIX, state_name)))
    desired = rc._desired_diffable(cfg)
    ops = rc.diff_state(current, desired)
    got = rc.format_diff_script(
        ops, identity=cfg.get("system", {}).get("identity")
    )
    want = _read(os.path.join(GOLD, golden_name))
    return got == want, want, got


GEN_CASES = [
    ("mdf-agg01.json", "agg.generate.rsc"),
    ("mdf-brk01.json", "brk.generate.rsc"),
]
DIFF_CASES = [
    # State fixture is a verbatim capture from the live mdf-agg01 via
    # `routeros-config state-command`, so the diff is exercised against
    # what the device actually reports — defaults, types, `.id`s and all
    # — rather than against a hand-written idea of it.
    ("mdf-agg01.json", "mdf-agg01.state.json", "agg.diff.rsc"),
]


def _print_diff(want, got):
    for line in difflib.unified_diff(
        want.splitlines(), got.splitlines(),
        fromfile="golden", tofile="got", lineterm="",
    ):
        print("  " + line)


def main():
    failures = 0
    for cfg, gold in GEN_CASES:
        ok, want, got = run_generate(cfg, gold)
        print(f"generate {cfg:20s} -> {gold:20s} {'OK' if ok else 'FAIL'}")
        if not ok:
            failures += 1
            _print_diff(want, got)
    for cfg, exp, gold in DIFF_CASES:
        ok, want, got = run_diff(cfg, exp, gold)
        print(f"diff     {cfg:20s} -> {gold:20s} {'OK' if ok else 'FAIL'}")
        if not ok:
            failures += 1
            _print_diff(want, got)
    print(f"\n{'ALL PASS' if failures == 0 else f'{failures} FAILED'}")
    return 1 if failures else 0


# pytest entry points ------------------------------------------------------

def _assert(ok, want, got, label):
    assert ok, f"{label}\n" + "\n".join(difflib.unified_diff(
        want.splitlines(), got.splitlines(), "golden", "got", lineterm=""))


def test_generate():
    for cfg, gold in GEN_CASES:
        _assert(*run_generate(cfg, gold), f"generate {cfg}")


def test_diff():
    for cfg, state, gold in DIFF_CASES:
        _assert(*run_diff(cfg, state, gold), f"diff {cfg}")


def test_rollback_arm_shape():
    """Commit-confirm preamble snapshots config and arms a timed revert."""
    backup, sched = rc._rollback_names("sid1")
    assert (backup, sched) == ("preflight-sid1", "rollback-sid1")
    p = rc._arm_preamble("sid1", 5)
    assert f"/system backup save name={backup}" in p
    assert f"/system scheduler add name={sched} interval=5m" in p
    assert f"on-event=\"/system backup load name={backup}\"" in p
    # arming must precede changes: preamble ends before any diff section.
    assert p.rstrip().splitlines()[-1].startswith("/system scheduler add")


def test_schema_conformance():
    """Every property we name must exist on the device.

    RouterOS reports its own schema; this is the captured copy. `/import`
    halts at the first bad line and leaves the rest of a diff unapplied,
    so a property we're wrong about is a half-configured switch. Two were
    wrong when this check was first run: `/ip dhcp-relay` has no
    `comment`, and `accept-source-route` is an `/ip settings` property,
    not an `/ipv6 settings` one.
    """
    schema = rc.load_schema(os.path.join(os.path.dirname(HERE), "schema.json"))
    assert schema, "schema.json missing — run `routeros-config learn-schema`"
    violations = rc.schema_violations(schema)
    assert not violations, "\n".join(violations)


if __name__ == "__main__":
    sys.exit(main())
