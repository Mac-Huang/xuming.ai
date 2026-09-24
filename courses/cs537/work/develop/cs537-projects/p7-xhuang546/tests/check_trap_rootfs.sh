#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
TEST_DIR="$REPO_ROOT/tests"

usage() {
    cat <<'EOF'
usage: check_trap_rootfs.sh [ROOTFS]

Verify that a trap rootfs exposes the intended commands for basic manual
testing and does not provide commands that should be absent.
If ROOTFS is omitted, defaults to tests/rootfs/trap_fs.
EOF
}

if (( $# > 1 )); then
    usage >&2
    exit 1
fi

ROOTFS="${1:-$TEST_DIR/rootfs/trap_fs}"

fail() {
    echo "check_trap_rootfs: $*" >&2
    exit 1
}

check_path() {
    local path=$1
    local kind=$2

    case "$kind" in
    dir)
        [[ -d "$path" ]] || fail "missing directory: $path"
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

echo "== Checking trap rootfs structure =="
check_path "$ROOTFS" dir
check_path "$ROOTFS/bin" dir
check_path "$ROOTFS/bin/sh" exec
check_path "$ROOTFS/bin/ls" exec
check_path "$ROOTFS/bin/mkdir" exec

if [[ -e "$ROOTFS/bin/cat" ]]; then
    fail "trap rootfs should not contain /bin/cat"
fi
if [[ -e "$ROOTFS/bin/echo" ]]; then
    fail "trap rootfs should not contain /bin/echo"
fi

echo "== Running ls inside trap shell (should succeed) =="
ls_output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'ls /')
printf '%s\n' "$ls_output"
for required in bin dev etc lib lib64 proc root tmp usr; do
    if ! grep -qx "$required" <<<"$ls_output"; then
        fail "ls output did not include '$required'"
    fi
done

echo "== Running mkdir inside trap shell (should succeed) =="
mkdir_output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'mkdir -p /tmp/x/y && ls /tmp/x')
printf '%s\n' "$mkdir_output"
if ! grep -qx 'y' <<<"$mkdir_output"; then
    fail "mkdir test did not create /tmp/x/y"
fi

echo "== Checking that cat is unavailable =="
set +e
cat_output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c 'cat /etc/trap_shell_marker.txt' 2>&1)
cat_rc=$?
set -e
printf '%s\n' "$cat_output"
if (( cat_rc == 0 )); then
    fail "cat unexpectedly succeeded inside trap rootfs"
fi

echo "== Checking that external echo is unavailable =="
set +e
echo_output=$("$SOLN_DIR/mini-container" --root "$ROOTFS" -- /bin/sh -c '/bin/echo trap-test' 2>&1)
echo_rc=$?
set -e
printf '%s\n' "$echo_output"
if (( echo_rc == 0 )); then
    fail "external /bin/echo unexpectedly succeeded inside trap rootfs"
fi

echo
echo "trap rootfs check passed."
