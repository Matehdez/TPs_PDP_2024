% ==================================PARCIAL VACACIONES ==============================================

%*PUNTO 1-------------------------

/*Sabemos que dodain se va a Pehuenia, San Martín (de los Andes), 
Esquel, Sarmiento,Camarones y Playas Doradas. 

Alf, en cambio, se va a Bariloche, San Martín de los Andes
y El Bolsón. 

Nico se va a Mar del Plata, como siempre. 

Y Vale se va para Calafate y El Bolsón.

● Además Martu se va donde vayan Nico y Alf.

● Juan no sabe si va a ir a Villa Gesell o a Federación

● Carlos no se va a tomar vacaciones por ahora*/

%Se pide que defina los predicados correspondientes, 
%y justifique sus decisiones en base a conceptos vistos en la cursada

viaja(dodain, pehuenia).
viaja(dodain, sanMartin).
viaja(dodain, esquel).
viaja(dodain, sarmiento).
viaja(dodain, camarones).
viaja(dodain, playasDoradas).

viaja(alf, bariloche).
viaja(alf, sanMartin).
viaja(alf, elBolson).

viaja(nico, mdq).

viaja(vale, calafate).
viaja(vale, elBolson).

viaja(martu, Destino) :-
    viaja(nico, Destino).
viaja(martu, Destino) :-
    viaja(alf, Destino).

%No grafico ni a Juan ni a Carlos porque ninguno representa un viaje
%en concreto; son pensamientos o la nada misma. 

% PUNTO 2 ==========================================================
% Incorporamos ahora información sobre las atracciones de cada 
% lugar. Las atracciones se dividen en:

% ● un parque nacional, donde sabemos su nombre

% ● un cerro, sabemos su nombre y la altura

% ● un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si
% se puede pescar y la temperatura promedio del agua


% ● una playa: tenemos la diferencia promedio de marea baja y alta


% ● una excursión: sabemos su nombre


/*Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo
modelaría las atracciones. 

Por ejemplo: 
Esquel tiene como atracciones un parque nacional (Los Alerces) y 
dos excursiones (Trochita y Trevelin).

Villa Pehuenia tiene como atracciones un cerro (Batea Mahuida de 2.000 m)
y dos cuerpos de agua (Moquehue, donde se puede pescar y tiene 14
grados de temperatura promedio y Aluminé, donde 
se puede pescar y tiene 19 grados de temperatura promedio).*/

atraccion(esquel, parqueNacional(losAlerces)).
atraccion(esquel, excursion("trochita")).
atraccion(esquel, excursion("travelin")).

atraccion(pehuenia, cerro(bateaMahuida, 2000)).
atraccion(pehuenia, rio(moquehue, puedePescar, 14)).
atraccion(pehuenia, rio(alumine, puedePescar, 19)).


/*Queremos saber qué vacaciones fueron copadas para una persona.
Esto ocurre cuando todos los lugares a visitar tienen por lo menos
una atracción copada.

● un cerro es copado si tiene más de 2000 metros
● un cuerpoAgua es copado si se puede pescar o la temperatura es 
mayor a 20
● una playa es copada si la diferencia de mareas es menor a 5
● una excursión que tenga más de 7 letras es copado
● cualquier parque nacional es copado
El predicado debe ser inversible.*/

existenVacaciones(Destinos) :-
    length(Destinos, Cantidad),
    Cantidad > 0.
    


vacacionesCopadas(Persona, DestinosCopados) :-
    viaja(Persona, _),
    atraccion(_, Atraccion),
    findall(Destino, (viaja(Persona, Destino), atraccion(Destino, Atraccion), esCopado(Atraccion)), DestinosRepetidos),
    list_to_set(DestinosRepetidos, DestinosCopados),
    existenVacaciones(DestinosCopados).
    


esCopado(cerro(_, Metros)) :-
    Metros > 2000.

esCopado(rio(_, puedePescar, _)).
esCopado(rio(_, _, Temperatura)) :-
    Temperatura > 20.

esCopado(playa(_, MareaAlta, MareaBaja)) :-
    abs(MareaAlta - MareaBaja) < 5.

esCopado(excursion(Nombre)):-
    string_length(Nombre, Length),
    Length > 7.

esCopado(parqueNacional(_)).
    


% PUNTO 3 ==========================================================

/*Cuando dos personas distintas no coinciden en ningún lugar como 
destino decimos que no se cruzaron. 

Por ejemplo, Dodain no se cruzó con Nico ni con Vale (sí con Alf en
San Martín de los Andes). Vale no se cruzó con Dodain ni con Nico 
(sí con Alf en El Bolsón). 

El predicado debe ser completamente inversible.*/


noCruzo(Persona1, Persona2) :-
    viaja(Persona1, _),
    viaja(Persona2, _),
    Persona1 \= Persona2,
    forall(viaja(Persona1, Destino ), not(viaja(Persona2, Destino))).

% PUNTO 4 ==========================================================
costo(sarmiento,100).
costo(esquel,150).
costo(pehuenia,180).
costo(sanMartin,150).
costo(camarones,135).
costo(playasDoradas,170).
costo(bariloche,140).
costo(calafate,240).
costo(bolson,145).
costo(mdq,140).

vacacionesGasoleras(Persona) :-
    viaja(Persona, _),
    forall(viaja(Persona, Destino), costoDeVidaBarato(Destino)).

costoDeVidaBarato(Destino) :-
    costo(Destino, Valor),
    Valor < 160.

% PUNTO 5 ==========================================================
/*Queremos conocer todas las formas de armar el itinerario de un 
viaje para una persona sin importar el recorrido. 
Para eso todos los destinos tienen que aparecer en la solución 
(no pueden quedar destinos sin visitar).*/

itinerario(Persona, Destinos) :-
    viaja(Persona, _),
    findall(Destino, viaja(Persona, Destino), DestinosVisitados),
    permutar(DestinosVisitados, Destinos).

permutar([], []). 
permutar([X | Cola], [Cola | X]).
permutar([X | Cola], [X | OtraCola]) :-
    permutar(Cola, OtraCola).



