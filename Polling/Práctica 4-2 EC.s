.text								/* */
.global _start						/* */
_start:		movia r5, 0x10003040	/* direccion base del audio */
			movia r3, puntero		/* puntero a memoria de grabacion */
reset:		movia r4, 384000		/*Retardo eco*/

inicio:		ldwio r2,4(r5)			/*Comprobamos el espacio de la FIFO de lectura.*/
			andi r2,r2,0xFFFF
			beq r2,r0,inicio

			/* FIFO - L */

			ldwio r2,8(r5)			/*Se pone en r2 el contenido de la dirección del canal izquierdo*/
			ldw r3,puntero(r4)		/*Se trae de memoria audio anterior*/
			add r2,r2,r3			/*Se combinan el sonido actual con en anterior*/
			stwio r2,8(r5)			/*Se reproduce*/
			srai r2,r2,3			/*Bajar el volumen*/
			stw r2,puntero(r4)		/*Guarda en memoria el sonido combinado bajado de volumen*/
			subi r4,r4,4			/*Va a la siguiente dirección de memoria.*/

			/* FIFO - R */
			ldwio r2,12(r5)			/*Se pone en r2 el contenido de la dirección del canal derecho*/
			ldw r3,puntero(r4)		/*Se trae de memoria audio anterior*/
			add r2,r2,r3			/*Se combinan el sonido actual con en anterior*/
			stwio r2,12(r5)			/*Se reproduce*/
			srai r2,r2,3			/*Bajar el volumen*/
			stw r2,puntero(r4)		/*Guarda en memoria el sonido combinado bajado de volumen*/
			subi r4,r4,4			/*Va a la siguiente dirección de memoria.*/
			beq r4,r0,reset			/*Si llega a cero, reiniciamos*/
			br inicio
.org 0x1000
puntero:	.skip 384000
.end