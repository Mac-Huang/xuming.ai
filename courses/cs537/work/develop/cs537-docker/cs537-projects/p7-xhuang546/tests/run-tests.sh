#! /usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NONE='\033[0m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

cleanup_generated_artifacts () {
    rm -rf \
        "$SCRIPT_DIR/tmp" \
        "$SCRIPT_DIR/tmp_rootfs" \
        "$SCRIPT_DIR/tmp_demo_rootfs" \
        "$SCRIPT_DIR/tmp_trap_rootfs" \
        "$SCRIPT_DIR/tmp_root" \
        "$SCRIPT_DIR/build" \
        "$SCRIPT_DIR/rootfs/build"
}

trap cleanup_generated_artifacts EXIT

run_post () {
    local testdir=$1
    local testnum=$2
    local verbose=$3
    local postfile=$testdir/$testnum.post

    if [[ -f $postfile ]]; then
        eval "$(cat "$postfile")"
        if (( verbose == 1 )); then
            echo -n "post-test: "
            cat "$postfile"
        fi
    fi
}

run_test () {
    local testdir=$1
    local testnum=$2
    local verbose=$3

    rm -f "tests-out/$testnum.out" "tests-out/$testnum.err" "tests-out/$testnum.rc"

    local prefile=$testdir/$testnum.pre
    if [[ -f $prefile ]]; then
        bash "$prefile" &>> /dev/null
        local pre_rc=$?
        if (( pre_rc != 0 )); then
            run_post "$testdir" "$testnum" "$verbose"
            return "$pre_rc"
        fi
        if (( verbose == 1 )); then
            echo -n "pre-test:  "
            cat "$prefile"
        fi
    fi

    local testfile=$testdir/$testnum.run
    if (( verbose == 1 )); then
        echo -n "test:      "
        cat "$testfile"
    fi

    eval "$(cat "$testfile")" > "tests-out/$testnum.out" 2> "tests-out/$testnum.err"
    echo $? > "tests-out/$testnum.rc"

    run_post "$testdir" "$testnum" "$verbose"
}

print_error_message () {
    local testnum=$1
    local contrunning=$2
    local filetype=$3

    builtin echo -e "test $testnum: ${RED}$testnum.$filetype incorrect${NONE}"
    echo "  expected: $testdir/$testnum.$filetype"
    echo "  actual:   tests-out/$testnum.$filetype"
    echo "  debug with: diff $testdir/$testnum.$filetype tests-out/$testnum.$filetype"
    echo "  command in: $testdir/$testnum.run"
    if (( contrunning == 0 )); then
        exit 1
    fi
}

check_test () {
    local testdir=$1
    local testnum=$2
    local filetype=$3

    if diff "$testdir/$testnum.$filetype" "tests-out/$testnum.$filetype" >/dev/null 2>&1; then
        echo 0
    else
        echo 1
    fi
}

run_and_check () {
    local testdir=$1
    local testnum=$2
    local contrunning=$3
    local verbose=$4
    local failmode=$5

    if [[ ! -f $testdir/$testnum.run ]]; then
        if (( failmode == 1 )); then
            echo "test $testnum does not exist" >&2
            exit 1
        fi
        exit 0
    fi

    echo -n -e "running test $testnum: "
    cat "$testdir/$testnum.desc"
    if ! run_test "$testdir" "$testnum" "$verbose"; then
        echo "test $testnum setup or cleanup failed" >&2
        exit 1
    fi

    local rccheck
    local outcheck
    local errcheck
    rccheck=$(check_test "$testdir" "$testnum" rc)
    outcheck=$(check_test "$testdir" "$testnum" out)
    errcheck=$(check_test "$testdir" "$testnum" err)

    if (( rccheck == 0 )) && (( outcheck == 0 )) && (( errcheck == 0 )); then
        echo -e "test $testnum: ${GREEN}passed${NONE}"
        if (( verbose == 1 )); then
            echo ""
        fi
    else
        if (( rccheck == 1 )); then
            print_error_message "$testnum" "$contrunning" rc
        fi
        if (( outcheck == 1 )); then
            print_error_message "$testnum" "$contrunning" out
        fi
        if (( errcheck == 1 )); then
            print_error_message "$testnum" "$contrunning" err
        fi
    fi
}

usage () {
    echo "usage: run-tests.sh [-h] [-v] [-t test] [-c] [-s] [-d testdir]"
    echo "  -h                help message"
    echo "  -v                verbose"
    echo "  -t n              run only test n"
    echo "  -c                continue even after failure"
    echo "  -s                skip one-time pre-test initialization"
    echo "  -d testdir        run tests from testdir"
    return 0
}

verbose=0
testdir="tests"
contrunning=0
skippre=0
specific=""

args=$(getopt hvsct:d: "$@")
if [[ $? != 0 ]]; then
    usage
    exit 1
fi

set -- $args
for i; do
    case "$i" in
    -h)
        usage
        exit 0
        shift
        ;;
    -v)
        verbose=1
        shift
        ;;
    -c)
        contrunning=1
        shift
        ;;
    -s)
        skippre=1
        shift
        ;;
    -t)
        specific=$2
        shift
        if ! [[ $specific =~ ^[0-9]+$ ]]; then
            usage
            echo "-t must be followed by a number" >&2
            exit 1
        fi
        shift
        ;;
    -d)
        testdir=$2
        shift
        shift
        ;;
    --)
        shift
        break
        ;;
    esac
done

mkdir -p tests-out

if (( skippre == 0 )); then
    if [[ -f tests/pre ]]; then
        echo -e "doing one-time pre-test (use -s to suppress)"
        source tests/pre
        if (( $? != 0 )); then
            echo "pre-test: failed"
            exit 1
        fi
        set +e
        echo ""
    fi
fi

mkdir -p tests-out

if [[ $specific != "" ]]; then
    run_and_check "$testdir" "$specific" "$contrunning" "$verbose" 1
    exit 0
fi

mapfile -t testnums < <(find "$testdir" -maxdepth 1 -name '*.run' -printf '%f\n' | sed 's/\.run$//' | sort -n)

for testnum in "${testnums[@]}"; do
    run_and_check "$testdir" "$testnum" "$contrunning" "$verbose" 1
done

exit 0
