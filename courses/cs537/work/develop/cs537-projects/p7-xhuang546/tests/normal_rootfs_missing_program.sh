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
echo "== Running a missing program inside normal rootfs =="
set +e
output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/does_not_exist 2>&1)
rc=$?
set -e
printf '%s\n' "$output"

if (( rc == 0 )); then
    echo "normal_rootfs_missing_program: expected failure for missing /bin/does_not_exist" >&2
    exit 1
fi
if ! grep -q 'execvp' <<<"$output"; then
    echo "normal_rootfs_missing_program: expected execvp failure message" >&2
    exit 1
fi

echo
echo "normal_rootfs_missing_program passed."
