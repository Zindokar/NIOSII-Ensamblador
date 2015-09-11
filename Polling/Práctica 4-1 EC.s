.global _start
_start:
	movia r2, 0x10000050  /* carga base botones (pushbuttons) */
	movia r3, 0x10003040  /* carga el control de audio */
	movia r4, 0x10003044  /* carga estado de las fifos */
	movia r5, 0x10003048  /* carga la direccion de la fifo izquierda */
	movia r6, 0x1000304C  /* carga la direccion de la fifo derecha */
	movia r7, 0b0100      /* Boton 2 */
	movia r8, 0x10000000  /* carga la direccion de los leds rojos */
	movia r9, 0x10000010  /* carga la direccion de los leds verdes*/
	movia r10, 144000     /* tope a los 3 segundos*/
	movia r23, 0x10000040 /* direccion de los switches */
	movia r20, 0b0010     /* Boton 1*/
reset:
	movia r18, derecha   /* carga la direccion donde se guarda la grabacion*/
	movia r19, izquierda /* carga la direccion donde se guarda la grabacion*/
	movi r12, 0	     /* inicializa */
	
inicio:
	ldw r11, 0(r2)		/* carga el estado de los botones*/
	beq r11,r20, grabar     /* comprueba el boton 1*/
	beq r11,r7, reproducir  /* comprueba el boton 3*/
	br inicio		/* llama al inicio*/
	
grabar:
	movia r11, 0x3FFFF	/* cambia al led de la derecha */
	stwio r11, 0(r8)        /* evita el reinicio en caso de no ser necesario */
	
micro:
	ldwio r16,0(r4)		/* carga el estado de la fifo */
	andi r16,r16, 0xFFFF    /* si no a terminado el delay repite el bucle*/
	beq r16,r0, micro	/* si no hay nada en la fifo continua */
	ldwio r13, 0(r5)	/* cargamos la palabra en la fifo izquierda*/
	ldwio r14, 0(r6)        /* cargamos la palabra en la fifo derecha*/
	stwio r13, 0(r18)       /* guardamos en memoria la palabra del intro izquierda*/
	stwio r14, 0(r19)       /* guardamos en memoria la palabra del intro derecho*/
	addi r18,r18, 4 	/* aumentamos el puntero */
	addi r19,r19, 4         /* incrementa el puntero */
	addi r12,r12, 1		/* incrementamos la cantidad de palabras añadidas*/
	bgt r12,r10, fing	/* si ya hemos grabado 3 segundos paramos*/
	br micro
	
fing:
	stwio r0,0(r8) 		/* apagar los leds*/
	br reset
	
reproducir:
	movia r11, 0x1FF        /* leds a encender*/
	stwio r11, 0(r9)        /* enciende los leds verdes*/
	movia r15, 0xFFFF0000   /* mascara para comprobar las fifos*/
	ldwio r11, 0(r23)	/* cargo el estado de los switches */
	andi r11, r11, 0b11
	movi r22, 0b01
	beq r11, r22, lento
	movi r22, 0b10
	beq r11, r22, rapido
	movi r17, 4 /* desplazamiento */
	movi r11, 1 /* */
	movi r22, 1
	br fifo
lento:
	movi r17, 4 /* desplazamiento */
	movi r11, 1 /* */
	movi r22, 2 /* */
	br fifo
rapido:
	movi r17, 8 /* desplazamiento */
	movi r11, 2 /* */
	movi r22, 1
fifo:
	ldwio r16, 0(r4)     /* carga el estado de la fifo */
	and r16,r16,r15      /* comprueba si hay algo en las fifos */
	beq r16, r0, fifo    /* si la fifo esta llena continua */
	ldw r13, 0(r18)	     /* cargamos la palabra en la fifo izquierda */
	ldw r14, 0(r19)      /* cargamos la palabra en la fifo derecha */
	bne r22, r20, norep
repetir:
	ldwio r16, 0(r4)      /* carga el estado de la fifo */
	and r16,r16,r15       /* comprueba si hay algo en las fifos */
	beq r16, r0, repetir  /* si la fifo esta llena continua */
	stwio r13, 0(r5)      /* guardamos en memoria la palabra del intro izquierda */
	stwio r14, 0(r6)      /* guardamos en memoria la palabra del intro derecho */
rock:
	ldwio r16, 0(r4)      /* carga el estado de la fifo */
	and r16,r16,r15       /* comprueba si hay algo en las fifos */
	beq r16, r0, rock     /* si la fifo esta llena continua */
	stwio r13, 0(r5)      /* guardamos en memoria la palabra del intro izquierda */
	stwio r14, 0(r6)      /* guardamos en memoria la palabra del intro derecho */
norep:
	stwio r13, 0(r5)      /* guardamos en memoria la palabra del intro izquierda */
	stwio r14, 0(r6)      /* guardamos en memoria la palabra del intro derecho */
	add r18,r18,r17	      /* incrementa el puntero */
	add r19,r19,r17	      /* incrementa el puntero */
	add r12,r12,r11	      /* incrementa la cantiad de palabras reproducidas */
	bgt r12,r10,finp      /* si ya hemos reproducido todo saltamos */
	br fifo		      /* seguimos reproduciendo */
finp:
	stwio r0, 0(r9)       /* apagmos los leds verdes */
	br reset	      /* */
.data
derecha:
	.skip 600000
izquierda:
	.skip 600000 /* tener en cuenta que se solaparan datos si cambias a modo grabacion fija */
.end
