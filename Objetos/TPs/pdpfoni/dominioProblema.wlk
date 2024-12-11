/*  DOMINIO PROBLEMA

SISTEMA QUE MANEJA LINEAS Y PACKS DE CLIENTES

LINEA
- Nro Tel
- PACKS ACTIVOS
  --Realizan CONSUMOS

CONSUMO
- DE INTERNET
  --Por MB
- DE LLAMADAS
  -- Por Segundos

  PACKS (Deben poder agregarse mas a futuro)
  Podran tener fecha de vencimiento
  - CANT. CREDITO
  - CANT. MB
  - LLAMADAS GRATIS
  - INTERNET ILIMITADO (LOS FINDES)
  ---------------------------------------------------------------------
  REQUISITOS
  1. Conocer costo de un CONSUMO
  La EMPRESA dispone de precios por MB y Por Segundos

  Siempre se cobra un precio fijo los primeros 30s, 
  luego se cobra por segundo
  - un consumo de llamada de 40 segundos vale 
  ($1 + 10 * $0.05 = $1.50),
- y un consumo de internet de 5 MB vale (5 * $0.10 = $0.50).

2. Sacar info de los CONSUMOS realizados por LINEA
- Conocer Costo promedio de todos los consumos dentro de un rango
de fechas
- Conocer costo total de la linea de los ultimos 30 dias

3. Saber si un PACK puede satisfacer un CONSUMO
Por ejemplo, un pack de 100MB libres satisface un consumo 
de internet de 5 MB, pero una llamada de 60 segundos 
no puede ser satisfecha por ese pack. 
Por otro lado, un pack de $100 de crédito satisface ambos 
consumos (con los precios del ejemplo del punto 1).

4. Poder agregar un PACK a una LINEA

5. Saber si una linea puede hacer cierto consumo
Por ejemplo, la linea 1566666666 tiene los siguientes packs: 
10 MB libres, $50 de crédito, 200MB libres vencidos el 13/10/2019;
 5 MB libres, y uno de 15MB libres vigentes hasta el 12/12/2019.

Esta línea no puede hacer un consumo de Internet de 20MB porque 
el consumo debe poderse satisfacer completamente por un pack.

6. Realizar un consumo en la LINEA
- Registrar el consumo en la LINEA
- Producir el gasto del pack
- Cuando se hace un consumo, se consume el ultimo agregado
- Se debe tirar error en caso de que no se pueda satisfacer

7. Mas sobre PACKS
- Realizar limpieza de packs vencidos o acabados
- Agregar los packs MB Libres++, actua igual el el pack MB Libres,
pero que cuando se gastan los MB libres igual te siguen sirviendo... Pero sólo para consumos de 0.1 MB o menos.

8. Agregar lineas BLACK y PLATINIUM
BLACK
- Cuando ningun pack deje realizar consumo, se hara igual
- Se suma un registro de deuda

PLATINIUM
- Se hace el consumo igual y no hay deuda alguna

LAS LINEAS deberian cambiar sin perder registro de PACKS ni ESTADS

9. 

...

DATE: 
>>> var ayer = hoy.minusDays(1)
>>> var maniana = hoy.plusDays(1)
>>> hoy.between(ayer,maniana)
true

*/