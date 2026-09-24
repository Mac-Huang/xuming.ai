; File name:   copy2.asm
; Author:      
; Description: copy a value from one memory location
;              to another using LDR and STR

	.ORIG x0200
START
	LEA R0, ANIMALS	; get base address for ANIMALS array
        ; your code below
	LDR R1, R0, #8
	STR R1, R0, #7

	; your code above
        BR START

; program data
ANIMALS	.FILL x1234	; BIRD
	.FILL x7890	; CAT
	.FILL xABCD	; DOG
	.FILL x00FF	; FISH
	.FILL xFF00	; HORSE
	.FILL x1248	; LIZARD
	.FILL x1337	; MONKEY
	.FILL xCAFE	; SALMON
	.FILL xFACE	; TURKEY
	.FILL xBEEF	; ZEBRA

	.END