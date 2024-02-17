; Unfortunately we have not YET installed Windows or Linux on the LC-3,
; so we are going to have to write some operating system code to enable
; keyboard interrupts. The OS code does three things:
;
;    (1) Initializes the interrupt vector table with the starting
;        address of the interrupt service routine. The keyboard
;        interrupt vector is x80 and the interrupt vector table begins
;        at memory location x0100. The keyboard interrupt service routine
;        begins at x1000. Therefore, we must initialize memory location
;        x0180 with the value x1000.
;    (2) Sets bit 14 of the KBSR to enable interrupts.
;    (3) Pushes a PSR and PC to the system stack so that it can jump
;        to the user program at x3000 using an RTI instruction.

        .ORIG x800
        ; (1) Initialize interrupt vector table.
        LD R0, VEC
        LD R1, ISR
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR.
        LDI R0, KBSR
        LD R1, MASK
        NOT R1, R1
        AND R0, R0, R1
        NOT R1, R1
        ADD R0, R0, R1
        STI R0, KBSR

        ; (3) Set up system stack to enter user space. 
        LD R0, PSR
        ADD R6, R6, #-1
        STR R0, R6, #0
        LD R0, PC
        ADD R6, R6, #-1
        STR R0, R6, #0
        ; Enter user space.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1000
KBSR    .FILL xFE00
MASK    .FILL x4000
PSR     .FILL x8002
PC      .FILL x3000
        .END

        .ORIG x3000
        ; *** Begin user program code here ***
        AND R2, R2, #0
        STI R2, FLAG ; set a flag to justify when to stop waiting
AGAIN   LEA R0, STUDID
        PUTS
        JSR DELAY
        LDI R2, FLAG
        BRz AGAIN
        
        LD  R6, STACK ; USP
        LDI R0, HANON ; N
        JSR HANOI
        
        LEA R0, ENDING1 ; Print "Tower of Hanoi needs "
        PUTS
        
        STI R1, RESULT
        ; Now we get the result in R1
        ; However, we should split every digit in order to print the digit to the screen
        LD  R2, NHUND ; R2 <- -100
        AND R0, R0, #0 ; Clear R0 as a counter
CALC1   ADD R1, R1, R2 ; R1-100        
        BRn END1
        ADD R0, R0, #1
        BR  CALC1
END1    LD  R2, PHUND ; R2 <- 100
        ADD R1, R2, R1 ; Now The Hundred digit is clear, next we handle the Ten digit the same way
        LD  R2, ASC
        ADD R0, R0, R2 ; R0 is now set to the value which is in ASCII (R0 + 48
OUTPUT1 LDI R3, DSR2
        BRzp OUTPUT1
        STI R0, DDR2
        
        AND R0, R0, #0
        LD  R2, NTEN 
CALC2   ADD R1, R1, R2 
        BRn END2
        ADD R0, R0, #1
        BR  CALC2
END2    LD  R2, PTEN
        ADD R1, R1, R2
        LD  R2, ASC
        ADD R0, R0, R2
OUTPUT2 LDI R3, DSR2
        BRzp OUTPUT2
        STI R0, DDR2
        
        AND R0, R0, #0
        AND R2, R2, #0
        ADD R2, R2, #-1
CALC3   ADD R1, R1, R2
        BRn END3
        ADD R0, R0, #1
        BR  CALC3
END3    ADD R1, R1, #1
        LD  R2, ASC
        ADD R0, R0, R2
OUTPUT3 LDI R3, DSR2
        BRzp OUTPUT3
        STI R0, DDR2
        
        LEA R0, ENDING2
        PUTS
        
        HALT
        
DELAY   ST  R1, SaveR1
        LD  R1, COUNT
REP     ADD R1, R1, #-1
        BRp REP
        LD  R1, SaveR1
        RET
COUNT   .FILL  #5000
SaveR1  .BLKW  1
    
HANOI   ADD R6, R6, #-1
        STR R7, R6, #0 ; Push R7, the return linkage
        ADD R6, R6, #-1
        STR R0, R6, #0 ; Push R0, the value of n
        ADD R6, R6, #-1
        STR R2, R6, #0 ; Push R2, which is needed in the subroutine
        
        ;check for base case
        AND R2, R0, #-1
        BRnp SKIP      ; Z=0 if R0=0
        ADD R1, R0, #0 ; RO is the answer
        BR   DONE
       
        ;Not a base case, do the recursion
SKIP    ADD R0, R0, #-1
        JSR HANOI
        ADD R1, R1, R1
        ADD R1, R1, #1 ; R1 = 2*H(n-1) + 1
        
        ; Restore registers and return
DONE    LDR R2, R6, #0
        ADD R6, R6, #1
        LDR R0, R6, #0
        ADD R6, R6, #1
        LDR R7, R6, #0
        ADD R6, R6, #1
        RET
       

FLAG    .FILL  x5000
STUDID	.STRINGZ  "PB21071416 "
STACK   .FILL  x7000 ; USP for Recursion
HANON   .FILL  x3FFF ; N
ENDING1 .STRINGZ "Tower of Hanoi needs "
ENDING2 .STRINGZ " moves."
DSR2   .FILL xFE04
DDR2   .FILL xFE06
RESULT .FILL x7001
PHUND  .FILL #100
NHUND  .FILL #-100
PTEN   .FILL #10
NTEN   .FILL #-10
ASC    .FILL #48
        ; *** End user program code here ***
        .END

        .ORIG x3FFF
        ; *** Begin hanoi data here ***
HANOI_N .FILL xFFFF
        ; *** End hanoi data here ***
        .END

        .ORIG x1000
        ; *** Begin interrupt service routine code here ***、
LOOP0   LDI  R0, DSR1
        BRzp LOOP0
        LD   R1, BREA
        STI  R1, DDR1
        
        AND  R5, R5, #0 ; R5 used as a temporary flag
LOOP1   LDI  R0, KBSR1
        BRzp LOOP1
        LDI  R1, KBDR1
        ; Judge whether the input is legal
        LD   R3, CLR
        AND  R2, R1, R3 ; R2 -> x00__
        LD   R3, ASC0
        ADD  R4, R2, R3 ; Input - 0
        BRn  INL
        LD   R3, ASC9
        ADD  R4, R2, R3 ; Input - 9
        BRp  INL   
        
        LD   R3, ASC0  ; Input - 0 (to store
        ADD  R2, R2, R3
        STI  R2, HANO
LOOP2   LDI  R0, DSR1    ; Input is legal
        BRzp LOOP2
        STI  R1, DDR1
        ADD  R5, R5, #1
        STI  R5, FLAG1   ; Set flag as 1 (legal)
        LEA  R3, STRL
LOOP3   LDR  R0, R3, #0
        BRz  STOP
LOOP4   LDI  R4, DSR1
        BRzp LOOP4
        STI  R0, DDR1
        ADD  R3, R3, #1
        BR   LOOP3

INL     LDI  R0, DSR1
        BRzp INL
        STI  R1, DDR1
        LEA  R3, STRI
INL1    LDR  R0, R3, #0
        BRz  STOP
INL2    LDI  R4, DSR1
        BRzp INL2
        STI  R0, DDR1
        ADD  R3, R3, #1
        BR   INL1
STOP    LDI  R0, DSR1
        BRzp STOP
        LD   R1, BREA
        STI  R1, DDR1
        RTI
KBSR1  .FILL xFE00
KBDR1  .FILL xFE02
DSR1   .FILL xFE04
DDR1   .FILL xFE06
CLR    .FILL x00FF
ASC0   .FILL #-48  
ASC9   .FILL #-57  
FLAG1  .FILL x5000
BREA   .FILL x000A  ; line feed
STRL   .STRINGZ  " is a decimal digit."
STRI   .STRINGZ  " is not a decimal digit."
HANO   .FILL x3FFF
        ; *** End interrupt service routine code here ***
        .END