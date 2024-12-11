/* DOMINIO DEL PROBLEMA
AGENCIA DE ESPIONAJE ISIS (genera ingresos por ambos medios)
- LAVANDERIA
- ESPIAS

EMPLEADOS
- Cada empleado tiene HABILIDADES
- Cada HABILIDAD sirve para resolver MISIONES
- Tienen SALUD
- Un empleado queda INCAPACITADO cuando su SALUD queda
debajo de su SALUD CRITICA

TIPOS DE EMPLEADOS
- ESPIAS
Aprenden habilidades al completar misiones
Salud critica = 15
- OFICINISTAS
Tienen Estrellas
Si sobrevive a una mision, gana una estrella
Salud critica = 40 - 5 * la cantidad de estrellas que tenga.

UN EMPLEADO PUEDE SER JEFE DE OTRO

MISIONES
- Se resuelven en equipo / o de forma individual
- Requiere habilidades
- Los jefes pueden asistir a sus subordinados
--------------------------------------------------------------------
REQUISITOS
1. Saber si un empleado está incapacitado //

2. Saber si un empleado puede usar una habilidad: //
- Si no esta incapacitado
- Si tiene la habilidad

SI ES JEFE
- Si alguno de sus subordinados la tiene y la puede usar

3. Hacer que un empleado o un equipo cumpla una misión.
- Si reune y puede usar todas las habilidades requeridas
- En equipos, las habilidades pueden ser usadas x mas de uno 

Si se cumple la mision, se recibe danio en base a la peligrosidad

Si es en equipos, todos reciben 1/3 del danio total

AHORA BIEN,
Los empleados que sobrevivan, registran que la completaron
- Los OFICINISTAS consiguen una estrella
Cuando acumulan 3 podria empezar a trabajar de espia

- Los ESPIAS aprenden las habilidades de la mision que no poseian

 */