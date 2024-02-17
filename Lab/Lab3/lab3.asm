; A program to figure out the length of the longest-duplicate-substring
; Given a String S and its length N, N is stored in x3100, S is stored started from x3101
; Output is stored in x3050

; Initialization
        .ORIG   x3000
        AND     R0, R0, #0 ; Used to store N
        AND     R1, R1, #0 ; Used as a pointer of the string
        AND     R2, R2, #0 ; Used to store result
        AND     R3, R3, #0 ; Used to store the former character
        AND     R4, R4, #0 ; Used to store the latter character
        AND     R5, R5, #0 ; Used to store the deplicate-substring length of every loop
        AND     R6, R6, #0
        AND     R7, R7, #0 
        ; Clear all registers
        LDI     R0, NUM
        LD      R1, DATA
        ADD     R2, R2, #1 ; Initialize R2 as 1
        ADD     R5, R5, #1 ; Initialize R5 as 1
;
LOOP    ADD     R0, R0, #-1
        BRz     DIFF        ;In the last round, we should compare R5 with R2
        BRn     STOP
        LDR     R3, R1, #0  ;store the former character
        ADD     R1, R1, #1  
        LDR     R4, R1, #0  ;store the latter character
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R3, R4  ;R4 <-（R3-R4),to compare
        BRz     SAME
        BRnp    DIFF
;        
SAME    ADD     R5, R5, #1
        BR      LOOP
;       
DIFF    NOT     R2, R2
        ADD     R2, R2, #1
        ADD     R6, R5, R2 ;R6 <- (R5-R2),to compare
        BRn     LESS
        BRp     MORE
        BRz     LOOP
;        
LESS    ADD     R2, R2, #-1 ;R5 < R2
        NOT     R2, R2
        AND     R5, R5, #0
        ADD     R5, R5, #1
        BR      LOOP
;        
MORE    AND     R2, R2, #0 
        ADD     R2, R5, R2
        AND     R5, R5, #0
        ADD     R5, R5, #1
        BR      LOOP
;        
STOP    STI     R2,RESULT
        HALT
;
RESULT .FILL    x3050
NUM    .FILL    x3100
DATA   .FILL    X3101
       .END
