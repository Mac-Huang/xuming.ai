; Filename:    hw11B.asm
;
; Description: Performs various operations on values in
;              various memory locations


        .ORIG x0200
START

        ;DO NOT MODIFY the function calls below 

        LEA R0, RT1
        JSR DRAW_RECTANGLE
        LEA R0, RT2
        JSR DRAW_RECTANGLE
        LEA R0, RT3
        JSR DRAW_RECTANGLE
        LEA R0, RT4
        JSR DRAW_RECTANGLE
        LEA R0, RT5
        JSR DRAW_RECTANGLE
        LEA R0, RT6
        JSR DRAW_RECTANGLE
        LEA R0, RT7
        JSR DRAW_RECTANGLE
        LEA R0, RT8
        JSR DRAW_RECTANGLE
        LEA R0, RT9
        JSR DRAW_RECTANGLE
        LEA R0, RT10
        JSR DRAW_RECTANGLE


HW11B_END    BR HW11B_END

RT1         .FILL x7C00 ; Color
            .FILL 10     ; Row 
            .FILL 10    ; Col 
            .FILL 10    ; Width
            .FILL 90   ; Height
            
RT2         .FILL x7C00 ; Color
            .FILL 10     ; Row 
            .FILL 10    ; Col 
            .FILL 100    ; Width
            .FILL 10   ; Height

RT3         .FILL x7C00 ; Color
            .FILL 10    ; Row
            .FILL 110    ; Col 
            .FILL 10    ; Width
            .FILL 90    ; Height

RT4         .FILL x7C00 ; Color
            .FILL 100    ; Row
            .FILL 10    ; Col 
            .FILL 110    ; Width
            .FILL 10    ; Height

RT5         .FILL x03E0 ; Color
            .FILL 30     ; Row 
            .FILL 30    ; Col 
            .FILL 10    ; Width
            .FILL 60   ; Height

RT6         .FILL x03E0 ; Color
            .FILL 30     ; Row 
            .FILL 30    ; Col 
            .FILL 70    ; Width
            .FILL 10   ; Height

RT7         .FILL x03E0 ; Color
            .FILL 80     ; Row 
            .FILL 30    ; Col 
            .FILL 70    ; Width
            .FILL 10   ; Height

RT8         .FILL x03E0 ; Color
            .FILL 30     ; Row 
            .FILL 90    ; Col 
            .FILL 10    ; Width
            .FILL 60   ; Height

RT9         .FILL x7FFF ; Color
            .FILL 60     ; Row 
            .FILL 50    ; Col 
            .FILL 10    ; Width
            .FILL 10   ; Height

RT10         .FILL x7FFF ; Color
            .FILL 60     ; Row 
            .FILL 70    ; Col 
            .FILL 10    ; Width
            .FILL 10   ; Height

LCD_START       .FILL xC000
LCD_ROW_OFFSET  .FILL x80
;*****************************************************
; Draws a square based on the information stored at
; the memory location supplied in R0
;
; Parameter
;   R0 - Address of Rectangle Info
; Returns
;   Nothing 
;
; Author(s):   Xuming Huang
;              
;*****************************************************
DRAW_RECTANGLE
    ST R0, DRAW_RECTANGLE_R0
    ST R4, DRAW_RECTANGLE_R4
    ST R5, DRAW_RECTANGLE_R5
    ST R6, DRAW_RECTANGLE_R6
    ST R7, DRAW_RECTANGLE_R7

    ;Invalid Parameter to Check
    LDR R4, R0, #4 ; Height
    BRz END_DRAW_RECTANGLE
    LDR R3, R0, #3 ; Width
    BRz END_DRAW_RECTANGLE
    LDR R2, R0, #2 ; Col
    LDR R1, R0, #1 ; Row
    LDR R0, R0, #0 ; Color

    LD R6, CONST1
    ADD R5, R4, R1
    ADD R5, R5, R6
    BRp END_DRAW_RECTANGLE
    LD R6, CONST2
    ADD R5, R3, R2
    ADD R5, R5, R6
    BRp END_DRAW_RECTANGLE

DRAW_RECTANGLE_LOOP
    JSR DRAW_ROW
    ADD R1, R1, #1
    ADD R4, R4, #-1
    BRp DRAW_RECTANGLE_LOOP

    LD R0, DRAW_RECTANGLE_R0
    LD R4, DRAW_RECTANGLE_R4
    LD R5, DRAW_RECTANGLE_R5
    LD R6, DRAW_RECTANGLE_R6
    LD R7, DRAW_RECTANGLE_R7
END_DRAW_RECTANGLE
    RET
    
    ; subroutine data
CONST1 .FILL #-127
CONST2 .FILL #-123
DRAW_RECTANGLE_R0 .BLKW	1
DRAW_RECTANGLE_R1 .BLKW 1
DRAW_RECTANGLE_R2 .BLKW 1
DRAW_RECTANGLE_R4 .BLKW 1
DRAW_RECTANGLE_R5 .BLKW	1
DRAW_RECTANGLE_R6 .BLKW	1
DRAW_RECTANGLE_R7 .BLKW 1

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
    ST R0, ROW_COLOR
    ;Use R5 to store the address
    ST R5, DRAW_ROW_R5
    ;In order to reuse R3
    ST R3, WIDTH
    ST R1, DRAW_ROW_R1

    ;R0 = x0080
    LD R0, LCD_ROW_OFFSET
    ;R0 = row * x0080
    JSR MULT
    ;R1 = row * x0080
    ADD R1, R0, #0
    ;R0 = ROW_COLOR
    LD R0, ROW_COLOR

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

    LD R1, DRAW_ROW_R1
    LD R3, WIDTH
    LD R5, DRAW_ROW_R5
    LD R7, DRAW_ROW_R7
        RET

    ; subroutine data
DRAW_ROW_R1 .BLKW 1
DRAW_ROW_R5 .BLKW 1
DRAW_ROW_R7 .BLKW 1
ROW_COLOR .BLKW	1
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

