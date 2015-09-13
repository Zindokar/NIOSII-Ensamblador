/**
 * @author Alejandro López Santos
 */
package frecuencianota;

import java.io.IOException;
import java.io.PrintStream;
import javax.swing.JOptionPane;

public class FrecuenciaNota {
    public static void main(String[] args) {
        String version = "@canvas FrecuenciaNota 2.1";
        int opcion = JOptionPane.showOptionDialog(null, "Bienvenid@ al programa \"pr\u00e1ctica 4 EC fixed carrito\", enjoy!", version, -1, -1, null, new Object[]{"Crear todas las notas", "Crear una nota espec\u00edfica", "Salir"}, version);
        switch (opcion) {
            case 0: {
                try {
                    FrecuenciaNota.crearTodo();
                    JOptionPane.showMessageDialog(null, "Ficheros creados, este modo no crea CSV, para ello debe crearlo de una nota individual.", version, 1);
                }
                catch (IOException e) {
                    JOptionPane.showMessageDialog(null, "No se ha podido crear el fichero. ERR#02", version, 0);
                }
                break;
            }
            case 1: {
                opcion = JOptionPane.showOptionDialog(null, "Elije la nota que quiere generar.", version, -1, -1, null, new Object[]{"DO - C", "DO# - C#", "RE - D", "RE# - D#", "MI - E", "FA - F", "FA# - F#", "SOL - G", "SOL# - G#", "LA - A", "LA# - A#", "SI - B"}, version);
                try {
                    FrecuenciaNota.crearNota(opcion);
                    JOptionPane.showMessageDialog(null, "Ficheros creados.", version, 1);
                }
                catch (IOException e) {
                    JOptionPane.showMessageDialog(null, "No se ha podido crear el fichero. ERR#02", version, 0);
                }
                break;
            }
            case 2: {
                break;
            }
            default: {
                JOptionPane.showMessageDialog(null, "Error al seleccionar valor del menu. ERR#01", version, 0);
            }
        }
    }

    private static void crearNota(int nota) throws IOException {
        int frecuencia;
        String fichero;
        int amplitud = 20000000;
        int muestreo = 48000;
        switch (nota) {
            case 0: {
                fichero = "notaDO";
                frecuencia = 262;
                break;
            }
            case 1: {
                fichero = "notaDO#";
                frecuencia = 278;
                break;
            }
            case 2: {
                fichero = "notaRE";
                frecuencia = 292;
                break;
            }
            case 3: {
                fichero = "notaRE#";
                frecuencia = 310;
                break;
            }
            case 4: {
                fichero = "notaMI";
                frecuencia = 328;
                break;
            }
            case 5: {
                fichero = "notaFA";
                frecuencia = 348;
                break;
            }
            case 6: {
                fichero = "notaFA#";
                frecuencia = 370;
                break;
            }
            case 7: {
                fichero = "notaSOL";
                frecuencia = 392;
                break;
            }
            case 8: {
                fichero = "notaSOL#";
                frecuencia = 416;
                break;
            }
            case 9: {
                fichero = "notaLA";
                frecuencia = 440;
                break;
            }
            case 10: {
                fichero = "notaLA#";
                frecuencia = 466;
                break;
            }
            case 11: {
                fichero = "notaSI";
                frecuencia = 494;
                break;
            }
            default: {
                fichero = "notaDO_else";
                frecuencia = 262;
            }
        }
        PrintStream csv = new PrintStream(fichero + ".csv");
        PrintStream s = new PrintStream(fichero + ".s");
        s.println("/*********************************************************************/");
        s.println("/* Codigo autogenerado por el programa de @canvas FrecuenciaNota 2.1 */");
        s.println("/*********************************************************************/");
        s.println("/* " + fichero + " */");
        s.println(".global _start");
        s.println("_start:      movia r2, 0x10001000        /* Direccion base del JTAG-UART */");
        s.println("             movia r3, 0x10003040        /* Direccion base de los registros de control de audio */");
        s.println("             movi r4, 0x61               /* Caracter 'a' ASCII en hexadecimal */");
        s.println("             movia r7, LENGTH            /* Puntero al tama\u00f1o del vector */");
        s.println("             ldw r8, 0(r7)               /* Cargo el valor del tama\u00f1o del vector */");
        s.println("leer:        ldwio r6, 0(r2)             /* Cargo el registro de datos del JTAG UART */");
        s.println("             andi r5, r6, 0x8000         /* Preparo r5 para ver si hay un dato v\u00e1lido en el buffer */");
        s.println("             beq r5, r0, leer            /* Si no hay nada v\u00e1lido, vuelvo a comprobar */");
        s.println("             andi r5, r6, 0x000000FF     /* Preparo r5 para ver si se introdujo una 'a' */");
        s.println("             bne r5, r4, leer            /* Si no es una 'a' en c\u00f3digo ASCII, vuelvo a comprobar*/");
        s.println("             sonar:\taddi r7, r7, 4      /* Apunto a la siguiente muestra */");
        s.println("             ldw r6, 0(r7)               /* Cargo de memoria la muestra actual */");
        s.println("fifo:        ldwio r5, 4(r3)             /* Cargo el estado de las fifo */");
        s.println("             andhi r5, r5, 0xFFFF        /* Preparo r5 para ver si hay palabras disponibles para introducir en la fifo de escritura */");
        s.println("             beq r5, r0, fifo            /* Si no hay palabras disponibles para meter, vuelvo a comprobar */");
        s.println("             stwio r6, 8(r3)             /* Almaceno la muestra en la fifo L */");
        s.println("             stwio r6, 0xC(r3)           /* Almaceno la muestra en la fifo R */");
        s.println("             addi r9, r9, 1              /* Incremento el contador de palabras */");
        s.println("             beq r8, r9, fin             /* Si he llegado al fin, terminamos */");
        s.println("             br sonar                    /* Volvemos para leer la siguiente muestra */");
        s.println("fin:         movia r7, VECTOR            /* Reinicio el puntero */");
        s.println("             movi r9, 0                  /* Reinicio el contador a 0 */");
        s.println("             br leer                     /* Volvemos a leer el JTAG-UART en caso que queramos oir otra vez */");
        s.println();
        s.println(".data");
        s.println("    LENGTH: .word 24000");
        s.print("    VECTOR: .word ");
        csv.println("orden muestra;t=odern/M[s];2*pi*f*t;sen(2*pi*f*t);A*sen(2*pi*f*t);");
        for (int i = 1; i < 24000; ++i) {
            double tiempo = (double)i / ((double)muestreo * 1.0);
            double dentro = 6.283185307179586 * (double)frecuencia * tiempo;
            double seno = Math.sin(dentro);
            double muestra = (double)amplitud * seno;
            long muestraPrint = Math.round(muestra);
            String resultado = "" + i + ";" + tiempo + ";" + dentro + ";" + seno + ";" + muestraPrint + ";";
            s.print("" + muestraPrint + ", ");
            csv.println(resultado);
        }
        s.print("0");
        s.println();
        s.println(".end");
        s.println();
        s.close();
        csv.close();
    }

    private static void crearTodo() throws IOException {
        PrintStream s = new PrintStream("todasLasNotas.s");
        s.println("/*********************************************************************/");
        s.println("/* Codigo autogenerado por el programa de @canvas FrecuenciaNota 2.1 */");
        s.println("/*********************************************************************/");
        s.println(".global LENGTH");
        s.println("    LENGTH: .word 24000");
        int[] frecuencias = new int[]{262, 278, 292, 310, 328, 348, 370, 392, 416, 440, 466, 494};
        String[] notas = new String[]{"do", "doSost", "re", "reSost", "mi", "fa", "faSost", "sol", "solSost", "la", "laSost", "si"};
        int amplitud = 20000000;
        int muestreo = 48000;
        for (int i = 0; i < frecuencias.length; ++i) {
            s.println(".global " + notas[i]);
            s.print("    " + notas[i] + ": .word ");
            for (int n = 1; n < 24000; ++n) {
                double tiempo = (double)n / ((double)muestreo * 1.0);
                double dentro = 6.283185307179586 * (double)frecuencias[i] * tiempo;
                double seno = Math.sin(dentro);
                double muestra = (double)amplitud * seno;
                long muestraPrint = Math.round(muestra);
                String resultado = "" + i + ";" + tiempo + ";" + dentro + ";" + seno + ";" + muestraPrint + ";";
                s.print("" + muestraPrint + ", ");
            }
            s.println("0");
        }
        s.println(".end");
        s.println();
        s.close();
        s = new PrintStream("piano.s");
        s.println("/*********************************************************************/");
        s.println("/* Codigo autogenerado por el programa de @canvas FrecuenciaNota 2.1 */");
        s.println("/*********************************************************************/");
        s.println(".global _start");
        s.println("_start:");
        s.println("/* introduce tu c\u00f3digo */");
        s.println();
        s.close();
    }
}