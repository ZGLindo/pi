/**
 * @Printascii.s
 *
 * Program: Printascii
 * Programmer: Zaki G. Lindo
 *
 * Print Ascii Values from 0-9 on a line, a-z on another line, and
 * A-Z on the last line.
 *
 * This assembly file (ARM) uses printf to loop from 0 to 9, a-z,
 * and A-Z using ASCII values stored in an integer.
 */

// ------------------------(Data)-------------------------------------
        .data
// -------------------------------------------------------------------
        .align 4
base:                         // the base address of the data segment
// the loop control variable
x:      .word 0
// format string for the output. %c - print assigned ascii char for val
str:    .asciz "%c "

// assembly constants for offsets to the variables in the data seg
        .set    offsetx, x - base
        .set    offsetstr, str - base


// -------------------------(Data End)--------------------------------
        .text
// -------------------------(Main Start)------------------------------
        .global main
/**
 * main - establishes data base pointer and runs the main loop
 *
 * r9 is set to the address of base, permitting access to the
 * variables in the .data segment with a base-offset notation. Then x
 * is initialized and the while loop runs. In-line comments track the
 * C-language equivalent code as the program proceeds.
 *
 * This function does not use argc or argv.
 */