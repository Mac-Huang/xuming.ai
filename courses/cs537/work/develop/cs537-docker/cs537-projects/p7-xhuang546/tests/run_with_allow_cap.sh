#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
usage: run_with_allow_cap.sh MAX_ALLOWED command [args...]

Run a runtime driver, require ALLOW_COUNT N in stdout, and fail if N exceeds
MAX_ALLOWED. Successful runs normalize the count line to "ALLOW_COUNT OK".
EOF
}

if (( $# < 2 )); then
    usage >&2
    exit 1
fi

max_allowed=$1
shift

stdout_file=$(mktemp)
stderr_file=$(mktemp)

cleanup() {
    rm -f "$stdout_file" "$stderr_file"
}

trap cleanup EXIT

set +e
"$@" >"$stdout_file" 2>"$stderr_file"
cmd_rc=$?
set -e

if (( cmd_rc != 0 )); then
    cat "$stdout_file"
    cat "$stderr_file" >&2
    exit "$cmd_rc"
fi

allow_count=$(awk '/^ALLOW_COUNT [0-9]+$/ {print $2; found=1} END {if (!found) exit 1}' "$stdout_file") || {
    cat "$stdout_file"
    cat "$stderr_file" >&2
    echo "run_with_allow_cap: missing ALLOW_COUNT line" >&2
    exit 1
}

if (( allow_count > max_allowed )); then
    cat "$stdout_file"
    cat "$stderr_file" >&2
    echo "run_with_allow_cap: allow count $allow_count exceeds limit $max_allowed" >&2
    exit 1
fi

awk '
    /^ALLOW_COUNT [0-9]+$/ {
        print "ALLOW_COUNT OK"
        next
    }
    { print }
' "$stdout_file"
