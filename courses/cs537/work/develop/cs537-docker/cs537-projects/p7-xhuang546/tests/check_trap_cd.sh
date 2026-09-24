#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"

usage() {
    cat <<'EOF'
usage: check_trap_cd.sh [ROOTFS]

Verify that cd works inside the trap rootfs for internal paths but cannot
escape outside the rootfs by repeatedly using "..".
If ROOTFS is omitted, defaults to tests/rootfs/trap_fs.
EOF
}

if (( $# > 1 )); then
    usage >&2
    exit 1
fi

ROOTFS="${1:-$TEST_DIR/rootfs/trap_fs}"

fail() {
    echo "check_trap_cd: $*" >&2
    exit 1
}

echo "== Checking local build artifacts =="
[[ -x "$SOLN_DIR/mini-container" ]] || fail "missing mini-container"

echo "== Checking that cd works for internal trap rootfs paths =="
pwd_inside=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'cd /tmp && pwd')
printf '%s\n' "$pwd_inside"
if [[ "$(printf '%s\n' "$pwd_inside" | head -n1)" != "/tmp" ]]; then
    fail "expected pwd to be /tmp, got: $pwd_inside"
fi

echo "== Checking nested cd inside trap rootfs =="
pwd_nested=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'mkdir -p /tmp/a/b && cd /tmp/a/b && pwd')
printf '%s\n' "$pwd_nested"
if [[ "$(printf '%s\n' "$pwd_nested" | head -n1)" != "/tmp/a/b" ]]; then
    fail "expected pwd to be /tmp/a/b, got: $pwd_nested"
fi

echo "== Checking that cd .. cannot escape the trap rootfs =="
pwd_escape=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'cd /tmp && cd ../../../../ && pwd')
printf '%s\n' "$pwd_escape"
if [[ "$(printf '%s\n' "$pwd_escape" | head -n1)" != "/" ]]; then
    fail "expected pwd to remain /, got: $pwd_escape"
fi

echo
echo "trap cd check passed."
