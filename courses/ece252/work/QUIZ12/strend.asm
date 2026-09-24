; Filename:    strend.asm
; Author:      252 Staff
; Description: test program for finding the end of
;              a null-terminated string

        .orig x0200

START   
	LEA	R1, S1
	JSR	STREND
	LEA	R1, S6
	JSR	STREND
	LEA	R1, S2
	JSR	STREND
	LEA	R1, S5
	JSR	STREND
	LEA	R1, S3
	JSR	STREND
	LEA	R1, S4
	JSR	STREND
	LEA	R1, S7
	JSR 	STREND
		
	BR	START	; loop forever

S1	.STRINGZ	"Ciao!"
S2	.STRINGZ	"Hi!"
S3	.STRINGZ	"Salve!"
S4	.STRINGZ	"Hello!"
S5	.STRINGZ	"Gelato!"
S6	.STRINGZ	""
S7	.STRINGZ	"Italiano"

; Subroutine:  STREND
; Description: Finds address of ASCIIZ terminator
; Assumes:     R1 = address of start of ASCIIZ string
; Returns:     R1 = address of null terminator
STREND
	ST	R0, STREND_R0	; context save

STREND_LOOP
	LDR	R0, R1, #0	; get current character
	BRz	STREND_EXIT	; at null terminator?
	
	ADD	R1, R1, #1	; increment string pointer
	BR	STREND_LOOP

STREND_EXIT
	LD	R0, STREND_R0	; context restore
	RET

STREND_R0	.BLKW	1	

		
	.end
        