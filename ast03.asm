; *****************************************************************
; Name: Abdelrahman Hassan
; NSHE_ID: 5009131902
; Section: 1001
; Assignment: 3
; Description: 
; *****************************************************************

%macro printArray 3
pushReg
        ; %1 -> array to print
        ; %2 -> address of length variable (byte)
        ; %3 -> address of endOfLineDecision maker
        mov r12, 1
        %%startArrayPrint:
            cmp r12b, byte[%2]
            jge %%endArrayPrint

            mov rax, r12
            mov rdx, 0
            mov r11, 10
            div r11
            cmp rdx, 0
            je %%setNewLine

            mov qword[%3], 2
            jmp %%currNumberPrint

            %%setNewLine:
                mov qword[%3], 1

            %%currNumberPrint:
                printNumber qword[%1+r12*8-8], qword[%3]
            inc r12
            jmp %%startArrayPrint
        %%endArrayPrint:
        endl

popReg
%endmacro

%macro pushReg 0
    ; Pushing all registert to make it a globally compatible macro
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbp
%endmacro

%macro popReg 0
    ; Popping all registert to make it a globally compatible macro
    pop rbp
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%macro printNumber 2
    ; Only Prints 64-bit Numbers (so sign/zero extend as needed)
    ; %1 -> number ot be printed
    ; %2 -> 0; if to print nothing after the number
    ;    -> 1; if to print new line after the number
    ;    -> 2; if to print space after the number
    pushReg
    mov rax, %1
    mov r10, 0
    mov r11, 10
    mov r14, 8
    mov r15, 0
    mov rsi, -1

    %%startConversion:
        cmp rax, 0
        je %%printNumberInternal

        cmp rax, 0
        jl %%negativeDivision

            mov rdx, 0
            div r11
            add rdx, 48
            push rdx
            inc r10
            jmp %%startConversion
        
        %%negativeDivision:
            mov r15, 1
            imul rsi
            jmp %%startConversion
    %%printNumberInternal:
        cmp r15, 0
        je %%noNegative

            mov rax, 1
            mov rdi, 1
            mov rsi, negSign
            mov rdx, 1
            syscall

        %%noNegative:
        cmp r10, 0
        jne %%printNumberInteral2
            add r10, 48
            push r10

            mov rax, 1
            mov rdi, 1
            lea rsi, qword[rsp]
            mov rdx, 1
            syscall

            pop r10
            sub r10, 48
            jmp %%finalChecks

        %%printNumberInteral2:
        mov r8, 0
        mov r13, r10
        %%printTillEnd:
            mov rax, 1
            mov rdi, 1
            lea rsi, qword[rsp+r8*8]
            mov rdx, 1
            syscall
            inc r8

            cmp r8, r13
            jl %%printTillEnd

        %%finalChecks:
        cmp %2, 0
        je %%noMorePrints

        cmp %2, 1
        jne %%spacePrint
        endl
        jmp %%noMorePrints

        %%spacePrint:
        cmp %2, 2
        jne %%noMorePrints
        push r10
            mov rax, 1
            mov rdi, 1
            mov rsi, spaceMsg
            mov rdx, 1
            syscall
        pop r10

        %%noMorePrints:
            mov rax, r10
            mul r14
            add rsp, rax
    %%endProgram_macro:
    popReg
%endmacro

%macro endl 0
    pushReg
        mov rax, 1
        mov rdi, 1
        mov rsi, nlMessage
        mov rdx, 1
        syscall
    popReg
%endmacro

%macro findLength 1
    mov rdx, 0
    %%startLoop2:
        cmp byte[%1+rdx], NULL
        je %%endLoop2
        inc rdx
        jmp %%startLoop2
    %%endLoop2:

%endmacro

%macro cout 2
    ; %1 -> message to be printed
    ; %2 -> 0; if to print nothing after the number
    ;    -> 1; if to print new line after the number
    ;    -> 2; if to print space after the number
    pushReg

    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    findLength %1
    syscall

    cmp %2, 0
    je %%noMorePrints

    cmp %2, 1
    jne %%spacePrint
        endl
        jmp %%noMorePrints

    %%spacePrint:
        cmp %2, 2
        jne %%noMorePrints
            mov rax, 1
            mov rdi, 1
            mov rsi, spaceMsg
            mov rdx, 1
            syscall

        %%noMorePrints:

    popReg
%endmacro

; Data Declarations (provided).
section .data

; -----
; Define constants.
    NULL equ 0 ; end of string
    TRUE equ 1
    FALSE equ 0
    NEWLINE equ 10

    EXIT_SUCCESS equ 0 ; Successful operation
    SYS_exit equ 60 ; call code for terminate
    nlMessage db NEWLINE, NULL
    spaceMsg db " ", NULL
    negSign db "-", NULL
    sumMsg db "Sum = ", NULL
    maxMsg db "Max = ", NULL
    minMsg db "Min = ", NULL
    estMedianMsg db "EstMedian = ", NULL
    averageMsg db "Average = ", NULL
    countEvenMsg db "CountEven = ", NULL
    countFiveMsg db "CountFive = ", NULL
    sumEvenMsg db "SumEven = ", NULL
    sumFiveMsg db "SumFive = ", NULL
    avgEvenMsg db "AverageEven = ", NULL
    avgFiveMsg db "AverageFive = ", NULL
    arrayPrint db "ARRAY",NEWLINE,"------------------------------------",NEWLINE, NULL

    cMaxMsg db "cMax = ", NULL
    cMinMsg db "cMin = ", NULL
    cSumMsg db "cSum = ", NULL
    cAvgMsg db "cSum = ", NULL

    min dq 0
    max dq 0
    sum dq 0
    estMedian dq 0
    average dq 0

    countEven dq 0
    sumEven dq 0
    averageEven dq 0

    cMax dq 0
    cMin dq 0
    cSum dq 0
    cAverage dq 0
    cCount dq 0

    countFive dq 0
    sumFive dq 0
    averageFive dq 0
    endOfLineNum db TRUE
    endOfLineStr db TRUE

    two dq 2
    five dq 5

    len db     75

    lst dq    -10778, -21100, 28387, -728, -14871, -2261, 27936, -8945, 4538, -18744,
        dq    -29716, -6037, -29479, -9809, -16434, -1785, -23866, 26702, -13051, 1193,
        dq    2988, 5677, -22667, -9462, -24056, 10124, 23436, -24100, 27423, -10428,
        dq    -1418, -28447, 13370, 4682, -25966, 598, -18749, -890, 25612, -25482,
        dq    -19253, 10813, 28972, -4392, 4231, 12386, -15480, 15891, -32742, -2953,
        dq    -32545, 6260, 20419, 21005, -31592, -14496, 20363, -17379, -10897, -25520,
        dq    -11757, 14302, 8781, -20404, 6640, 22567, -21604, -2450, 22484, -28777,
        dq    8801, -24470, -11285, -10683, -30520

    aSides dq    -29123, 18097, -127, 8432, -20754, 31765, -2738, -31999, 2389, -19473,
          dq    -11111, 10000, 2501, -804, 1337, 31415, -31337, 28282, -22876, 146,
          dq    -16097, 3276, -1456, 29999, -31987, 7890, -167, -23777, 9075, -31555,
          dq    -9753, 16000, 5555, -123, 108, -3003, 7311, 19683, -19683, 14142,
          dq    -2512, 22222, 999, -1420, 3123, -28765, 30303, 1998, -16789, 8765,
          dq    -111, -9821, 24242, -24242, 11223, -512, 2020, 128, -128, 32767,
          dq    -32767, 18262, -14567, 27017, -27017, 19283, -1738, 8363, -1523, 1123,
          dq    -1920, 6911, -909, 2096, -777
    
    bSides dq 312, -47, 199, -88, 420, -263, 105, -499, 77, -301,
        dq 244, -145, 382, -76, 19, 451, -330, 5, -178, 267,
        dq -11, 98, -402, 320, -256, 173, 489, -211, 36, -93,
        dq 415, -369, 121, -64, 304, -152, 470, -7, 288, -198,
        dq 72, -444, 250, -132, 391, -25, 167, -300, 53, 429,
        dq -284, 12, -109, 347, -221, 201, -57, 495, -343, 84,
        dq -413, 226, -19, 361, -267, 140, -389, 478, -153, 62,
        dq -95, 318, -245, 406, -176

; -----
section .bss
    cSides resq 75
    cubeVolumes resq 75

section .text

global _start
_start:
; Initlaize arrays to 0
    mov r10, 0
    intializeArrays:
        cmp r10b, byte[len]
        jmp endInitiliaze

        mov qword[cSides], 0
        mov qword[cubeVolumes], 0

        inc r10
        jmp intializeArrays
    endInitiliaze:
    mov r10, 0
    
    ; Code Here
    ;initalizing 
    mov rcx, 0
    mov rdx, [lst] 
    mov min, rdx
    mov max, rdx
    lstLp:
    mov rax, qword[lst+8*rcx]
        ;First portion
    ;min
        cmp rax, [min]
        jge skipMin
        mov min, rax 
    skipMin:
    ;max
        cmp rax, [max]
        jle skipMax
        mov max, rax 
    skipMax:
    ;sum
        add [sum], rax
        ;Second portion
        add rcx, 1
        cmp rcx, 75
        jne lstLp

    lstDone:
    ;average
    mov rax, [sum]
    mov rdx, 0
    mov rcx, 75
    div rcx
    mov [average], rax
    ;estMedian
    mov rax, [lst+ 8*37]
    mov [estMedian], rax






    printsForCodeGrade: ;Do not edit - any edit here results in automatic 0
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout sumMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[sum], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout maxMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[max], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout minMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[min], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout averageMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[average], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout estMedianMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[estMedian], qword[endOfLineNum]
        endl
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout sumEvenMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[sumEven], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout countEvenMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[countEven], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout avgEvenMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[averageEven], qword[endOfLineNum]
        endl
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout sumFiveMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[sumFive], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout countFiveMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[countFive], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout avgFiveMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[averageFive], qword[endOfLineNum]
        endl
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout cSumMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[cSum], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout cMaxMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[cMax], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout cMinMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[cMin], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout cAvgMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[cAverage], qword[endOfLineNum]
        endl
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout arrayPrint, qword[endOfLineStr]
        printArray cSides, len, endOfLineNum
        endl
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout arrayPrint, qword[endOfLineStr]
        printArray cubeVolumes, len, endOfLineNum
    ; *****************************************************************
    ; Done, terminate program.

    last:
        mov rax, SYS_exit ; call code for exit (SYS_exit)
        mov rdi, EXIT_SUCCESS
        syscall
