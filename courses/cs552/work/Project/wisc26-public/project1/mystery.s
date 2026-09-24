main:
    addi t5, zero, 8    # load 8 into t5
    slli t5, t5, 2      # t5 = 8 * 4 = 32
    sub  t0, a0, t5     # t0 = n - 32 (a0 = n)
    slli t1, t0, 2      # t1 = (n - 32) * 4
    add  t1, t1, t0     # t1 = (n - 32) * 5
    addi t2, zero, 0    # t2 = 0
    addi t3, t1, 0      # t3 = t1 = (n - 32) * 5
    addi t4, zero, 9    # t4 = 9
loop:
    blt  t3, t4, done   # if t3 = (n - 32) * 5 < 9, done
    sub  t3, t3, t4     # t3 -= 9 <=> t3 = (n - 32) * 5 - 9
    addi t2, t2, 1      # t2 += 1 (So t2 is the counter)
    beq  zero, zero, loop # j loop
# Once (n - 32) * 5 - 9 * t2 < 9, go to done
done:
    addi a0, t2, 0      # got quotient of (n - 32) * 5 / 9 in a0
    jalr zero, 0(ra)
