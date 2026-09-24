;******************************************************************************
; Filename:    hw12.asm
; Author:      Xuming Huang 
;			   
; Description: Prompts user to enter one number and then prompts user to check 
;              the number in R1 prior to continuing
;******************************************************************************
	.ORIG x3000
START    

	; Prompt user to enter a number, store it in R1
	LEA R0, PROMPT1		; get address of first prompt
	PUTS				; display prompt to enter a number	
	JSR GET_NUM			; call your GET_NUM subroutin, number returned in R1
	
	LEA R0, PROMPT2		; get address of second prompt			
	PUTS				; display second prompt	
	GETC				; wait for a key press	
						
	; Do it all again
	BR START			; jump to start of program

;; Reserve Prompt strings
PROMPT1 .STRINGZ "\nEnter a number (0-32767):"
PROMPT2 .STRINGZ "R1 now contains your number (hit any key to continue)"





;******************************************************************************
; Subroutine:  GET_NUM
; Description: Returns decimal number user entered in R1
; 
; NOTE: Processes characters till it sees x000A (new line) (Enter Key)
;       User should only enter decimal digits and numbers less than 32767
;       Routine does not do any error checking of bad user data
; 
; NOTE: This routine does call another routine (MULT10)
;
; Assumes      Nothing
; Returns      R1 - the decimal number user entered
;
; R0 will hold result of GETC
; R1 (which is return value) will be accumulator
; R2 is general purpose temporary register
; R3 will hold -0x000A for compare to new line
; R4 will hold -0x0030 for casting char to num
;******************************************************************************
GET_NUM
	; YOUR CODE GOES BELOW HERE
	
	; store context
	ST R2, GET_NUM_R2
	ST R3, GET_NUM_R3
	ST R4, GET_NUM_R4
	ST R7, GET_NUM_R7
	
	; initialize stuff
	AND R0, R0, #0				;OUT must hold R0[15:8] as 0
	AND R1, R1, #0				;R1 as the accum (amount) should be 0 first
	LD R3, GET_NUM_ENTER_KEY	;Load the constants to Register in order
	LD R4, GET_NUM_BIAS			;to have quicker access to process data

	
	; get number via a loop with GETC and accumulate result in R1
GET_NUM_LOOP
	GETC				;R0[7:0] holds hold result of GETC, a character
	OUT
	ADD R2, R0, R3
	BRz END_GET_NUM		;Is char=0x0A?
	JSR MULT10			;Multiplies accum 10 times
	ADD R0, R0, R4
	ADD R1, R1, R0
	BR GET_NUM_LOOP

END_GET_NUM
	; restore context
	LD R2, GET_NUM_R2
	LD R3, GET_NUM_R3
	LD R4, GET_NUM_R4
	LD R7, GET_NUM_R7
	RET

	; reserve space for context save and constants (-0x0A and -0x30)
GET_NUM_ENTER_KEY 	.FILL	xFFF6	; -x000A
GET_NUM_BIAS 		.FILL	xFFD0   ; -x0030 ('0')

GET_NUM_R2 			.BLKW	1
GET_NUM_R3 			.BLKW	1
GET_NUM_R4 			.BLKW	1
GET_NUM_R7 			.BLKW	1

	; YOUR CODE GOES ABOVE HERE
	
	
	
;******************************************************************************
; Subroutine:  MULT10
; Description: Multiplies number in R1 by 10
;
; Assumes      R1
; Returns      R1 => R1*10
;
;******************************************************************************	
MULT10
    ; context save
    ST R0, MULT10_R0
	
	; perform computation
	ADD R0, R1, R1;		; have 2X now in R0
	ADD R1, R0, R0		; have 4X now in R1
	ADD R1, R1, R1		; have 8X now in R1
	ADD R1, R1, R0		; have 10X now in R1
	
	; context restore
	LD R0, MULT10_R0
	RET
	
MULT10_R0 .BLKW 1

	.END

 
