#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd -- "$TEST_DIR/.." && pwd)"
SOLN_DIR="$REPO_ROOT/solution"
MAKE_ROOTFS="$SCRIPT_DIR/make-rootfs.sh"
TRAP_ROOTFS="${1:-$SCRIPT_DIR/trap_fs}"

mkdir -p "$TRAP_ROOTFS"/{bin,dev,etc,lib,lib64,proc,root,tmp,usr/bin}

echo "== Building solution =="
make -C "$SOLN_DIR" clean
make -C "$SOLN_DIR"

echo
echo "== Preparing shell-only trap rootfs =="
rm -rf "$TRAP_ROOTFS"
mkdir -p "$TRAP_ROOTFS"/{bin,dev,etc,lib,lib64,proc,root,tmp,usr/bin}
"$MAKE_ROOTFS" "$TRAP_ROOTFS" /bin/sh /bin/ls /bin/mkdir
printf 'trap rootfs shell marker\n' > "$TRAP_ROOTFS/etc/trap_shell_marker.txt"

echo
echo "Trap rootfs prepared at $TRAP_ROOTFS"
