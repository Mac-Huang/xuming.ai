import subprocess
import random
from fixedint import UInt32

QEMU = "qemu-riscv32"
EXE = "./dot"
NUM_TESTS = 50
MAXN = 1024

def run(a: list[int], b: list[int]) -> int:
    assert len(a) == len(b)
    a_s = " ".join(str(val) for val in a)
    b_s = " ".join(str(val) for val in b)
    input_str = f"{len(a)}\n{a_s}\n{b_s}\n"
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

# Run multiple tests - starting with small cases
def test_random():
    for _ in range(NUM_TESTS // 2):
        n = 5
        a = random.sample(range(0, 0xFFFFFFFF), n)
        b = random.sample(range(0, 0xFFFFFFFF), n)
        expected = int(sum(UInt32(x) * UInt32(y) for x, y in zip(a, b)))
        result = run(a, b)

        a_s = "[" + ", ".join(f"{val:08x}" for val in a) + "]"
        b_s = "[" + ", ".join(f"{val:08x}" for val in b) + "]"
        message = f"A: {a_s}\nB: {b_s}\n expected {expected:08x}, got {result:08x}"
        assert result == expected, message

    for _ in range(NUM_TESTS // 2):
        n = random.randint(1, MAXN)
        a = random.sample(range(0, 0xFFFFFFFF), n)
        b = random.sample(range(0, 0xFFFFFFFF), n)
        expected = int(sum(UInt32(x) * UInt32(y) for x, y in zip(a, b)))
        result = run(a, b)

        a_s = "[" + ", ".join(f"{val:08x}" for val in a) + "]"
        b_s = "[" + ", ".join(f"{val:08x}" for val in b) + "]"
        message = f"A: {a_s}\nB: {b_s}\n expected {expected:08x}, got {result:08x}"
        assert result == expected, message
