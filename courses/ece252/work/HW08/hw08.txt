; Filename:    hw08.asm
; Author(s):   Xuming Huang
;
;
; Description: Performs various operations on values in
;              various memory locations


        .ORIG x0200
START
        LEA R0, ARRAY             ; get pointer to ARRAY array

        ; YOUR CODE GOES BELOW HERE

        ; Let VAR1 = ARRAY[0]
        LDR R1, R0, #0            ; Load ARRAY[0] into R1
        ST  R1, VAR1              ; Store in VAR1

        ; Let VAR2 = VAR1 + VAR2
        LD  R2, VAR2              ; Load VAR2
        ADD R2, R1, R2            ; Add VAR1 (ARRAY[0]) to VAR2
        ST  R2, VAR2              ; Store updated VAR2

        ; Let ARRAY[3] = ARRAY[1] - VAR2
        NOT R2, R2                ; Take two's complement of VAR2
        ADD R2, R2, #1            ; Convert to negative equivalent (-VAR2)
        LDR R3, R0, #1            ; Load ARRAY[1] into R3
        ADD R4, R3, R2            ; Compute ARRAY[1] - VAR2
        STR R4, R0, #3            ; Store result in ARRAY[3]

        ; YOUR CODE GOES ABOVE HERE

        BR START

        ; program ARRAY

VAR1       .FILL  #2  ; VAR1 = value 1 in decimal
VAR2       .FILL  10  ; VAR2 = value 10 in decimal      
VAR3       .FILL  x14 ; VAR3 = value 20 in decimal


      ; Note: normally we would not comment an array like this,
      ; but we wanted to make it easy to see which element is which

ARRAY    .FILL x0001 ; ARRAY[0]
         .FILL x000F ; ARRAY[1]
         .FILL xFFFF ; ARRAY[2]
         .FILL xFFFE ; ARRAY[3]
         .FILL x0101 ; ARRAY[4]

        .END

