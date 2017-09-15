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
// format string for the output. %c - print assigned ascii char value
str:    .asciz "%c "

// assembly constants for addresses to the variables in the data seg
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
 * is initialized to the ascii value of 0. The while loop runs, looping
 * through each number. Then x is reinitialized as the ascii value for 'a'.
 * It loops until it hits the value for 'z'. Finally, x reinitializes as
 * the ascii value for 'A'. It loops until it hits the value for 'Z'.
 *
 *
 * This function does not use argc or argv.
 */

 main:
 		push 	        {r9, lr}       // Save r9 and lr onto the stack
		baseaddr .req r9               // Assign an alias for r9
 		ldr		baseaddr, base_address
                mov             r0, #48        // Initialize to the start of ints
                str             r0, [baseaddr, #offsetx]               

 		// while (x < 58)
 digitloop:	
 		ldr		r0, [baseaddr, #offsetx]

 		//if (x >= 58)
 		cmp		r0, #58
 		bge		lowercase      

 		// if (x < 58)
 		ldr 	        r0, [baseaddr, #offsetx]
                mov             r1, r0
                add             r0, baseaddr, #offsetstr
 		bl		printf
 		b 		afterdigitloopprintf

 lowercase:
                mov             r1, #10         
                add             r0, baseaddr, #offsetstr
                bl              printf          // Print new line
 		mov		r0, #97         // Initialize 'a'
 		str 	        r0, [baseaddr, #offsetx]

 		// while (x < 123)
 lowercaseloop:
 		ldr		r0, [baseaddr, #offsetx]

 		//if (x >= 123)
 		cmp		r0, #123
 		bge		caps

 		// if (x < 123)
 		ldr 	        r0, [baseaddr, #offsetx]
                mov             r1, r0
                add             r0, baseaddr, #offsetstr
 		bl		printf           // Print lowercasechar
 		b 		afterlowercaseprintf
 		// while (x < 91)
 caps:
                mov             r1, #10
                add             r0, baseaddr, #offsetstr
                bl              printf          // Print new line
		mov		r0, #65         // Initialize 'A'
		str 	        r0, [baseaddr, #offsetx]

		// while (x < 91)
 capsloop:
		ldr		r0, [baseaddr, #offsetx]

 		//if (x >= 91)
 		cmp		r0, #91
 		bge		done

 		// if (x < 91)
 		ldr 	        r0, [baseaddr, #offsetx]
                mov             r1, r0
                add             r0, baseaddr, #offsetstr
 		bl		printf           // Print Uppercase char
 		b 		aftercapsprintf

 afterdigitloopprintf:
 		ldr		r0, [baseaddr, #offsetx]

                // x++
 		add 	        r0, r0, #1
 		str 	        r0, [baseaddr, #offsetx]

 		b 		digitloop

 afterlowercaseprintf:
 		ldr		r0, [baseaddr, #offsetx]

                // x++
 		add 	        r0, r0, #1
 		str 	        r0, [baseaddr, #offsetx]

 		b 		lowercaseloop

 aftercapsprintf:
 		ldr		r0, [baseaddr, #offsetx]

                // x++
 		add 	        r0, r0, #1
 		str 	        r0, [baseaddr, #offsetx]

 		b 		capsloop

 done:
 		.unreq	        baseaddr
 		pop 	        {r9, lr}
 		bx		lr
base_address:   .word base