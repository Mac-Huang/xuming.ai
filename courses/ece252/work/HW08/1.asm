; File name:   copy1.asm
; Author:      
; Description: copy a value from one memory location
;              to another using LD and ST

	.ORIG x0200
START
        ; your code below
	LD R0 TURKEY
	ST R0 SALMON
	; your code above
        BR START

; program data
BIRD    .FILL x1234
CAT     .FILL x7890
DOG     .FILL xABCD
FISH    .FILL x00FF
HORSE   .FILL xFF00
LIZARD  .FILL x1248
MONKEY  .FILL x1337
SALMON  .FILL xCAFE
TURKEY  .FILL xFACE
ZEBRA   .FILL xBEEF

	.END