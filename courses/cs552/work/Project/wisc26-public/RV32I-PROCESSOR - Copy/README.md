# RV32I Core (CS552 Project 3)

Single-cycle RV32I core in Verilog.

## Architecture
- `hart` (`rtl/hart.v`) is the top level and connects the five stages below.
- **Fetch**: PC register drives instruction memory (`o_imem_raddr`), instruction is read combinationally.
- **Decode** (`rtl/decode.v`):
  - decodes opcode/control (`AluOp`, `MemRead/Write`, `Jump`, `Branch`, etc.)
  - reads register file (`lib/rf.v`)
  - generates immediates via `lib/imm.v`
- **Execute** (`rtl/execute.v`):
  - `lib/alu_control_unit.v` refines decode controls using `Func3/Func7/opcode`
  - `lib/alu.v` computes arithmetic/logic/comparison results
- **Memory** (`rtl/memory.v`):
  - computes aligned dmem address, byte mask, store lane placement
  - decodes/extends load data and raises misalignment trap
- **Writeback** (`rtl/writeback.v`):
  - writes `rd` from one of: `pc+4` (jal/jalr), LUI immediate, load data, ALU result

## Control and PC Flow
- Next PC = `pc + 4` by default.
- Branch/jump target = base (`pc` or `rs1` for `jalr`) + immediate.
- `jalr` clears bit 0 of target per RV32I spec.
- Trap output combines illegal instruction + memory misalign + taken-target PC misalign.

## Repository Layout
- Core RTL: `rtl/`
- Shared blocks: `lib/`
- Full testbench: `tb/tb.v` (`tb/program.mem`)
- Unit tests: `tests/`
