#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"

usage() {
    cat <<'EOF'
usage: install-prebuilt-binaries-rootfs.sh ROOTFS

Copy the prebuilt syscall-study binaries from tests/binary/build into ROOTFS/bin.
This helper does not compile the binaries; it expects them to already exist.
EOF
}

if (( $# != 1 )); then
    usage >&2
    exit 1
fi

ROOTFS=$1

require_binary() {
    local path=$1

    if [[ ! -x "$path" ]]; then
        echo "missing prebuilt binary: $path" >&2
        exit 1
    fi
}

make -C "$SCRIPT_DIR" >/dev/null

mkdir -p "$ROOTFS/bin"

for bin in \
    bin1 \
    bin2 \
    bin3 \
    bin4; do
    require_binary "$BUILD_DIR/$bin"
    cp -f "$BUILD_DIR/$bin" "$ROOTFS/bin/$bin"
done

cp -f "$BUILD_DIR/bin2_input.txt" "$ROOTFS/bin2_input.txt"

echo "installed prebuilt binaries into $ROOTFS/bin"
