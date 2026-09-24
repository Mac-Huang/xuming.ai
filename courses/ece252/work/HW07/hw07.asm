; File name:   hw07.asm
; Author:      
; Description: short code fragments for homework 07

	.ORIG x0200
START	; Initialize registers to arbitrary values because the
	; fact that PennSim shows them initially equal to 0 is
	; not actually realistic. Register values are unknown
	; until the programmer puts a known value into them.
	LD R0, REG0
	LD R1, REG1
	LD R2, REG2
	LD R3, REG3
	LD R4, REG4
	LD R5, REG5
	LD R6, REG6
	LD R7, REG7

TEST
        ; PUT YOUR CODE BELOW HERE
	NOT R2, R6
	ADD R2, R2, #1
	ADD R2, R0, R2

	; PUT YOUR CODE ABOVE HERE

        BR START

REG0	.FILL x420E
REG1	.FILL x29A2
REG2	.FILL xC085
REG3	.FILL x5A97
REG4	.FILL xE143
REG5	.FILL x6728
REG6	.FILL xB81C
REG7	.FILL x9C6B


	.END
