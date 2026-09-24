import subprocess
import random
from fixedint import UInt32

QEMU = "qemu-riscv32"
EXE = "./umul"
NUM_TESTS = 50

def run(input_values: tuple[int, int]) -> int:
    input_str = " ".join(str(val) for val in input_values) + "\n"
    result = subprocess.run(
        [QEMU, EXE],
        input=input_str,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    assert result.returncode == 0, f"Test execution failed with error code: {result.returncode}"
    stderr = result.stderr.strip()
    assert stderr == "", f"Test execution produced error output: {stderr}"

    output = result.stdout.strip()
    value = int(output)
    return value

# Run multiple tests
def test_random():
    for _ in range(NUM_TESTS):
        x, y = random.sample(range(0, 0xFFFFFFFF), 2)
        expected = int(UInt32(x) * UInt32(y))
        result = run((x, y))
        # print(f"testing: {x:08x} * {y:08x} = {expected:08x}, got {result:08x}")
        assert result == expected, f"testing {x:08x} * {y:08x}: expected {expected:08x}, got {result:08x}"
