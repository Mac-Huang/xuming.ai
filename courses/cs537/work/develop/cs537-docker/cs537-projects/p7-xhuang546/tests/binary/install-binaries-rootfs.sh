#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"

usage() {
    cat <<'EOF'
usage: install-binaries-rootfs.sh ROOTFS

Build the five syscall-study binaries and copy them into ROOTFS/bin.
EOF
}

if (( $# != 1 )); then
    usage >&2
    exit 1
fi

ROOTFS=$1

make -C "$SCRIPT_DIR"
mkdir -p "$ROOTFS/bin"

for bin in \
    bin1 \
    bin2 \
    bin3 \
    bin4; do
    cp -f "$BUILD_DIR/$bin" "$ROOTFS/bin/$bin"
done

cp -f "$BUILD_DIR/bin2_input.txt" "$ROOTFS/bin2_input.txt"

echo "installed binaries into $ROOTFS/bin"
