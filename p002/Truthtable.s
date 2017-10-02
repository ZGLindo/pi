/**
 * @Truthtable.s
 *
 * Program: Truthtable
 * Programmer: Zaki G. Lindo
 *
 * Print a truth table for 3 parameters and 3 functions
 *
 * This assembly file (ARM) uses printf to print 3 parameters being
 * altered in a nested loop. The changing of these values changes
 * the values calculated in a truth table.
 */

// ------------------------(Data)-------------------------------------
        .data
// -------------------------------------------------------------------
        .align 4
base:                         // the base address of the data segment
// the loop control variable
a:		.word 0
b:		.word 0
c: 		.word 0
eq1:            .word
eq2:            .word
eq3:            .word

// format string for the output. %d - an integer value.
strinit: .asciz "| A | B | C | A&B&C | A|B|C | A|B&C |\n"
.align 4
str1:    .asciz "| %d | %d | %d |"
.align 4
str2:    .asciz "   %d   |   %d   |   %d   |\n"
.align 4


// assembly constants for addresses to the variables in the data seg
        .set    offsetstrinit, strinit - base
        .set    offsetstr1, str1 - base
        .set    offsetstr2, str2 - base
        .set    offseta, a - base
        .set    offsetb, b - base
        .set    offsetc, c - base
        .set    offseteq1, eq1 - base
        .set    offseteq2, eq2 - base
        .set    offseteq3, eq3 - base
// -------------------------(Data End)--------------------------------
        .text
// -------------------------(Main Start)------------------------------
        .global main
/**
 * main - establishes data base pointer and runs the main loop
 *
 * r9 is set to the address of base, permitting access to the
 * variables in the .data segment with a base-offset notation. Then a,
 * b, c are initialized with 0. As each loop occurs, depending on where
 * in the loop we are, a,b,c get changed to 1. Then each value 
 * gets recalculated to be printed.
 *
 *
 * This function does not use argc or argv.
 */

 main:
 	// Save r9 and lr onto the stack
 	push 	        {r9, lr}       

 	// Assign an alias for r9
	baseaddr .req r9              

 	ldr			baseaddr, base_address

 	// First line of table
        add                             r0, baseaddr, #offsetstrinit 
        bl 				printf		

        // Initialize values for A,B, and C
        mov				r1, #0
        mov				r2, #0
        mov				r3, #0          

 		// for (c=0; c<2; c++)
 Cloop:	
 		

 	//if (c>=2, print a line)
 	cmp		r3, #2
 	bge		Bloop      

 	// if (c<2)
 	add 			r0, baseaddr, #offsetstr1
 	bl			printf

 	// Set string format to print out the second half of this line of the table.
 	add 			r0, baseaddr, #offsetstr2
 	bl 			calcTruth

 	// Print the results of the truth table equations for this line.
        mov                     r1, [baseaddr, #offseteq1]
        mov                     r2, [baseaddr, #offseteq2]
        mov                     r3, [baseaddr, #offseteq3]
 	bl 			printf

 	ldr 			r1, [baseaddr, #offseta] // This set of 3 ldrs restore a,b,c
 	ldr 			r2, [baseaddr, #offsetb] // to the values they were last 
 	ldr 			r3, [baseaddr, #offsetc] // stored as.

 	// c++ then repeat loop
 	add 			r3, r3, #1
 	str 			r3, [baseaddr, #offsetc]
 	b 			Cloop


 Bloop:
        //if (b>=2)
        cmp                     r2, #2
        bge                     Aloop

        //if (b<2)
        mov                     r3, #0
        str                     r3, [baseaddr, #offsetc]
        add                     r2, #1 //b++
        str                     r2, [baseaddr, #offsetb]
        cmp                     r2, #2
        bge                     Aloop
        b                       Cloop


Aloop:
        //if (a>=2)
        cmp                     r1, #2
        bge                     done

        //if (a<2, a++)
        //update a
        add                     r1, r1, #1
        str                     r1, [baseaddr, #offseta]
        cmp                     r1, #2
        bge                     done
        //update b
        mov                     r2, #0
        str                     r2, [baseaddr, #offsetb]
        
        b                       Cloop

calcTruth:
        ldr                     r1, [baseaddr, #offseta] // This set of 3 ldrs restore a,b,c
        ldr                     r2, [baseaddr, #offsetb] // to the values they were last 
        ldr                     r3, [baseaddr, #offsetc] // stored as.

 	// Calculate a&b&c and store in parameter registers
 	and 			r4, r1, r2
 	and 			r4, r4, r3

 	// Calculate a|b|c and store in parameter registers
 	orr 			r5, r1, r2
 	orr 			r5, r5, r3

 	// Calculate a|b&c and store in parameter registers
 	orr			r6, r1, r2
 	and 			r6, r6, r3

        str                     r4, [baseaddr, #offseteq1]
        str                     r5, [baseaddr, #offseteq2]
        str                     r6, [baseaddr, #offseteq3]
 	// Return from calculateTruth
 	bx 			lr

 done:
 		.unreq	        baseaddr
 		pop 	        {r9, lr}
 		bx		lr
base_address:   .word base