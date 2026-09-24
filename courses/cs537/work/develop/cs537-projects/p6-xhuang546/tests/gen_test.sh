#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_test_number> <target_test_number>"
    echo "Example: $0 1 7"
    exit 1
fi

SRC=$1
TGT=$2

echo "Generating plumbing files for test $TGT based on test $SRC..."

cd tests

# 1. Copy and replace 'test_X' with 'test_Y' in pre, run, and post
for ext in pre run post; do
    if [ -f "${SRC}.${ext}" ]; then
        sed "s/test_${SRC}/test_${TGT}/g" "${SRC}.${ext}" > "${TGT}.${ext}"
        echo "Created ${TGT}.${ext}"
    else
        echo "Warning: Source file ${SRC}.${ext} not found. Skipping."
    fi
done

# 2. Directly copy rc and out (since they are identical for all passing tests)
for ext in rc out err; do
    if [ -f "${SRC}.${ext}" ]; then
        cp "${SRC}.${ext}" "${TGT}.${ext}"
        echo "Created ${TGT}.${ext}"
    else
        echo "Warning: Source file ${SRC}.${ext} not found. Skipping."
    fi
done

# 3. Create an empty desc file
touch "${TGT}.desc"
echo "Created empty ${TGT}.desc (Don't forget to write your one-sentence summary here!)"

echo "All done!"
