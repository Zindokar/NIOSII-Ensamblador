.global _start
_start:		movi r2, 0x61			/* Letra 'a' en ASCII asociada al 'DO' */
		movi r3, 0x73			/* Letra 's' en ASCII asociada al 'RE' */
		movi r4, 0x64			/* Letra 'd' en ASCII asociada al 'MI' */
		movi r5, 0x66			/* Letra 'f' en ASCII asociada al 'FA' */
		movi r6, 0x67			/* Letra 'g' en ASCII asociada al 'SOL' */
		movi r7, 0x68			/* Letra 'h' en ASCII asociada al 'LA' */
		movi r8, 0x6A			/* Letra 'j' en ASCII asociada al 'SI' */
		movi r10, 0x77			/* Letra 'w' en ASCII asociada al 'DO#' */
		movi r11, 0x65			/* Letra 'e' en ASCII asociada al 'RE#' */
		movi r12, 0x74			/* Letra 't' en ASCII asociada al 'FA#' */
		movi r13, 0x79			/* Letra 'y' en ASCII asociada al 'SOL#' */
		movi r9, 0x75			/* Letra 'u' en ASCII asociada al 'LA#' */
		movia r14, 0x10001000		/* Direccion base del JTAG-UART */
		movia r15, 0x10003040		/* Direccion base de los registros de control de audio */
		movia r16, LENGTH		/* Puntero al tamaño del vector */
		ldw r16, 0(r16)			/* Cargo el valor del tamaño del vector */
inicio:		ldwio r17, 0(r14)		/* Cargo el registro de datos del JTAG UART */
		andi r18, r17, 0x8000		/* Preparo r18 para ver si hay un dato válido en el buffer */
		beq r18, r0, inicio		/* Si no hay nada válido, vuelvo a comprobar */
		andi r18, r17, 0x000000FF	/* Preparo r8 para ver si se pulsó una tecla válida */
		beq r18, r2, DON		/* Si es una 'a' tocamos la nota correspondiente */
		beq r18, r3, REN		/* Si es una 's' tocamos la nota correspondiente */
		beq r18, r4, MI			/* Si es una 'd' tocamos la nota correspondiente */
		beq r18, r5, FAN		/* Si es una 'f' tocamos la nota correspondiente */
		beq r18, r6, SOLN		/* Si es una 'g' tocamos la nota correspondiente */
		beq r18, r7, LAN		/* Si es una 'h' tocamos la nota correspondiente */
		beq r18, r8, SIN		/* Si es una 'j' tocamos la nota correspondiente */
		beq r18, r10, DOS		/* Si es una 'w' tocamos la nota correspondiente */
		beq r18, r11, RES		/* Si es una 'e' tocamos la nota correspondiente */
		beq r18, r12, FAS		/* Si es una 't' tocamos la nota correspondiente */
		beq r18, r13, SOLS		/* Si es una 'y' tocamos la nota correspondiente */
		beq r18, r9, LAS		/* Si es una 'u' tocamos la nota correspondiente */
		br inicio			/* Si no he tocado una tecla adecuada, vuelvo a comprobar */
FAN:		movia r19, fa			/* Si es un 'FA' cargo la dirección del 'FA' */
		br sonar			/* Voy a reproducir la nota */
SOLN:		movia r19, sol			/* Si es un 'SOL' cargo la dirección del 'SOL' */
		br sonar			/* Voy a reproducir la nota */
LAN:		movia r19, la			/* Si es un 'LA' cargo la dirección del 'LA' */
		br sonar			/* Voy a reproducir la nota */
SIN:		movia r19, si			/* Si es un 'SI' cargo la dirección del 'SI' */
		br sonar			/* Voy a reproducir la nota */
DON:		movia r19, do			/* Si es un 'DO' cargo la dirección del 'DO' */
		br sonar			/* Voy a reproducir la nota */
REN:		movia r19, re			/* Si es un 'RE' cargo la dirección del 'RE' */
		br sonar			/* Voy a reproducir la nota */
MIN:		movia r19, mi			/* Si es un 'MI' cargo la dirección del 'MI' */
		br sonar			/* Voy a reproducir la nota */
FAS:		movia r19, faSost		/* Si es un 'FA#' cargo la dirección del 'FA#' */
		br sonar			/* Voy a reproducir la nota */
SOLS:		movia r19, solSost		/* Si es un 'SOL#' cargo la dirección del 'SOL#' */
		br sonar			/* Voy a reproducir la nota */
LAS:		movia r19, laSost		/* Si es un 'LA#' cargo la dirección del 'LA#' */
		br sonar			/* Voy a reproducir la nota */
DOS:		movia r19, doSost		/* Si es un 'DO#' cargo la dirección del 'DO#' */
		br sonar			/* Voy a reproducir la nota */
RES:		movia r19, reSost		/* Si es un 'RE#' cargo la dirección del 'RE#' */
		br sonar			/* Voy a reproducir la nota */
sonar:		movi r20, 0			/* Inicializo el contador de palabras a 0 */
fifo:		ldwio r18, 4(r15)		/* Cargo el estado de las fifo */
		andhi r18, r18, 0xFFFF		/* Preparo r18 para ver si hay palabras disponibles para introducir en la fifo de escritura */
		beq r18, r0, fifo		/* Si no hay palabras disponibles para meter, vuelvo a comprobar */
		ldw r21, 0(r19)			/* Cargo de memoria la muestra actual */
		addi r19, r19, 4		/* Incremento el puntero de la nota a sonar */
		stwio r21, 8(r15)		/* Almaceno la muestra en la fifo L */
		stwio r21, 0xC(r15)		/* Almaceno la muestra en la fifo R */
		addi r20, r20, 1		/* Incremento el contador de palabras */
		beq r20, r16, inicio		/* Si he llegado al fin, terminamos */
		br fifo				/* Volvemos para leer la siguiente muestra */
