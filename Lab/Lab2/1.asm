;
; Program to calculate a variant of the Fibonacci sequence
; p is stored in x3100, q in x3101, N in x3102. the result F(N) is stored in x3103
; 
; Initialization
        .ORIG   x3000
        AND     R0, R0, #0
        AND     R1, R1, #0
        AND     R2, R2, #0
        AND     R3, R3, #0
        AND     R4, R4, #0
        AND     R5, R5, #0
        AND     R6, R6, #0
        AND     R7, R7, #0
        LDI     R1, P   
        NOT     R1, R1
        ADD     R1, R1, #1    ;Initialize R1 with -p
        LDI     R2, Q   
        NOT     R2, R2
        ADD     R2, R2, #1    ;Initialize R2 with -q
        LDI     R3, N
        ADD     R3, R3, #-1   ;Initialize R3 with N-1 (used as a counter)
        AND     R4, R4, #0    ;CLEAR R4
        AND     R5, R5, #0    ;CLEAR R5
        ADD     R4, R4, #1    ;Initialize R4 with F(0)
        ADD     R5, R5, #1    ;Initialize R5 with F(1)
;
CalC    JSR     MODP          ;Calculate F(n-2)%p, stored in R4
        AND     R0, R0, #0    ;CLEAR R0 to store F(n-1),which is going to be F(n-2) in the next loop.
        JSR     MODQ          ;Calculate F(n-1)%q, stored in R5. Meanwhile,store the original F(n-1) in R0
        ADD     R5, R4, R5    ;Store the result of F(n-2)%p + F(n-1)%q in R5,which is going to be F(n-2) in the next loop.
        AND     R4, R4, #0    ;CLEAR R4
        ADD     R4, R0, R4    ;R4 <- R0
        ADD     R3, R3, #-1   ;COUNTER--
        BRp     CalC
        STI      R5, RESULT
        TRAP    x25
;
MODP    ADD     R4, R4, R1   
        BRzp    MODP
        LDI     R1, P
        ADD     R4, R4, R1
        NOT     R1, R1
        ADD     R1, R1, #1
        RET
;
MODQ    ADD     R0, R0, R5    ; R0 <- R5
 MARK   ADD     R5, R5, R2
        BRzp    MARK
        LDI     R2, Q
        ADD     R5, R5, R2
        NOT     R2, R2
        ADD     R2, R2, #1
        RET
;
   P    .FILL   X3100
   Q    .FILL   X3101   
   N    .FILL   X3102
RESULT  .FILL   x3103
        .END