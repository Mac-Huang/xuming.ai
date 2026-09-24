## Author: Xuming Huang
##
## You may implement the following with any of the instructions in the RV32I instruction set
## and described in the reference sheet. Do not use any of the mul[h][s][u] instructions which
## are *not* described in the reference sheet. Remember to respect the calling convention - if
## you choose to use any of the callee saved registers s[0-11], remember to save them to the
## stack before reusing them (note, you should not need to do this but are free to do so).
##
## [Description]
## Multiplies two 32-bit *unsigned* numbers and provides a 32-bit *unsigned* result
## consisting of the lower 32 bits of the product.
##
## [Arguments]
## a0 = multiplicand
## a1 = multiplier
##
## [Returns]
## a0 = 32-bit product
    .text
    .globl umul
umul:
    # Save callee-saved registers
    addi sp, sp, -16     # Allocate stack space
    sw   s0, 0(sp)       # Save s0
    sw   s1, 4(sp)       # Save s1
    sw   s2, 8(sp)       # Save s2

    # Initialize result and counter
    addi s0, zero, 0    # s0 = result = 0
    addi s1, a1, 0      # s1 = multiplier
    addi s2, zero, 0    # s2 = comparator = 0

multiply_loop:
    beq  s1, zero, end_loop  # If multiplier is 0, end loop
    andi s2, s1, 1           # Check if LSB of multiplier is 1
    beq  s2, zero, skip_add  # If LSB is 0, skip addition
    add  s0, s0, a0          # result += multiplic

skip_add:
    srl  s1, s1, 1         # multiplier >>= 1
    sll  a0, a0, 1         # multiplicand <<= 1
    j    multiply_loop     # Repeat loop

end_loop:
    addi a0, s0, 0         # Move result to a0

    # Restore callee-saved registers
    lw   s0, 0(sp)       # Restore s0
    lw   s1, 4(sp)       # Restore s1
    lw   s2, 8(sp)       # Restore s2
    addi sp, sp, 16      # Free stack space
    
    jalr zero, 0(ra)     # Return