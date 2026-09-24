#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOLN_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
TEST_DIR="$SOLN_DIR/../tests"
MAKE_ROOTFS="$TEST_DIR/rootfs/make-rootfs.sh"
ROOTFS="$SOLN_DIR/normal_rootfs"
BINARY_DIR="$SOLN_DIR/binary"
BINARY_BUILD_DIR="$BINARY_DIR/build"

usage() {
    cat <<'EOF'
usage: build-normal-rootfs.sh [ROOTFS]

Build a normal rootfs for binary-driver testing.
This script always installs the full binary-test environment.
EOF
}

while (( $# > 0 )); do
    case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    *)
        if (( $# > 1 )); then
            usage >&2
            exit 1
        fi
        ROOTFS=$1
        shift
        ;;
    esac
done

install_bin() {
    local num=$1

    cp -f "$BINARY_BUILD_DIR/bin$num" "$ROOTFS/bin/bin$num"
}

echo "== Preparing normal rootfs =="
rm -rf "$ROOTFS"
make -C "$BINARY_DIR"
"$MAKE_ROOTFS" "$ROOTFS" /bin/ls /bin/sh /bin/mkdir
mkdir -p "$ROOTFS/bin"

for bin in 1 2 3 4; do
    install_bin "$bin"
done

cp -f "$BINARY_BUILD_DIR/bin2_input.txt" "$ROOTFS/bin2_input.txt"

echo
echo "Normal rootfs prepared at $ROOTFS"
