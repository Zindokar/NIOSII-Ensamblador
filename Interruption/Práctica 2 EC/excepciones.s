.section .exceptions, "ax"
	subi ea,ea,4		/* Decrementamos en una instrucción a la que vamos a volver con el eret */
						/* */
	/* Capturamos la linea fisica de la interrupcion */
	rdctl et,ctl4		/* Cargo el valor de la IRQ */
	andi r23, et, 1		/* Preparo r23 para ver si fue en irq#0 */
	beq r23, et, TIMER	/* Si se activo irq#0, voy a la etiqueta timer */
						/* */
	/* Si no he saltado a timer, es que se activó por botones */
	ldwio r11, 0xC(r20)		/* read edge capture register INECESARIO?*/
	stwio r0, 0xC(r20)		/* clear the interrupt */
	movi r23, 0b0010		/* */
	beq r11, r23, FUE_KEY1	/* */
	movi r23, 0b0100		/* */
	beq r11, r23, FUE_KEY2	/* */
	/* aqui fue KEY3 */
	br FIN					/* */
							/* */
FUE_KEY1:					/* */
	movi r16, 0				/* */
	br FIN					/* */
							/* */
FUE_KEY2:					/* */
	movi r16, 1				/* */
	br FIN					/* */
							/* */
TIMER:						/* */
	sthio r0, 0(r10) 		/* Limpiamos la interrupción */
	stwio r17, 0(r21)		/* Cargo la mascara de bits para encender los leds rojos */
	beq r16, r0, DER		/* */
							/* */
IZQ:						/* */
	slli r17,r17,1			/* */
	bne r19, r17,FIN		/* */
	movi r17, 1				/* */
	br FIN					/* */
							/* */
DER:						/* */
	srli r17,r17,1			/* */
	bne r17,r0,FIN			/* */
	mov r17, r19			/* */
	br FIN					/* */
							/* */
FIN:						/* */
	eret					/* */
