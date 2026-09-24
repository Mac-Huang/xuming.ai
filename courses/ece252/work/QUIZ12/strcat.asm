        .orig x3000

START   
	; first show initial strings before modification
	
        ; print all three strings on one line
	LEA	R0, LF	; print newline
	PUTS
	LEA	R0, S1	; print the strings
	PUTS
	LEA	R0, S2
	PUTS
	LEA	R0, S3
	PUTS
	LEA	R0, LF	; print newline
	PUTS

TEST1	; first test
	LEA	R1, S2
	LEA	R2, S3
	JSR	STRCAT	; append S2 to S3
			; after subroutine returns, S3 should be "horse+bird+"

        ; print all three strings on one line
	LEA	R0, S1	; print the strings
	PUTS
	LEA	R0, S2
	PUTS
	LEA	R0, S3
	PUTS
	LEA	R0, LF	; print newline
	PUTS

TEST2	; second test
	LEA	R1, S1
	LEA	R2, S3
	JSR	STRCAT	; append S1 to S3
			; after subroutine returns, S3 should be "horse+bird+cat+"

        ; print all three strings on one line
	LEA	R0, S1	; print the strings
	PUTS
	LEA	R0, S2
	PUTS
	LEA	R0, S3
	PUTS
	LEA	R0, LF	; print newline
	PUTS

	HALT		; end program

; test data
LF	.STRINGZ	"\n" 
S1	.STRINGZ	"cat+"
S2	.STRINGZ	"bird+"
S3	.STRINGZ	"horse+"
	.BLKW	16	; extra space



; STRCPY
; Copy source string to destination
; Assumes: R1 - source string address
;          R2 - destination address
; Returns: Nothing

; -- put your STRCPY subroutine and its data below here --
STRCPY
	ST R0, STRCPY_R0
	ST R1, STRCPY_R1
	ST R2, STRCPY_R2	; context save

STRCPY_LOOP
    LDR R0, R1, #0        ; Load char from source
    STR R0, R2, #0        ; Store to destination
    BRz STRCPY_EXIT       ; Done if null terminator

    ADD R1, R1, #1        ; Move to next char (src)
    ADD R2, R2, #1        ; Move to next char (dest)
    BR STRCPY_LOOP        ; Repeat

STRCPY_EXIT
	LD R0, STRCPY_R0
	LD R1, STRCPY_R1
	LD R2, STRCPY_R2	; context restore
	RET

STRCPY_R0 .BLKW	1
STRCPY_R1 .BLKW	1
STRCPY_R2 .BLKW	1
; -- put your STRCPY subroutine and its data above here --


; ONLY TURN IN YOUR STRCAT SUBROUTINE CODE AND ITS DATA.
; DO NOT TURN IN THE CALLER CODE AND DATA ABOVE

; DO NOT MODIFY ANYTHING ABOVE HERE *EXCEPT* FOR COPYING
; IN YOUR **TESTED AND WORKING** STRCPY SUBROUTINE

; STRCAT
; Append source string to destination
; Assumes: R1 - source string address
;          R2 - destination address
; Returns: Nothing
STRCAT
	ST R0, STRCAT_R0
	ST R1, STRCAT_R1
	ST R2, STRCAT_R2
	ST R7, STRCAT_R7			; context save

	;Find the end of the destination string
STRCAT_DES_END_LOOP
	LDR R0, R2, #0
	BRz STRCAT_COPY
	ADD R2, R2, #1
	BR STRCAT_DES_END_LOOP

STRCAT_COPY
	JSR STRCPY

STRCAT_EXIT
	LD R0, STRCAT_R0
	LD R1, STRCAT_R1
	LD R2, STRCAT_R2
	LD R7, STRCAT_R7			; context restore
	RET

STRCAT_R0 .BLKW	1
STRCAT_R1 .BLKW	1
STRCAT_R2 .BLKW	1
STRCAT_R7 .BLKW	1
	.end
       