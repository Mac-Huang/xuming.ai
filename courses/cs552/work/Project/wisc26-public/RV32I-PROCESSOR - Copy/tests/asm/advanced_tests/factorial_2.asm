# Initialize stack pointer
addi x2, x0, 1024          # x2 = 0x00000400

# Call factorial(2)
addi x10, x0, 2             # arg n = 2
jal  x1, factorial         # x10 <- factorial(2) (pc=0x8)

done:
  ebreak

factorial:
  addi x2, x2, -8
  sw   x1, 4(x2)           # push x1 onto stack
  sw   x10, 0(x2)           # push n onto stack
  beq  x10, x0, base
  addi x10, x10, -1
  jal  x1, factorial       # recursive call (pc=0x24)

  # multiply n * x10 via addition
  lw   x6, 0(x2)           # n
  add  x5, x10, x0
  addi x10, x0, 0
mul_loop:
  beq  x6, x0, mul_done
  add  x10, x10, x5
  addi x6, x6, -1
  jal  x0, mul_loop
mul_done:
  lw   x1, 4(x2)
  addi x2, x2, 8
  jalr x0, 0(x1)

base:
  addi x10, x0, 1
  lw   x1, 4(x2)
  addi x2, x2, 8
  jalr x0, 0(x1)
