#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"

usage() {
    cat <<'EOF'
usage: check_proc_mount.sh [ROOTFS]

Verify that /proc is available inside the container.
EOF
}

if (( $# > 1 )); then
    usage >&2
    exit 1
fi

ROOTFS="${1:-$TEST_DIR/tmp/test_9/rootfs}"

output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'if [ -f /proc/self/status ]; then echo PROC_OK; else exit 1; fi' 2>&1)

if ! grep -qx 'PROC_OK' <<<"$output"; then
    printf '%s\n' "$output" >&2
    echo "check_proc_mount: expected PROC_OK in output" >&2
    exit 1
fi

echo "proc mount check passed."
