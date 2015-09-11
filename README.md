# AlteraDE2-NIOSII-Ensamblador
Programas realizados por mi en ensamblador, en la asignatura de Estructura de Computadores en la Universidad de Las Palmas de Gran Canaria.

## Polling
Técnica de encuesta o polling, consiste en preguntar al controlador del periférico constantemente y en función de la respuesta hacer algo determinado.

### Práctica 2 - Polling
En esta práctica desplazamos los leds de la placa Altera DE2 hacia un lado en función del botón que apretemos de la botonera, puede ser izquierda o derecha.
Para ello empezamos desplazando hacia la izquierda los leds (un led encendido, el resto apagado) hasta que apretemos un botón y evaluaremos si debe moverse a la derecha o no.

## Interruption
Técnica frecuentemente usada que consiste en habilitar interrupciones del procesador, y dependiendo del procesador tratar dichas excepciones.
En nuestro caso vamos a programar un código manejador de excepciones.

### Práctica 2 - Interruption
Es el mismo resultado que la práctica 2 anterior pero con la precisión de detectar el comportamiento del periférico cuando interrumpe el procesador.
Primero vamos a programar la configuración del procesador para que tenga habilitada las interrupciones, y qué periféricos pueden interrumpir, el Timer del procesador NIOSII de la placa Altera DE2 y apretar los botones de la botonera hará que se produzca una interrupción, y en el código de manejo de interrupciones comprobaremos qué interrupción es la actual, y hacer lo adecuadio, si fue el timer movemos el led, si fue algún botón deberíamos indicar la dirección del led izquierda o derecha.
En la botonera hay 3 botones, podemos configurar una máscara para que solo interrumpa la combinación de botones que queramos, y así prevenir que un botón que no queramos interrumpa, aunque podemos hacer que interrumpa y luego descartarlo pero es un mal gasto por nuestra parte, sobretodo si podemos configurar, por ejemplo en nuestro caso sólo interrumpa KEY1 y KEY3.
Una diferencia principal es que el led no se mueve a partir de un bucle infinito, sino cada vez que el timer del procesador (configurado en el main.s) interrumpe, movemos el led a donde corresponde.
En esta práctica hemos ahorrado archivos sueltos, y hemos puesto el manejador en un sólo fichero y no hemos usado la stack ya que no usamos tantos registros, lo recomendable aunque se usen pocos registros es utilizar la stack, no es otro mecanismo que guardar los valores de los registros en memoria dentro del manejador antes de hacer nada, y cuando termine el manejador de hacer lo que hemos programado recuperar esos valores de memoria a los registros.
