; Filename:    hw11B_mult.asm
;
; Description: Test Bench for MULT function


        .ORIG x0200
START

        ; YOUR CODE GOES BELOW HERE
        LD  R3, NUM_TESTS 
        LEA R4, MULT_TABLE

HW11B_MULT_START
       
        ; Load A
        LDR R0, R4, #0

        ; Load B
        LDR R1, R4, #1

        ; Load Expected Results
        LDR R2, R4, #2

        ; Multiply AxB
        JSR MULT

        ; Check Resuts
        ADD R0, R2, R0

        BRnp ERROR

        ; Move to next test
        ADD R4, R4, #3

        ; Decrement Test Count 
        ADD R3, R3, #-1

        BRp HW11B_MULT_START
       
SUCCESS    BR SUCCESS

ERROR  BR ERROR

NUM_TESTS   .FILL    6

             ; Test 1
MULT_TABLE  .FILL    0  ; A
            .FILL   10  ; B
            .FILL    0  ; A x B = 0

             ; Test 2
            .FILL   10  ; A
            .FILL    0  ; B
            .FILL    0  ; A x B = 0
             ; Test 3
            .FILL    3  ; A
            .FILL   30  ; B
            .FILL   -90 ; A x B = 90
             ; Test 4
            .FILL   30  ; A
            .FILL    3  ; B
            .FILL   -90 ; A x B = 90
             ; Test 5
            .FILL   21  ; A
            .FILL    4  ; B
            .FILL   -84 ; A x B = 84
             ; Test 6
            .FILL  112  ; A
            .FILL   10  ; B
            .FILL -1120 ; A x B = 1120

;************************************
; Multiples two numbers AxB
;
; Parameters
;   R0 - A 
;   R1 - B 
;Returns 
;   R0 - AxB
;
; Author(s):   Xuming Huang
;              
;************************************
MULT
        ST R2, MULT_R2
        AND R2, R2, #0

        ADD R1, R1, #0
        BRp MULT_LOOP
        AND R0, R0, #0
        BR END_SUB

MULT_LOOP
        ADD R2, R2, R0
        ADD R1, R1, #-1
        BRp MULT_LOOP

        ADD R0, R2, #0
        LD R2, MULT_R2
END_SUB
    RET

MULT_R2 .BLKW 1
	.END

