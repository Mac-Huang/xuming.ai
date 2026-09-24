#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"
ROOTFS="${1:-$TEST_DIR/tmp_rootfs}"

echo "== Building solution =="
make --no-print-directory -C "$SOLN_DIR"

echo
echo "== Running bin1 inside prepared rootfs =="
output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/bin1)
printf '%s\n' "$output"

if ! grep -q '^HELLO world$' <<<"$output"; then
    echo "rootfs_basic_boot: expected HELLO world output" >&2
    exit 1
fi

echo
echo "rootfs_basic_boot passed."
