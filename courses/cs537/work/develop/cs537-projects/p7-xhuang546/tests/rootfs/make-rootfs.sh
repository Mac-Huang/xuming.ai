#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
usage: make-rootfs.sh ROOTFS BINARY [BINARY ...]

Create a minimal dynamic-linking-friendly rootfs by copying each binary,
its shared libraries, and the ELF interpreter reported by ldd.
EOF
}

if (( $# < 2 )); then
    usage >&2
    exit 1
fi

rootfs=$1
shift

mkdir -p "$rootfs"
mkdir -p "$rootfs"/{bin,lib,lib64,usr/bin,proc,tmp,dev,etc}

copy_absolute_into_rootfs() {
    local src=$1
    local dst="$rootfs$src"

    mkdir -p "$(dirname "$dst")"
    cp -L "$src" "$dst"
}

copy_binary_and_libs() {
    local bin=$1
    local abs_bin
    local install_path

    abs_bin=$(readlink -f "$bin")
    if [[ $bin == /* ]]; then
        install_path=$bin
        copy_absolute_into_rootfs "$install_path"
    else
        install_path="/bin/$(basename "$bin")"
        mkdir -p "$(dirname "$rootfs$install_path")"
        cp -L "$abs_bin" "$rootfs$install_path"
    fi

    ldd "$abs_bin" | while IFS= read -r line; do
        set -- $line
        if [[ ${1:-} == linux-vdso.so.* ]]; then
            continue
        fi
        if [[ ${2:-} == "=>" && -f ${3:-} ]]; then
            copy_absolute_into_rootfs "$3"
        elif [[ -f ${1:-} ]]; then
            copy_absolute_into_rootfs "$1"
        fi
    done
}

for bin in "$@"; do
    copy_binary_and_libs "$bin"
done

echo "rootfs ready at $rootfs"
