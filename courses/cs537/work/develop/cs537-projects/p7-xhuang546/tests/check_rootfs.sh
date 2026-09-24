#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"

usage() {
    cat <<'EOF'
usage: check_rootfs.sh [ROOTFS]

Sanity-check a prepared rootfs and the current mini-container binary.
If ROOTFS is omitted, defaults to tests/tmp_rootfs.
EOF
}

if (( $# > 1 )); then
    usage >&2
    exit 1
fi

ROOTFS="${1:-$TEST_DIR/tmp_rootfs}"

fail() {
    echo "check_rootfs: $*" >&2
    exit 1
}

check_path() {
    local path=$1
    local kind=$2

    case "$kind" in
    dir)
        [[ -d "$path" ]] || fail "missing directory: $path"
        ;;
    file)
        [[ -f "$path" ]] || fail "missing file: $path"
        ;;
    exec)
        [[ -x "$path" ]] || fail "missing executable: $path"
        ;;
    *)
        fail "internal error: unknown kind '$kind'"
        ;;
    esac
}

echo "== Checking local build artifacts =="
check_path "$SOLN_DIR/mini-container" exec

echo "== Checking rootfs structure =="
check_path "$ROOTFS" dir
check_path "$ROOTFS/bin" dir
check_path "$ROOTFS/lib" dir
check_path "$ROOTFS/lib64" dir
check_path "$ROOTFS/proc" dir
check_path "$ROOTFS/tmp" dir

echo "== Checking common programs =="
check_path "$ROOTFS/bin/ls" exec
check_path "$ROOTFS/bin/sh" exec

if [[ -e "$ROOTFS/bin/syscalls_test" ]]; then
    check_path "$ROOTFS/bin/syscalls_test" exec
fi

echo "== Checking dynamic loader / libc =="
if ! find "$ROOTFS/lib" "$ROOTFS/lib64" "$ROOTFS/usr/lib" \
    -type f \
    \( -name 'ld-linux-*.so*' -o -name 'ld-*.so*' \) \
    -print -quit >/dev/null; then
    fail "could not find a dynamic loader inside rootfs"
fi

if ! find "$ROOTFS/lib" "$ROOTFS/lib64" "$ROOTFS/usr/lib" \
    -type f \
    -name 'libc.so.6' \
    -print -quit >/dev/null; then
    fail "could not find libc.so.6 inside rootfs"
fi

echo "== Running ls inside the container =="
ls_output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/ls -1 /)
printf '%s\n' "$ls_output"

for required in bin proc tmp; do
    if ! grep -qx "$required" <<<"$ls_output"; then
        fail "container root listing did not include '$required'"
    fi
done

echo
echo "rootfs sanity check passed."
