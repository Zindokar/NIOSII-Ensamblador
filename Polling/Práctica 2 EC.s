.global _start				/*  */
	/* Declaracion de variables */
_start: movia r3, 0x10000000		/* Mapa de bits para el controlador e/s paralelo para los leds rojos */
	movia r1, 0x10000050		/* Direccion base de los botones */
	movi r4, 0b100000000000000000	/* Contador tope del desplazador hacia la izquierda */
	movi r2, 0b000000000000000001	/* Contador tope del desplazador hacia la derecha */
	mov r5, r2			/* Usamos r5 como estado para los leds rojos */
	movi r6, 0b0010			/* Máscara de bits para comprobar si se apreto KEY1 */
	movi r8, 0b0100			/* Máscara de bits para comprobar si se apreto KEY2 */
	movi r9, 0b1000			/* Máscara de bits para comprobar si se apreto KEY3 */
	movi r13, 0b0111111		/* Mapa de bits para un 0 en el 7-segmentos */
	movia r12, 30000		/* Tope máximo del contador del temporizador (fast) */
	movi r14, 2500			/* */
					/* */
	/* Inicio del programa */
	stwio r5, 0(r3)			/* Encendemos el mapa de bits actual en leds */
					/* */
	/* Desplazo hacia la izquierda */
izqc:	mov r5, r2			/* Reiniciamos los bits si hemos llegado ya al ledr17 */
izq:	bgt r5, r4, izqc		/* Si no hemos terminado de desplazar hasta el led tope, seguimos */
	stwio r5, 0(r3)			/* Cargo el mapa de bits en los leds rojos */
	slli r5, r5, 1			/* Desplazamos un bit hacia la izquierda y rellenamos con cero el resto */
	call temp			/* Llamo al temporizador */
	ldwio r7, 0(r1)			/* Cargo el estado del boton */
	beq r6, r7, der			/* Si vamos hacia la izquierda y apreto KEY1, go derecha */
	ldwio r7, 0(r1)			/* Cargo el estado del boton */
	beq r9, r7, btnizq		/* Hago funcion del boton tres */
	br izq				/* Seguimos hacia la izquierda */
					/* */
	/* Desplazo hacia la derecha */
derc:	mov r5, r4			/* Reiniciamos los bits si hemos llegado ya al ledr17 */
der:	blt r5, r2, derc		/* Si no hemos terminado de desplazar hasta el led tope, seguimos */
	stwio r5, 0(r3)			/* Cargo el mapa de bits en los leds rojos */
	srli r5, r5, 1			/* Desplazamos un bit hacia la derecha y rellenamos con cero el resto */
	call temp			/* Llamo al temporizador */
	ldwio r7, 0(r1)			/* Cargo el estado del boton */
	beq r8, r7, izq			/* Si vamos hacia la izquierda y apreto KEY1, go derecha */
	ldwio r7, 0(r1)			/* Cargo el estado del boton */
	beq r9, r7, btnder		/* Hago funcion del boton tres */
	br der				/* Seguimos hacia la derecha */
					/* */
	/* Accion para el KEY3 */
	/* Si venimos de estar girando hacia la derecha, cambiamos velocidad y seguimos hacia la derecha */
btnder: add r12, r12, r14		/* */
	br der				/* Volvemos al bucle de mover hacia la derecha */
	/* Si venimos de estar girando hacia la izquierda, cambiamos velocidad y seguimos hacia la izquierda */
btnizq: add r12, r12, r14		/* */
	br izq				/* Volvemos al bucle de mover hacia la izquierda */
					/* */
	/* Subrutina a modo de temporizador */
temp:	movi r10, 0			/* Iniciamos el contador del temporizador */
back:	addi r10, r10, 1		/* Decrementamos el contador */
	beq r12, r10, fin		/* Hasta que no lleguemos al final no paramos */
	br back				/* Volvemos al bucle */
fin:	ret				/* Return 0 */
