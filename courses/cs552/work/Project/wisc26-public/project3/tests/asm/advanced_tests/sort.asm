  .text
  .align 2       # Make sure we're aligned to 4 bytes
  .globl _start
_start:
# array[0] = 0x00004d0b
  lui  t0, 0x5
  addi t0, t0, -0x2f5
  sw   t0, 0x100(x0)

  # array[1] = 0x0000741e
  lui  t0, 0x7
  addi t0, t0, 0x41e
  sw   t0, 0x104(x0)

  # array[2] = 0x00001ecd
  lui  t0, 0x2
  addi t0, t0, -0x133
  sw   t0, 0x108(x0)

  # array[3] = 0x0000f780
  lui  t0, 0xf
  addi t0, t0, 0x780
  sw   t0, 0x10c(x0)

  # array[4] = 0x00003d58
  lui  t0, 0x4
  addi t0, t0, -0x2a8
  sw   t0, 0x110(x0)

  # array[5] = 0x0000203c
  lui  t0, 0x2
  addi t0, t0, 0x03c
  sw   t0, 0x114(x0)

  # array[6] = 0x00003a4b
  lui  t0, 0x4
  addi t0, t0, -0x5b5
  sw   t0, 0x118(x0)

  # array[7] = 0x0000fae6
  lui  t0, 0x10
  addi t0, t0, -0x51a
  sw   t0, 0x11c(x0)

  # array[8] = 0x00002c96
  lui  t0, 0x3
  addi t0, t0, -0x36a
  sw   t0, 0x120(x0)

  # array[9] = 0x000033a4
  lui  t0, 0x3
  addi t0, t0, 0x3a4
  sw   t0, 0x124(x0)

  # array[10] = 0x0000dc53
  lui  t0, 0xe
  addi t0, t0, -0x3ad
  sw   t0, 0x128(x0)

  # array[11] = 0x0000a942
  lui  t0, 0xb
  addi t0, t0, -0x6be
  sw   t0, 0x12c(x0)

  # array[12] = 0x00006cd1
  lui  t0, 0x7
  addi t0, t0, -0x32f
  sw   t0, 0x130(x0)

  # array[13] = 0x00000a36
  lui  t0, 0x1
  addi t0, t0, -0x5ca
  sw   t0, 0x134(x0)

  # array[14] = 0x000011f0
  lui  t0, 0x1
  addi t0, t0, 0x1f0
  sw   t0, 0x138(x0)

  # array[15] = 0x00009ac3
  lui  t0, 0xa
  addi t0, t0, -0x53d
  sw   t0, 0x13c(x0)

  # array[16] = 0x00002b0a
  lui  t0, 0x3
  addi t0, t0, -0x4f6
  sw   t0, 0x140(x0)

  # array[17] = 0x00000aca
  lui  t0, 0x1
  addi t0, t0, -0x536
  sw   t0, 0x144(x0)

  # array[18] = 0x0000ca4e
  lui  t0, 0xd
  addi t0, t0, -0x5b2
  sw   t0, 0x148(x0)

  # array[19] = 0x0000f3aa
  lui  t0, 0xf
  addi t0, t0, 0x3aa
  sw   t0, 0x14c(x0)



sort:
  # In-place bubble sort of 20 words at base 0x100
  # Outer loop runs (N-1) passes
  addi   t6, x0, 0x13          # outer_pass = N-1 = 19

outer_loop:
  blt  x0, t6, outer_go
  j    success         # done sorting -> report success

outer_go:
  addi   t2, x0, 0x100       # ptr_curr = base
  addi   t3, x0, 0x104       # ptr_next = base + 4
  addi t4, t6, 0       # inner_count = outer_pass

inner_loop:
  beq  t4, x0, next_pass

  lw   t0, 0(t2)       # val_curr
  lw   t1, 0(t3)       # val_next
  bltu t1, t0, do_swap # if next < curr (unsigned), swap

no_swap:
  addi t2, t2, 4       # advance pointers
  addi t3, t3, 4
  addi t4, t4, -1
  beq  x0, x0, inner_loop

do_swap:
  sw   t1, 0(t2)       # write smaller to earlier slot
  sw   t0, 0(t3)       # write larger to later slot
  addi t2, t2, 4
  addi t3, t3, 4
  addi t4, t4, -1
  beq  x0, x0, inner_loop

next_pass:
  addi t6, t6, -1
  beq  x0, x0, outer_loop

# Checks to see if the array is sorted in ascending order.
#
# parameters:
#  a0: Size of the array
#  a1: Location of the array relative to data start (0x100)
# return value:
#  a0: if 0, array is not sorted, if 1, array is sorted
check:
  lw t0, 0x100(a0)      # load earlier value into t0
  addi a0, a0, 1        # add 4 to pointer
  lw t1, 0x100(a1)      # load next value into t1
  sub t0, t1, t0        # t0 should be <= 0
  bgt t0, zero, fail    # The list isn't sorted!
  beq a0, a1, success   # We've checked all values in the list
  beq zero, zero, check # Go on to next location


success:
	li a0, 1
	ebreak
fail:
	li a0, 0xdead
	ebreak
    
end:
  ebreak
