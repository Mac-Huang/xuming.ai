#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"

usage() {
    cat <<'EOF'
usage: check_rootfs_marker.sh [ROOTFS]

Verify that the container sees a marker file that exists only inside the
prepared rootfs.
EOF
}

if (( $# > 1 )); then
    usage >&2
    exit 1
fi

ROOTFS="${1:-$TEST_DIR/tmp/test_8/rootfs}"

output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/read_marker 2>&1)

if ! grep -qx 'MARKER rootfs-only' <<<"$output"; then
    printf '%s\n' "$output" >&2
    echo "check_rootfs_marker: expected MARKER rootfs-only in output" >&2
    exit 1
fi

echo "rootfs marker check passed."
