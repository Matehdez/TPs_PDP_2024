/* DOMINIO PROBLEMA

SERVICIO DE MENSAJERIA

MENSAJES
- Usuario que lo envia (cada usuario tiene una memoria det que se va llenando con mensajes)
- Peso en KB:
5 (datos fijos de transferencia) + peso del contenido * 1,3 (factor de la red)
- Contenido

TIPOS DE CONTENIDO
* TEXTO
- Peso = 1

* AUDIO
- Peso = Depende de la duracion (1seg * 1,2)

*IMAGEN
UN PIXEL PESA 2KB
- Alto
- Ancho
-  Cantidad total de pixeles = ancho x alto
- Peso = Depende de compresion:
  - COMPRESION ORIG: no tiene, se envian todos los pix
  - COMPRESION VAR: se elige un porcentaje de compresión distinto para cada 
  imagen que determina la cantidad de pixeles del mensaje original que se van a 
  enviar.
  - COMPRESION MAX: Hasta un max de 10.000 pix
    - Si la imag ocupa menos, se envian todos los pix
    - Sino, se reduce hasta ese max

    *GIF
    - Deriva de las imagenes
    - Cant caudros q tiene
    - Peso = Super * cant Cuadros     

*CONTACTO
- Que usuario se envia
- Peso = 3kb

CHATEANDO
CHATS
- Se pueden enviar mensajes
- El emisor debe estar participando en el chat
- Los usuarios deben tener espacio para almacenar el mensaje

*TIPOS DE CHAT
*BASICO

*PREMIUM
SE AGREGAN RESTRICCIONES:
*Difusión: 
solamente el creador del chat premium puede enviar mensajes.

*Restringido: 
determina un límite de mensajes que puede tener el chat, una vez llegada a esa 
cantidad no deja enviar más mensajes.

*Ahorro 
tod0s los integrantes pueden enviar solamente mensajes que no superen un peso máximo determinado.

LAS RESTRICCIONES Y LOS PARTICIPANTES DE CHATS PUEDEN MODIFICARSE 
--------------------------------------------------------------------------------------
REQUISITOS:
1. Saber el espacio que ocupa un chat, que es la suma de los pesos de los mensajes enviados.
2. Enviar un mensaje a un chat considerando los tipos de chats y las restricciones que tienen. 
3. Hacer una búsqueda de un texto en los chats de un usuario. 

La búsqueda obtiene como resultado los chats que tengan algún mensaje con ese texto.
Un mensaje contiene un texto si es parte del nombre de quien lo envía, si es parte 
del texto del mensaje, o del nombre del contacto enviado.

TODO [1] Los strings entienden el mensaje contains(otroTexto) que indica si el parámetro se encuentra dentro del string.

4. Dado un usuario, conocer sus mensajes más pesados. Que es el conjunto formado 
por el mensaje más pesado de cada uno de sus chat.

5. Los usuarios también son notificados de sus chats sin leer.
   *A. Al enviar un mensaje a un chat cada participante debe recibir una notificación.
   *B. Que un usuario pueda leer un chat. Al leer un chat, todas las notificaciones del 
   *usuario correspondiente a ese chat se marcan como leídas.
   *C. Conocer las notificaciones sin leer de un usuario.

*/