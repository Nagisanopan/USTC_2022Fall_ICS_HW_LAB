; A program to sort and count the score of 16 students
; Each score is stored in succesive memory locations starting with x4000
; Each score is an interger between 0 and 100
; Everyone gets a different score
;
; Sort
        .ORIG   x3000
        AND     R0, R0, #0 ; Used as pointer
        AND     R1, R1, #0 ; Store the current minimum
        AND     R2, R2, #0 ; Store the current number
        AND     R3, R3, #0 
        AND     R4, R4, #0 ; Store a relative number x-400F to judge when to jump out of the loop
        AND     R5, R5, #0 
        AND     R6, R6, #0 ; Store the times of the loop, totally 16 times
        AND     R7, R7, #0 
        ; Clear all registers 
ROUND   LD      R0, DATA 
        LD      R1, MAX ; A very large number
        LD      R4, REL 
LOOP    ADD     R5, R0, R4 ; Pointer -x400F, if Pointer > x400F jump out of the loop
        BRp     NEXT
        LDR     R2, R0, #0
        NOT     R1, R1
        ADD     R1, R1, #1
        ADD     R3, R2, R1 ; Compare R2 and the current minimum by calculating R2-R1
        BRn     RENEW      ; R2 < R1, thus renew R1
        BRzp    STAY       ; R2 > R1, don't renew R1
RENEW   AND     R1, R1, #0
        ADD     R1, R2, #0 ; R1 <- R2
        STI     R0, MINP  ; Store the current minimum pointer in address MINP
        ADD     R0, R0, #1 ; Pointer++
        BR      LOOP
STAY    ADD     R1, R1, #-1
        NOT     R1, R1
        ADD     R0, R0, #1
        BR      LOOP
NEXT    LD      R0, RESULT
        ADD     R0, R0, R6
        ADD     R6, R6, #1
        ADD     R3, R6, #-16
        BRp     COUNT
        STR     R1, R0, #0 ; Store the outcome in target position
        LDI     R0, MINP   
        LD      R1, MAX
        STR     R1, R0, #0 ; Change the position of the outcome to a very large number
        BR      ROUND
; Count
COUNT   LD      R0, MAXI ; Store the pointer of the maximum
        LD      R1, CRIA ; Store the criterion of A, but a negative one
        LD      R2, CRIB ; same as above
        AND     R5, R5, #0 ; Clear R5, used as a counter
        AND     R6, R6, #0 ; Clear R6, used to judge when to jump out of the loop
JUDA    LDR     R3, R0, #0
        ADD     R4, R3, R1 ; R3 - 85 
        BRzp    QUAA  ; Qualified A
        BRn     UNQA  ; Unqualified A
QUAA    ADD     R5, R5, #1
        ADD     R6, R6, #1
        ADD     R0, R0, #-1
        ADD     R4, R6, #-3 ; R6 - 3
        BRnz    JUDA
        BRp     GOOUT
UNQA    ADD     R4, R3, R2 ; R3 -75
        BRzp    NABB ; Not A But  B
        BRn     DONE 
NABB    ADD     R7, R7, #1 ; R7 is used to count B
DONE    ADD     R6, R6, #1
        ADD     R0, R0, #-1
        ADD     R4, R6, #-3 ; R6 - 3
        BRnz    JUDA
        BRp     GOOUT
GOOUT   STI     R5, NUMA ; Store the outcome of A
        AND     R6, R6, #0 ; Clear R6
JUDB    LDR     R3, R0, #0
        ADD     R4, R3, R2; R3 - 75
        BRzp    QUAB 
        BRn     UNQB
QUAB    ADD     R7, R7, #1
        ADD     R6, R6, #1
        ADD     R0, R0, #-1
        ADD     R4, R6, #-3 ; R6 - 3
        BRnz     JUDB
        BRp    STOP
UNQB    ADD     R6, R6, #1
        ADD     R0, R0, #-1
        ADD     R4, R6, #-3 ; R6 - 3
        BRnz    JUDB
        BRp     STOP
STOP    STI     R7, NUMB
        HALT
        
DATA   .FILL    x4000
MAX    .FILL    x0FFF
REL    .FILL    x-400F
MINP   .FILL    x3F00  ; MINP is a place to store the temporary min num pointer
RESULT .FILL    x5000
MAXI   .FILL    x500F
NUMA   .FILL    x5100
NUMB   .FILL    x5101
CRIA   .FILL    xFFAB  ; criterion A：85 point 
CRIB   .FILL    xFFB5  ; criterion B: 75 point
       .END
