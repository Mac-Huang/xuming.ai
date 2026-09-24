; Filename:    hw09.asm
; Author(s):   Xuming Huang         
;
; Description: Performs control operations
              
        .ORIG x0200

START
        ; Let R4 = 1 which can be used a couple times
        AND R4, R4, #0
        ADD R4, R4, #1

        ; Array[0] == 254
        LEA R0, ARRAY
        LDR R1, R0, #0          ; Array[0]
        LDR R2, R0, #2          ; Constant 254 for comparison
        NOT R2, R2
        ADD R2, R2, #1          ; R2 = -254
        ADD R3, R1, R2          ; R3 = Array[0] - 254
        BRz LABEL1              ; If zero, match; else, continue

        ; K = 1
        ST R4, K

        ; M = P
        LD R5, P
        ST R5, M
        BR LABEL2


LABEL1  AND R6, R6, #0          ; R6 = 0
        ST R6, K

        ; Array[1] > 77
        LDR R1, R0, #1          ; Array[1]
        LDR R2, R0, #3          ; Constant 77 for comparison
        NOT R2, R2
        ADD R2, R2, #1          ; R2 = -77
        ADD R3, R1, R2          ; R3 = Array[1] - 77
        BRnz LABEL3             ; If > 77, R3 > 0, so skip

        ST R4, M                ; M = 1

LABEL2  ST R4, N                ; N = 1
        BR DONE

LABEL3  ST R6, M                ; M = 0
        ADD R6, R6, #10         ; R6 = 10
        ST R6, N                ; N = 10

DONE    BR DONE                 ; Infinite loop

; ======================
; Memory Locations
; ======================

K       .FILL  xFFFF      
M       .FILL  xFFFF     
N       .FILL  xFFFF       
P       .FILL  xCAFE 

ARRAY   .FILL 254            ; Array[0]
        .FILL 10             ; Array[1]
        .FILL 254            ; Used as constant for comparison
        .FILL 77             ; Used as constant for comparison

        .END
