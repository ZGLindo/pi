/*
  @file mystery.s
 */
        .data
        .balign 4
base:
        .set o_argc, . - base
argc:   .word 0

        .set o_argv, . - base
argv:   .word 0

        .set o_str, . - base
str:    .skip 100

        .set o_oneWord, . - base
oneWord: .asciz "%s "
        .set o_newline, . - base
newline: .asciz "\n"

        .text
        .global main
main:
        push {r4-r9, lr}
        ldr r9, data_segment
        data_seg .req r9

        str r0, [data_seg, #o_argc]
        str r1, [data_seg, #o_argv]


        argi .req r5
        mov argi, r1

while.1.top:
	add argi, argi, #4
        currArg .req r6
        ldr currArg, [argi]
        cmp currArg, #0
        beq while.1.done
        currStr .req r7
        add currStr, data_seg, #o_str
repeat.top:
        ch .req r8
        ldrb ch, [currArg]

        mov r0, ch
        bl isalpha
        cmp r0, #0
        beq after

        add ch, ch, #5
	mov r0, ch
	bl isalpha
	cmp r0, #0
	bne after

        sub ch, ch, #26

after:
        strb ch, [currStr]

        add currArg, currArg, #1
        add currStr, currStr, #1

        cmp ch, #0
        bne repeat.top

        add r0, data_seg, #o_oneWord
        add r1, data_seg, #o_str
        bl printf

        b while.1.top

while.1.done:


	add r0, data_seg, #o_newline
	bl printf

	.unreq data_seg

        pop {r4-r9, lr}
        bx lr                                 /* return from main using lr */
data_segment:   .word base