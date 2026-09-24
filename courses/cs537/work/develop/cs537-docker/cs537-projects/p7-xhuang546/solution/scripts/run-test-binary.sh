#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOLN_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
TEST_DIR="$SOLN_DIR/../tests"
testnum=""

usage() {
    cat <<'EOF'
usage: run-test-binary.sh [-t {1|2|3|4}]

Run the public binary-driver tests for runtime_1.c through runtime_4.c.
This wrapper delegates to ../tests/run-tests.sh so it checks stdout, stderr,
and return codes the same way as the public test suite.

If -t is omitted, run all four binary-driver tests in order.
EOF
}

while (( $# > 0 )); do
    case "$1" in
    -t)
        if (( $# < 2 )); then
            usage >&2
            exit 1
        fi
        testnum=$2
        shift 2
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 1
        ;;
    esac
done

if [[ ! -x "$TEST_DIR/run-tests.sh" ]]; then
    echo "missing test runner: $TEST_DIR/run-tests.sh" >&2
    exit 1
fi

verify_solution_build() {
    echo
    echo "verifying solution builds cleanly with -Werror"
    make -C "$SOLN_DIR" clean
    make -C "$SOLN_DIR"
}

run_one_test() {
    local num=$1
    local public_test_num

    case "$num" in
    1|2|3|4)
        public_test_num=$((num + 12))
        ;;
    *)
        usage >&2
        exit 1
        ;;
    esac

    echo
    echo "running test $num via public test $public_test_num"
    "$TEST_DIR/run-tests.sh" -t "$public_test_num"
}

run_prereq_tests() {
    local public_test_num

    for public_test_num in 10 11 12; do
        echo
        echo "running prerequisite public test $public_test_num"
        "$TEST_DIR/run-tests.sh" -t "$public_test_num"
    done
}

if [[ -n "$testnum" ]]; then
    verify_solution_build
    run_prereq_tests
    run_one_test "$testnum"
    exit 0
fi

verify_solution_build
run_prereq_tests

for num in 1 2 3 4; do
    run_one_test "$num"
done
