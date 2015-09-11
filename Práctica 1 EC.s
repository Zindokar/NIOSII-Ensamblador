.equ n, 0xFFC				/* */
							/* */
.global _start				/* */
_start:						/* */
		movi r1, 0			/* r1 = f1 */
		movi r2, 1			/* r2 = f2 */
		movia r4, n			/* We load memory pointer */
		movi r7, 0			/* r7 = loop count */
		movi r8, 8			/* r8 = fibonacci length */
		stw r8, 0(r4)		/* Store in N fibonacci length */
fib:	addi r4, r4, 4		/* Get the memory pointer to 4 next bytes */
		stw r1, 0(r4)		/* We store in memory f1 number */
		addi r3, r2, 0		/* Copy f2 to a temp register to copy back in f1 */
		add r2, r1, r2		/* Add f1 + f2 and store in f2 */
		addi r1, r3, 0		/* Store f2 in f1, so next f1 is f2 */
		addi r7, r7, 1		/* Loop counter ++ */
		blt r7, r8, fib		/* If we didn't reach the loop length, continue */
stop:	br stop				/* IDLE */
							/* */
.org 0xFFC					/* */
n:	.skip 4					/* Memory pointer */
