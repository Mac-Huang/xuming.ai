    .text
    .option norvc
    .align 2
    .globl _start

_start:
    ################################################################
    # ADD/SUB and logical register-register instructions
    ################################################################
    addi x1, x0, 7
    addi x2, x0, 5
    add  x5, x1, x2
    addi x6, x0, 12
    bne  x5, x6, fail

    sub  x5, x1, x2
    addi x6, x0, 2
    bne  x5, x6, fail

    addi x1, x0, 240         # 0x0f0
    addi x2, x0, 204         # 0x0cc
    and  x5, x1, x2
    addi x6, x0, 192         # 0x0c0
    bne  x5, x6, fail

    or   x5, x1, x2
    addi x6, x0, 252         # 0x0fc
    bne  x5, x6, fail

    xor  x5, x1, x2
    addi x6, x0, 60          # 0x03c
    bne  x5, x6, fail

    ################################################################
    # Immediate logical/arithmetic instructions
    ################################################################
    andi x5, x1, 204
    addi x6, x0, 192
    bne  x5, x6, fail

    ori  x5, x1, 15
    addi x6, x0, 255
    bne  x5, x6, fail

    xori x5, x1, 255
    addi x6, x0, 15
    bne  x5, x6, fail

    addi x5, x0, -1
    addi x6, x0, -1
    bne  x5, x6, fail

    ################################################################
    # Shifts
    ################################################################
    addi x1, x0, 3
    addi x2, x0, 4
    sll  x5, x1, x2
    addi x6, x0, 48
    bne  x5, x6, fail

    slli x5, x1, 4
    addi x6, x0, 48
    bne  x5, x6, fail

    addi x1, x0, 64
    addi x2, x0, 2
    srl  x5, x1, x2
    addi x6, x0, 16
    bne  x5, x6, fail

    srli x5, x1, 2
    addi x6, x0, 16
    bne  x5, x6, fail

    addi x1, x0, -16
    addi x2, x0, 2
    sra  x5, x1, x2
    addi x6, x0, -4
    bne  x5, x6, fail

    srai x5, x1, 2
    addi x6, x0, -4
    bne  x5, x6, fail

    srl  x5, x1, x2
    lui  x6, 0x40000
    addi x6, x6, -4        # 0x3ffffffc
    bne  x5, x6, fail

    ################################################################
    # Signed and unsigned comparisons
    ################################################################
    addi x1, x0, -1
    addi x2, x0, 1
    slt  x5, x1, x2
    addi x6, x0, 1
    bne  x5, x6, fail

    sltu x5, x1, x2
    addi x6, x0, 0
    bne  x5, x6, fail

    slti x5, x1, 0
    addi x6, x0, 1
    bne  x5, x6, fail

    sltiu x5, x1, 1
    addi  x6, x0, 0
    bne   x5, x6, fail

    sltiu x5, x2, 2
    addi  x6, x0, 1
    bne   x5, x6, fail

    ################################################################
    # U-type instructions
    ################################################################
    lui  x5, 0x12345
    lui  x6, 0x12345
    bne  x5, x6, fail

    auipc x5, 0
    jal   x6, after_auipc
after_auipc:
    addi  x6, x6, -8
    bne   x5, x6, fail

    ################################################################
    # Branches
    ################################################################
    addi x1, x0, 5
    addi x2, x0, 5
    beq  x1, x2, beq_ok
    jal  x0, fail
beq_ok:
    bne  x1, x2, fail

    addi x2, x0, 6
    bne  x1, x2, bne_ok
    jal  x0, fail
bne_ok:
    blt  x1, x2, blt_ok
    jal  x0, fail
blt_ok:
    bge  x2, x1, bge_ok
    jal  x0, fail
bge_ok:
    addi x1, x0, -1
    addi x2, x0, 1
    bltu x2, x1, bltu_ok
    jal  x0, fail
bltu_ok:
    bgeu x1, x2, bgeu_ok
    jal  x0, fail
bgeu_ok:

    ################################################################
    # JAL and JALR
    ################################################################
    jal   x5, jal_target
    jal   x0, fail
jal_target:
    auipc x6, 0
    addi  x6, x6, -4
    bne   x5, x6, fail

    jal   x5, jalr_base
jalr_base:
    addi  x5, x5, 16
    jalr  x6, 0(x5)
    jal   x0, fail
    jal   x0, fail
jalr_target:
    auipc x7, 0
    addi  x7, x7, -8
    bne   x6, x7, fail

    ################################################################
    # Loads, stores, byte masks, and sign/zero extension
    ################################################################
    addi x8, x0, 0
    addi x8, x8, 256        # data base = 0x100

    lui  x1, 0x12345
    addi x1, x1, 1656       # 0x12345678
    sw   x1, 0(x8)
    lw   x5, 0(x8)
    bne  x5, x1, fail

    addi x1, x0, -1234
    sh   x1, 4(x8)
    lh   x5, 4(x8)
    bne  x5, x1, fail
    lhu  x5, 4(x8)
    lui  x6, 0x10
    addi x6, x6, -1234      # 0x0000fb2e
    bne  x5, x6, fail

    addi x1, x0, -123
    sb   x1, 6(x8)
    lb   x5, 6(x8)
    bne  x5, x1, fail
    lbu  x5, 6(x8)
    addi x6, x0, 133
    bne  x5, x6, fail

pass:
    addi x10, x0, 1
    ebreak

fail:
    lui  x10, 0x0000e
    addi x10, x10, -339     # 0x0000dead
    ebreak
