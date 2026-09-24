#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
usage: check_ct_disallow_all.sh SOURCE_FILE

Fail unless SOURCE_FILE contains an explicit call to ct_disallow_all(...).
EOF
}

if (( $# != 1 )); then
    usage >&2
    exit 1
fi

source_file=$1

if [[ ! -f "$source_file" ]]; then
    echo "check_ct_disallow_all: missing source file: $source_file" >&2
    exit 1
fi

if ! grep -Eq 'ct_disallow_all[[:space:]]*\(' "$source_file"; then
    echo "check_ct_disallow_all: expected an explicit ct_disallow_all(...) call in $source_file" >&2
    exit 1
fi
