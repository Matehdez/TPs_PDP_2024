/* DOMINIO PROBLEMA

SISTEMA PARA SER VIKINGOS Y RECONQUISTAR PARIS

*EXPEDICIONES
- Puede valer la pena o no
Vale la pena cuando toda aldea y toda capital 
involucradas en la expedición valen la pena.

INVASION A CAPITAL
- Vale la pena si en el botín conseguido hay al menos tres monedas de oro por 
cada vikingo en la expedición.

- El botin  es tantas monedas de oro como defensores derrotados, 
potenciado o disminuído por un factor de riqueza de la tierra de la capital.

- Se sabe que cuando se invada la capital, cada vikingo se cobrará la vida de un defensor.

INVASION A ALDEA
ALDEA NO DEFENDIDA
- Vale la pena cuando el botín que se pueda obtener sacie la sed de saqueos 
(15 monedas de oro o más en cada aldea). 

- El botin se calcula como la cantidad total de crucifijos que hayan 
en las iglesias dentro de la aldea (y que luego serán robados).

ALDEA AMURALLADA
- Son como las aldeas
- Valen la pena si se tiene una cantidad mínima de vikingos en la comitiva.

*VIKINGOS
- TIPO (CASTA)
- Puede ir a Expediciones:
Si  es productivo
Cualquier casta puede hacerlo, pero si es esclavo no 
debe tener armas

- Hacen expediciones

SUBCLASES DE VINKINGOS
- SOLDADO
  - Es productivo si cobró  más de 20 vidas y tener armas
- GRANJERO
  - Es productivo dependiendo de cantHijos y hectareas 
  designadas por hijo (minimo 2)


CASTAS (TIPOS DE VIKINGOS)
- JARL:
Son esclavos

- KARL:
Casta media

- THRALL:
Son nobles

ACLARACION:
Los Jarl (esclavos) pueden convertirse en Karl (casta media) y en ese momento ganan 
10 armas en el caso de ser soldados, y 2 hijos y 2 hectáreas en caso de ser granjeros.

Los Karl se convierten en Thrall (nobles), pero los Thrall no escalan más.

REQUISITOS
1. ARMAR EXPEDICIONES
   A. Subir un vikingo a una expedición. Si no puede subir no debe hacerlo, y 
   se debe avisar correspondientemente.

   B. Hacer un test para probar lo que sucede al intentar subir si no se pudo, 
   con la construcción de los objetos necesarios.

2. EXPEDICIONES Q VALEN LA PENA
   A. Saber si una expedición vale o no la pena.

   B. Hacer un test para probar esto, con la construcción de los objetos necesarios.

3. REALIZAR EXPEDICION
   A. Esto implica invadir todos los objetivos involucrados 
   (produciendo los efectos correspondientes) pero también dividiendo 
   equitativamente el botín en oro de la expedición entre los vikingos que la integraron.

4. PREGUNTA TEORICA
   A. Aparecen los castillos, que son un nuevo posible objetivo a invadir además de 
   las aldeas y capitales. ¿Pueden agregarse sin modificar código existente? 
   Explicar cómo agregarlo. Justificar conceptualmente.

   RTA: 
   Si, es posible hacerlo debido a que una Invasion es una clase abstracta, y a partir
   de ella se podrian ir creando infinidad de diferentes tipos de invasiones

5. Ascenso social
   A. HACER QUE UN VIKINGO ESCALE SOCIALMENTE

   B. Hacer un test en el que se pruebe que funcione correctamente que el vikingo 
   Ragnar, que pertenece a los Karl, escale. 
   Realizar las construcciones necesarias.

 */