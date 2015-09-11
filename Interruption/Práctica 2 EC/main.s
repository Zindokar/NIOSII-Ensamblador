.global _start
_start:
	/* Configuración del timer */
	movia r16,0x10002000		/* Dirección base del timer */
	movia r12, 0x345000		/* Aproximadamente 1s */
	sthio r12, 8(r16)		/* Mirad de la parte baja de la palabra counter start value */
	srli r12, r12, 16		/* Desplazamos media palabra */
	sthio r12, 0xC(r16)		/* Mitad de la parte alta (por haber desplazado) de la media palabra counter start value */
	movi r15, 0b0111		/* START = 1, CONT = 1, ITO = 1 */
	sthio r15, 4(r16)		/* Guardamos la media palabra (START, CONT, ITO del mismo registro) */
					/* */
	/* Configuración de los botones */
	movia r15, 0x10000050		/* Dirección de base del registro de los botones */
	movi r7, 0b01110		/* Se activan KEY1 y KEY2 en la mascara de interrupciones */
	stwio r7, 8(r15)		/* Se guarda lo anterior */
					/* */
	/* Configuración de interrupciones */
	movi r7, 0b011			/* Activa las interrupciones internas "ienable" para la el timer y los botones */
	wrctl ienable, r7		/* Se guarda lo anterior */
	movi r7, 1			/* Activa las interrupciones "PIE" en el registro status */
	wrctl status, r7		/* Se guarda lo anterior */
					/* */
	/* Registros globales */
	movia r21, 0x10000000		/* Dirección base de los leds rojos */
	movi r17, 1			/* Registro en el que se desplazaran los bits */
	movi r16, 1			/* Registro global que controlara el flujo de la direccion de desplazamiento de bits */
	movi r19, 0b100000000000000000	/* El tope de desplazamiento a la izquierda de los leds rojos */
	movia r10, 0x10002000		/* Dirección base del timer */
	movia r20, 0x10000050		/* Dirección base de los botones */
					/* */
bucle: br bucle				/* */
