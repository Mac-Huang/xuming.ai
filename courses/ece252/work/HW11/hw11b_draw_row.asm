; Filename:    hw11b_draw_row.asm
;
; Description: Performs various operations on values in
;              various memory locations


        .ORIG x0200
START

        
        LEA R6, TEST1
        LDR R0, R6, #0
        LDR R1, R6, #1
        LDR R2, R6, #2
        LDR R3, R6, #3
        JSR DRAW_ROW    ; Verify that a 30 pixel line is drawn in the 
                        ; middle of the screen 


HW11B_END    BR HW11B_END

LCD_START       .FILL xC000
LCD_ROW_OFFSET  .FILL x80

TEST1           .FILL x7C00 ; Color 
                .FILL 64    ; Row Number
                .FILL 52    ; Col Number
                .FILL 30    ; Width (Num Pixels) 
           
;**********************************************
; Draws a row on the LCD.  The left most
; pixel is located at (Row, Col).  The 
; last pixel is located at (Row, Col + Width)
;
; Parameters
; R0 - Color of the row
; R1 - Row Number
; R2 - Col Number
; R3 - Width
;
; Returns
; Nothing
;
; Author(s):   Xuming Huang
;              
;**********************************************
DRAW_ROW
    ;Save RET address from R7
    ST R7, DRAW_ROW_R7
    ;Save R0 - Color of the row first
    ST R0, COLOR
    ;Use R5 to store the address
    ST R5, DRAW_ROW_R5
    ;In order to reuse R3
    ST R3, WIDTH

    ;R0 = x0080
    LD R0, LCD_ROW_OFFSET
    ;R0 = row * x0080
    JSR MULT
    ;R1 = row * x0080
    ADD R1, R0, #0
    ;R0 = COLOR
    LD R0, COLOR

    ;R5 = xC000
    LD R5, LCD_START
    ;R5 = row * x0080 + xC000
    ADD R5, R5, R1
    ;R0 = row * x0080 + xC000 + col
    ADD R5, R5, R2

DRAW_LOOP
    STR R0, R5, #0
    ADD R5, R5, #1
    ADD R3, R3, #-1
    BRp DRAW_LOOP

    LD R3, WIDTH
    LD R5, DRAW_ROW_R5
    LD R7, DRAW_ROW_R7
        RET

    ; subroutine data
DRAW_ROW_R7 .BLKW 1
DRAW_ROW_R5 .BLKW 1
COLOR .BLKW	1
WIDTH .BLKW	1

;************************************
; Multiples two numbers AxB
;
; Parameters
;   R0 - A 
;   R1 - B 
;Returns 
;   R0 - AxB
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

