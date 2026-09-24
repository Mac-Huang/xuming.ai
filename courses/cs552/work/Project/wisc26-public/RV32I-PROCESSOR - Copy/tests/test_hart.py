#!/usr/bin/env python3
"""
Grader-style RV32I hart test runner.

This script assembles each asm test into program.mem, runs the existing
tb/tb.v hart testbench, parses the retire trace and CPI, and prints results in
the same style as the project grader output. It prefers a RISC-V toolchain when
available, but also has a built-in RV32I assembler for the provided tests.

Usage:
    python tests/test_hart.py
    python tests/test_hart.py --include-extra
    python tests/test_hart.py --tests 01add,02addi,sort

Reference trace files are optional. If present, place them under either
traces/reference/<name>.trace or traces/<name>.trace.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUILD_DIR = ROOT / "build" / "hart_grader"

RTL_SRCS = [
    "rtl/cache.v",
    "rtl/hart.v",
    "rtl/decode.v",
    "rtl/execute.v",
    "rtl/memory.v",
    "rtl/writeback.v",
]

LIB_SRCS = [
    "lib/alu.v",
    "lib/alu_control_unit.v",
    "lib/imm.v",
    "lib/rf.v",
]

BASIC_TESTS = [
    "01add",
    "02addi",
    "03and",
    "04andi",
    "05lui",
    "06memory",
    "07or",
    "08ori",
    "09sll",
    "10slli",
    "11slt",
    "12slti",
    "13sltiu",
    "14sltu",
    "15sra",
    "16srai",
    "17srl",
    "18srli",
    "19sub",
    "20xor",
    "21xori",
]

ADVANCED_TESTS = [
    "exhaustive_nobranch",
    "factorial_2",
    "factorial_5",
    "sort",
]

EXTRA_TESTS = [
    "rv32i_instruction_sweep",
]

REFERENCE_CPI = {
    "01add": 4.12,
    "02addi": 4.05,
    "03and": 4.18,
    "04andi": 4.19,
    "05lui": 4.56,
    "06memory": 4.17,
    "07or": 4.11,
    "08ori": 4.43,
    "09sll": 4.11,
    "10slli": 4.12,
    "11slt": 4.06,
    "12slti": 4.14,
    "13sltiu": 4.14,
    "14sltu": 4.06,
    "15sra": 4.04,
    "16srai": 4.12,
    "17srl": 4.07,
    "18srli": 4.11,
    "19sub": 4.11,
    "20xor": 4.16,
    "21xori": 4.32,
    "exhaustive_nobranch": 4.74,
    "factorial_2": 3.46,
    "factorial_5": 2.30,
    "sort": 1.60,
}


class TestHart:
    """Name anchor for grader-style output."""


class ToolError(RuntimeError):
    pass


def resolve_tool(env_name, candidates):
    configured = os.environ.get(env_name)
    if configured:
        return configured

    for candidate in candidates:
        found = shutil.which(candidate)
        if found:
            return found

    raise ToolError(
        "Could not find tool for {}. Tried: {}".format(
            env_name, ", ".join(candidates)
        )
    )


def run_cmd(cmd, cwd=ROOT):
    proc = subprocess.run(
        cmd,
        cwd=str(cwd),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if proc.returncode != 0:
        raise ToolError(
            "Command failed with exit code {}:\n{}\n{}".format(
                proc.returncode, " ".join(str(part) for part in cmd), proc.stdout
            )
        )
    return proc.stdout


def asm_path(name):
    basic = ROOT / "tests" / "asm" / "basic_tests" / "{}.asm".format(name)
    if basic.exists():
        return basic

    advanced = ROOT / "tests" / "asm" / "advanced_tests" / "{}.asm".format(name)
    if advanced.exists():
        return advanced

    raise FileNotFoundError("No asm file found for {}".format(name))


def compile_hart_tb(iverilog):
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    output = BUILD_DIR / "hart_tb.out"
    sources = ["tb/tb.v", "rtl/tb_memory.v"] + RTL_SRCS + LIB_SRCS
    cmd = [iverilog, "-g2001", "-s", "hart_tb", "-o", str(output)]
    cmd.extend(str(ROOT / src) for src in sources)
    run_cmd(cmd)
    return output


REG_ALIASES = {
    "zero": 0,
    "ra": 1,
    "sp": 2,
    "gp": 3,
    "tp": 4,
    "t0": 5,
    "t1": 6,
    "t2": 7,
    "s0": 8,
    "fp": 8,
    "s1": 9,
    "a0": 10,
    "a1": 11,
    "a2": 12,
    "a3": 13,
    "a4": 14,
    "a5": 15,
    "a6": 16,
    "a7": 17,
    "s2": 18,
    "s3": 19,
    "s4": 20,
    "s5": 21,
    "s6": 22,
    "s7": 23,
    "s8": 24,
    "s9": 25,
    "s10": 26,
    "s11": 27,
    "t3": 28,
    "t4": 29,
    "t5": 30,
    "t6": 31,
}


def reg_num(token):
    token = token.strip()
    if re.fullmatch(r"x([0-9]|[12][0-9]|3[01])", token):
        return int(token[1:])
    if token in REG_ALIASES:
        return REG_ALIASES[token]
    raise ValueError("unknown register '{}'".format(token))


def parse_int(token):
    token = token.strip()
    value = int(token, 0)
    return value


def to_signed32(value):
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value & 0x80000000 else value


def sign_extend(value, bits):
    mask = 1 << (bits - 1)
    value &= (1 << bits) - 1
    return value - (1 << bits) if value & mask else value


def parse_mem_operand(token):
    match = re.fullmatch(r"([+-]?(?:0x[0-9a-fA-F]+|\d+))\(([^)]+)\)", token.strip())
    if not match:
        raise ValueError("expected memory operand imm(reg), got '{}'".format(token))
    return parse_int(match.group(1)), reg_num(match.group(2).strip())


def tokenize_instruction(text):
    text = text.strip()
    if not text:
        return None
    pieces = text.split(None, 1)
    op = pieces[0].lower()
    args = []
    if len(pieces) > 1:
        args = [part.strip() for part in pieces[1].replace(",", " ").split()]
    return op, args


def clean_asm_lines(source):
    result = []
    for line_no, raw in enumerate(source.read_text(encoding="utf-8").splitlines(), start=1):
        line = raw.split("#", 1)[0].strip()
        if line:
            result.append((line_no, line))
    return result


def expanded_size(op, args):
    if op == "li":
        value = to_signed32(parse_int(args[1]))
        if -2048 <= value <= 2047:
            return 1
        return 1 if (value & 0xFFF) == 0 else 2
    return 1


def collect_labels_and_entries(source):
    labels = {}
    entries = []
    pc = 0

    for line_no, line in clean_asm_lines(source):
        if line.startswith("."):
            continue

        while True:
            match = re.match(r"^([A-Za-z_.$][\w.$]*):\s*(.*)$", line)
            if not match:
                break
            labels[match.group(1)] = pc
            line = match.group(2).strip()
            if not line:
                break

        if not line:
            continue
        if line.startswith("."):
            continue

        parsed = tokenize_instruction(line)
        if parsed is None:
            continue
        op, args = parsed
        entries.append((pc, op, args, line_no))
        pc += 4 * expanded_size(op, args)

    return labels, entries


def encode_r(funct7, rs2, rs1, funct3, rd, opcode=0x33):
    return (
        ((funct7 & 0x7F) << 25)
        | ((rs2 & 0x1F) << 20)
        | ((rs1 & 0x1F) << 15)
        | ((funct3 & 0x7) << 12)
        | ((rd & 0x1F) << 7)
        | (opcode & 0x7F)
    )


def encode_i(imm, rs1, funct3, rd, opcode):
    return (
        ((imm & 0xFFF) << 20)
        | ((rs1 & 0x1F) << 15)
        | ((funct3 & 0x7) << 12)
        | ((rd & 0x1F) << 7)
        | (opcode & 0x7F)
    )


def encode_s(imm, rs2, rs1, funct3):
    imm &= 0xFFF
    return (
        ((imm >> 5) << 25)
        | ((rs2 & 0x1F) << 20)
        | ((rs1 & 0x1F) << 15)
        | ((funct3 & 0x7) << 12)
        | ((imm & 0x1F) << 7)
        | 0x23
    )


def encode_b(imm, rs2, rs1, funct3):
    if imm % 2 != 0:
        raise ValueError("branch target offset is not 2-byte aligned")
    imm &= 0x1FFF
    return (
        (((imm >> 12) & 0x1) << 31)
        | (((imm >> 5) & 0x3F) << 25)
        | ((rs2 & 0x1F) << 20)
        | ((rs1 & 0x1F) << 15)
        | ((funct3 & 0x7) << 12)
        | (((imm >> 1) & 0xF) << 8)
        | (((imm >> 11) & 0x1) << 7)
        | 0x63
    )


def encode_u(imm20, rd, opcode):
    return ((imm20 & 0xFFFFF) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)


def encode_j(imm, rd):
    if imm % 2 != 0:
        raise ValueError("jump target offset is not 2-byte aligned")
    imm &= 0x1FFFFF
    return (
        (((imm >> 20) & 0x1) << 31)
        | (((imm >> 1) & 0x3FF) << 21)
        | (((imm >> 11) & 0x1) << 20)
        | (((imm >> 12) & 0xFF) << 12)
        | ((rd & 0x1F) << 7)
        | 0x6F
    )


R_FUNCS = {
    "add": (0x00, 0x0),
    "sub": (0x20, 0x0),
    "sll": (0x00, 0x1),
    "slt": (0x00, 0x2),
    "sltu": (0x00, 0x3),
    "xor": (0x00, 0x4),
    "srl": (0x00, 0x5),
    "sra": (0x20, 0x5),
    "or": (0x00, 0x6),
    "and": (0x00, 0x7),
}

I_FUNCS = {
    "addi": 0x0,
    "slti": 0x2,
    "sltiu": 0x3,
    "xori": 0x4,
    "ori": 0x6,
    "andi": 0x7,
}

LOAD_FUNCS = {
    "lb": 0x0,
    "lh": 0x1,
    "lw": 0x2,
    "lbu": 0x4,
    "lhu": 0x5,
}

STORE_FUNCS = {
    "sb": 0x0,
    "sh": 0x1,
    "sw": 0x2,
}

BRANCH_FUNCS = {
    "beq": 0x0,
    "bne": 0x1,
    "blt": 0x4,
    "bge": 0x5,
    "bltu": 0x6,
    "bgeu": 0x7,
}


def expand_li(rd, value):
    value = to_signed32(value)
    if -2048 <= value <= 2047:
        return [encode_i(value, 0, 0x0, rd, 0x13)]

    hi = (value + 0x800) >> 12
    lo = value - (hi << 12)
    words = [encode_u(hi, rd, 0x37)]
    if lo != 0:
        words.append(encode_i(lo, rd, 0x0, rd, 0x13))
    return words


def label_offset(labels, label, pc):
    if label not in labels:
        raise ValueError("unknown label '{}'".format(label))
    return labels[label] - pc


def encode_one(pc, op, args, labels):
    if op == "li":
        return expand_li(reg_num(args[0]), parse_int(args[1]))

    if op == "j":
        return [encode_j(label_offset(labels, args[0], pc), 0)]

    if op == "ret":
        return [encode_i(0, 1, 0x0, 0, 0x67)]

    if op == "bgt":
        offset = label_offset(labels, args[2], pc)
        return [encode_b(offset, reg_num(args[0]), reg_num(args[1]), 0x4)]

    if op in R_FUNCS:
        funct7, funct3 = R_FUNCS[op]
        return [encode_r(funct7, reg_num(args[2]), reg_num(args[1]), funct3, reg_num(args[0]))]

    if op in I_FUNCS:
        return [encode_i(parse_int(args[2]), reg_num(args[1]), I_FUNCS[op], reg_num(args[0]), 0x13)]

    if op in ("slli", "srli", "srai"):
        funct3 = 0x1 if op == "slli" else 0x5
        funct7 = 0x20 if op == "srai" else 0x00
        shamt = parse_int(args[2]) & 0x1F
        imm = (funct7 << 5) | shamt
        return [encode_i(imm, reg_num(args[1]), funct3, reg_num(args[0]), 0x13)]

    if op in LOAD_FUNCS:
        imm, rs1 = parse_mem_operand(args[1])
        return [encode_i(imm, rs1, LOAD_FUNCS[op], reg_num(args[0]), 0x03)]

    if op in STORE_FUNCS:
        imm, rs1 = parse_mem_operand(args[1])
        return [encode_s(imm, reg_num(args[0]), rs1, STORE_FUNCS[op])]

    if op in BRANCH_FUNCS:
        offset = label_offset(labels, args[2], pc)
        return [encode_b(offset, reg_num(args[1]), reg_num(args[0]), BRANCH_FUNCS[op])]

    if op == "jal":
        if len(args) == 1:
            rd = 1
            label = args[0]
        else:
            rd = reg_num(args[0])
            label = args[1]
        return [encode_j(label_offset(labels, label, pc), rd)]

    if op == "jalr":
        imm, rs1 = parse_mem_operand(args[1])
        return [encode_i(imm, rs1, 0x0, reg_num(args[0]), 0x67)]

    if op == "lui":
        return [encode_u(parse_int(args[1]), reg_num(args[0]), 0x37)]

    if op == "auipc":
        return [encode_u(parse_int(args[1]), reg_num(args[0]), 0x17)]

    if op == "ebreak":
        return [0x00100073]

    raise ValueError("unsupported instruction '{}' at pc 0x{:08x}".format(op, pc))


def assemble_builtin(source, case_dir):
    labels, entries = collect_labels_and_entries(source)
    words = []
    for pc, op, args, line_no in entries:
        try:
            words.extend(encode_one(pc, op, args, labels))
        except Exception as exc:
            raise ToolError("{}:{}: {}".format(source, line_no, exc))

    binary = case_dir / "program.bin"
    data = bytearray()
    for word in words:
        data.extend((word & 0xFFFFFFFF).to_bytes(4, byteorder="little"))
    binary.write_bytes(bytes(data))
    return binary


def assemble_with_as(assembler, objcopy, source, case_dir):
    obj = case_dir / "program.o"
    binary = case_dir / "program.bin"
    run_cmd(
        [
            assembler,
            "-march=rv32i",
            "-mabi=ilp32",
            "-o",
            str(obj),
            str(source),
        ]
    )
    run_cmd([objcopy, "-O", "binary", "-j", ".text", str(obj), str(binary)])
    return binary


def assemble_with_gcc(gcc, objcopy, source, case_dir):
    elf = case_dir / "program.elf"
    binary = case_dir / "program.bin"
    run_cmd(
        [
            gcc,
            "-march=rv32i",
            "-mabi=ilp32",
            "-nostdlib",
            "-nostartfiles",
            "-Wl,-Ttext=0x0",
            "-Wl,--no-relax",
            "-o",
            str(elf),
            str(source),
        ]
    )
    run_cmd([objcopy, "-O", "binary", "-j", ".text", str(elf), str(binary)])
    return binary


def write_program_mem(binary, case_dir):
    data = binary.read_bytes()
    if not data:
        raise ToolError("Assembler produced an empty binary: {}".format(binary))

    mem = case_dir / "program.mem"
    lines = []
    for index in range(0, len(data), 4):
        lines.append(" ".join("{:02x}".format(byte) for byte in data[index:index + 4]))
    mem.write_text("\n".join(lines) + "\n", encoding="ascii")
    return mem


def assemble_program(name, toolchain, case_dir):
    source = asm_path(name)
    case_dir.mkdir(parents=True, exist_ok=True)

    if toolchain["as"] and toolchain["objcopy"]:
        binary = assemble_with_as(toolchain["as"], toolchain["objcopy"], source, case_dir)
    elif toolchain["gcc"] and toolchain["objcopy"]:
        binary = assemble_with_gcc(toolchain["gcc"], toolchain["objcopy"], source, case_dir)
    else:
        binary = assemble_builtin(source, case_dir)

    return write_program_mem(binary, case_dir)


def parse_sim_output(output):
    trace = [line.rstrip() for line in output.splitlines() if line.startswith("[")]
    cpi_match = re.search(r"CPI:\s+([0-9]+(?:\.[0-9]+)?)", output)
    cycles_match = re.search(r"Program halted after\s+([0-9]+)\s+cycles\.", output)
    retired_match = re.search(r"Total instructions retired:\s+([0-9]+)", output)

    a0_writes = []
    for line in trace:
        match = re.search(r"w\[\s*10\]=([0-9a-fA-F]{8})", line)
        if match:
            a0_writes.append(int(match.group(1), 16))

    return {
        "trace": trace,
        "cpi": float(cpi_match.group(1)) if cpi_match else None,
        "cycles": int(cycles_match.group(1)) if cycles_match else None,
        "retired": int(retired_match.group(1)) if retired_match else None,
        "halted": "Program halted after" in output,
        "timed_out": "Program did not halt" in output,
        "trap": any(" TRAP" in line for line in trace),
        "last_a0": a0_writes[-1] if a0_writes else None,
        "raw": output,
    }


def reference_trace_path(name, reference_dir):
    candidates = []
    if reference_dir:
        candidates.extend([
            Path(reference_dir) / "{}.trace".format(name),
            Path(reference_dir) / "{}.txt".format(name),
        ])
    candidates.extend([
        ROOT / "traces" / "reference" / "{}.trace".format(name),
        ROOT / "traces" / "reference" / "{}.txt".format(name),
        ROOT / "traces" / "{}.trace".format(name),
        ROOT / "traces" / "{}.txt".format(name),
    ])

    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None


def load_reference_trace(path):
    lines = path.read_text(encoding="utf-8").splitlines()
    return [line.rstrip() for line in lines if line.startswith("[")]


def compare_traces(name, trace, reference_dir, require_reference):
    ref_path = reference_trace_path(name, reference_dir)
    if ref_path is None:
        if require_reference:
            raise AssertionError("Missing reference trace for {}".format(name))
        return "skipped", None

    expected = load_reference_trace(ref_path)
    if trace != expected:
        limit = min(len(trace), len(expected))
        mismatch = limit
        for index in range(limit):
            if trace[index] != expected[index]:
                mismatch = index
                break
        detail = "trace mismatch at line {}".format(mismatch + 1)
        if mismatch < len(expected):
            detail += "\n  expected: {}".format(expected[mismatch])
        if mismatch < len(trace):
            detail += "\n  actual:   {}".format(trace[mismatch])
        if len(trace) != len(expected):
            detail += "\n  expected lines: {}, actual lines: {}".format(
                len(expected), len(trace)
            )
        raise AssertionError("{}: {}".format(name, detail))

    return "matched", ref_path


def validate_execution(name, parsed):
    if parsed["timed_out"] or not parsed["halted"]:
        raise AssertionError("{} did not halt".format(name))
    if parsed["trap"]:
        raise AssertionError("{} retired a trap".format(name))
    if parsed["cpi"] is None:
        raise AssertionError("{} did not print CPI".format(name))

    source = asm_path(name).read_text(encoding="utf-8")
    has_failure_path = "fail:" in source or "fail :" in source
    has_success_path = "pass:" in source or "success:" in source

    if has_failure_path and parsed["last_a0"] == 0x0000DEAD:
        raise AssertionError("{} reached fail path with a0=0xdead".format(name))
    if has_failure_path and has_success_path and parsed["last_a0"] != 1:
        raise AssertionError(
            "{} did not finish with pass value a0=1".format(name)
        )


def run_student(name, hart_out, vvp, toolchain):
    case_dir = BUILD_DIR / name
    assemble_program(name, toolchain, case_dir)
    output = run_cmd([vvp, str(hart_out)], cwd=case_dir)
    parsed = parse_sim_output(output)
    validate_execution(name, parsed)
    return parsed


def cpi_message(reference, student, tolerance):
    diff = student - reference
    if abs(diff) < 0.005:
        return (
            diff,
            "Student implementation is the same speed as the reference implementation. Great job!",
        )

    percent = abs(diff) / reference * 100.0
    if diff < 0:
        return (
            diff,
            "Student implementation is {:.2f}% faster than the reference implementation. Fantastic!".format(
                percent
            ),
        )

    message = "Student implementation is {:.2f}% slower than the reference implementation.".format(
        percent
    )
    if diff <= tolerance:
        message += "\nCPI difference is within acceptable tolerance, so it's close enough. Nice work!"
    else:
        message += "\nCPI difference exceeds tolerance."
    return diff, message


def print_trace_result(index, name, status):
    print("{}) test_{} (test_hart.TestHart) (1/1)".format(index, name))
    if status == "matched":
        print("All trace lines match for {}!".format(name))
    else:
        print("Trace comparison skipped for {}: no reference trace found.".format(name))


def print_cpi_result(index, name, reference, student, tolerance):
    diff, message = cpi_message(reference, student, tolerance)
    print("{}) test_{}_cpi (test_hart.TestHart) (4/4)".format(index, name))
    print("=== CPI Results for {} ===".format(name))
    print("Reference Implementation: {:.2f}".format(reference))
    print("Student: {:.2f}".format(student))
    print("CPI Difference: {:.2f}".format(diff))
    print()
    print(message)


def selected_tests(args):
    default = BASIC_TESTS + ADVANCED_TESTS
    if args.include_extra:
        default = default + EXTRA_TESTS

    if not args.tests:
        return default

    requested = [item.strip() for item in args.tests.split(",") if item.strip()]
    known = set(default + EXTRA_TESTS)
    unknown = [item for item in requested if item not in known]
    if unknown:
        raise ValueError("Unknown test names: {}".format(", ".join(unknown)))
    return requested


def optional_tool(env_name, candidates):
    try:
        return resolve_tool(env_name, candidates)
    except ToolError:
        return None


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--tests", help="Comma-separated test names to run.")
    parser.add_argument(
        "--include-extra",
        action="store_true",
        help="Also run rv32i_instruction_sweep.",
    )
    parser.add_argument(
        "--reference-dir",
        help="Directory containing <test>.trace or <test>.txt reference traces.",
    )
    parser.add_argument(
        "--require-reference-trace",
        action="store_true",
        help="Fail if a reference trace is missing.",
    )
    parser.add_argument(
        "--tolerance",
        type=float,
        default=0.30,
        help="Allowed CPI slowdown before the CPI section fails.",
    )
    args = parser.parse_args(argv)

    try:
        tests = selected_tests(args)
        iverilog = resolve_tool("IVERILOG", ["iverilog", "iverilog.exe"])
        vvp = resolve_tool("VVP", ["vvp", "vvp.exe"])
        objcopy = optional_tool(
            "RISCV_OBJCOPY",
            [
                "riscv64-unknown-elf-objcopy",
                "riscv32-unknown-elf-objcopy",
                "riscv64-linux-gnu-objcopy",
            ],
        )
        assembler = optional_tool(
            "RISCV_AS",
            [
                "riscv64-unknown-elf-as",
                "riscv32-unknown-elf-as",
                "riscv64-linux-gnu-as",
            ],
        )
        gcc = optional_tool(
            "RISCV_GCC",
            [
                "riscv64-unknown-elf-gcc",
                "riscv32-unknown-elf-gcc",
                "riscv64-linux-gnu-gcc",
            ],
        )
        toolchain = {"as": assembler, "gcc": gcc, "objcopy": objcopy}
        hart_out = compile_hart_tb(iverilog)

        failures = []
        for test_index, name in enumerate(tests, start=1):
            try:
                parsed = run_student(name, hart_out, vvp, toolchain)
                trace_status, _ = compare_traces(
                    name,
                    parsed["trace"],
                    args.reference_dir,
                    args.require_reference_trace,
                )
                print_trace_result(test_index, name, trace_status)

                reference = REFERENCE_CPI.get(name)
                if reference is None:
                    print("{}.1) test_{}_cpi (test_hart.TestHart) (0/0)".format(test_index, name))
                    print("=== CPI Results for {} ===".format(name))
                    print("Reference Implementation: unavailable")
                    print("Student: {:.2f}".format(parsed["cpi"]))
                    print("CPI Difference: unavailable")
                else:
                    print_cpi_result(
                        "{}.1".format(test_index),
                        name,
                        reference,
                        parsed["cpi"],
                        args.tolerance,
                    )
                print()
            except Exception as exc:
                failures.append((name, exc))
                print("{}) test_{} (test_hart.TestHart) (0/1)".format(test_index, name))
                print("FAIL {}: {}".format(name, exc))
                print()

        if failures:
            print("{} test(s) failed.".format(len(failures)))
            return 1
        return 0
    except Exception as exc:
        print("ERROR: {}".format(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
