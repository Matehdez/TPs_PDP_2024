%* CASAS HOGWARTS ============================================================================================
% Parte 1 - Sombrero Seleccionador

% Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, el Sombrero Seleccionador tiene en cuenta 
% el carácter de la persona, lo que prefiere y en algunos casos su status de sangre.

% Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. 
% Odiaría que el sombrero lo mande a Slytherin

%Nombre, Criterios(Sangre, Personalidades, Casa que odia)
mago(harry, criterios(mestiza, [corajudo, amistoso, orgulloso, inteligente], slytherin)).
mago(draco, criterios(pura, [orgulloso, inteligente], hufflepuff)).
mago(hermione, criterios(impura, [responsable, orgulloso, inteligente], ninguna)).

%Casa / Personalidades
esApropiado(gryffindor, corajudo).
esApropiado(slytherin, [orgulloso, inteligente]).
esApropiado(ravenclaw, [responsable, inteligente]).
esApropiado(hufflepuff, [amistoso]).

%PUNTO 1 -----------------------------------------------------------------------------------
%Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso 
% de Slytherin, que no permite entrar a magos de sangre impura.

dejaEntrar(Casa, Mago) :-
    mago(Mago, _),
    casa(Casa),
    Casa \= slytherin.

dejaEntrar(slytherin, Mago) :-
    mago(Mago, _),
    not(tieneSangreImpura(Mago)).

casa(Casa) :-
    esApropiado(Casa, _).

tieneSangreImpura(Mago) :-
    mago(Mago, criterios(impura, _, _)).

% Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus 
% características incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada

cumpleCaracter(Mago, Casa) :-
    esApropiado(Casa, Caracteristicas),
    mago(Mago, criterios(_, Caracter, _)),
    comparoCaracteristicas(Caracteristicas, Caracter).

comparoCaracteristicas([], _).
comparoCaracteristicas([X|Caracter], Caracteristicas) :-
    member(X, Caracteristicas),
    comparoCaracteristicas(Caracter, Caracteristicas).

% Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa,
% la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. 
% Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.

podriaQuedarEn(Mago, Casa) :-
    mago(Mago, criterios(_, _, OdiaCasa)),
    casa(Casa),
    dejaEntrar(Casa, Mago),
    Casa \= OdiaCasa,
    cumpleCaracter(Mago, Casa).

podriaQuedarEn(hermione, gryffindor).

% Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos y cada uno podría estar
% en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual.

%TODO

%* PARTE 2 =====================================================================================================
malaAccion(fueraDeCama, -50).
malaAccion(lugar(bosque), -50).
malaAccion(lugar(seccionRestringida), -10).
malaAccion(lugar(tercerPiso), -75).

accion(harry, fueraDeCama).
accion(hermione, lugar(seccionRestringida)).
accion(hermione, lugar(tercerPiso)).
accion(harry, lugar(tercerPiso)).
accion(harry, lugar(bosque)).
accion(draco, lugar(mazmorras)).
accion(ron, ganarAjedrezMagico).
accion(hermione, salvarAmigos).
accion(harry, vencerAvoldemort).

buenaAccion(ganarAjedrezMagico, 50).
buenaAccion(salvarAmigos, 50).
buenaAccion(vencerAvoldemort, 60).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Saber si un mago es buen alumno, que se cumple si hizo alguna acción y 
% ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).

esBuenAlumno(Mago):-
    accion(Mago, _),
    forall(accion(Mago, Accion), not(malaAccion(Accion, _))).

%Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.

esRecurrente(Accion) :-
    accion(Mago1, Accion),
    accion(MAgo2, Accion),
    Mago1 \=MAgo2.

% Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
puntajeAccion(Accion, Puntos) :-
    buenaAccion(Accion, Puntos).

puntajeAccion(Accion, Puntos) :-
    malaAccion(Accion, Puntos).

puntajeAccionesDe(Casa, Puntaje) :-
    casa(Casa),
    findall(Puntos, (esDe(Mago, Casa), accion(Mago, Accion), puntajeAccion(Accion, Puntos)), Puntajes),
    sum_list(Puntajes, Puntaje).
    
    
% Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya 
% obtenido una cantidad mayor de puntos que todas las otras.

casaGanadora(Casa) :-
    casa(Casa),
    puntajeAccionesDe(Casa, Puntaje),
    forall((casa(OtraCasa), OtraCasa\=Casa), (puntajeAccionesDe(OtraCasa, OtroPuntaje), Puntaje>=OtroPuntaje)).

% Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa 
% de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo

% pregunta(PreguntaAResponder, Dificultad, Profesor).

% Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, de dificultad 20, 
 % realizada por el profesor Snape, y cómo hacer levitar una pluma, de dificultad 25, realizada por el profesor Flitwick.

buenaAccion(respondioPregunta(bezoar, Dificultad, snape), Puntos) :-
    Puntos is Dificultad//2.

buenaAccion(respondioPregunta(pluma,25, flitwick), 25).  


% Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, teniendo en cuenta que
 % los puntos que se otorgan equivalen a la dificultad de la pregunta, a menos que la haya hecho Snape, que da la mitad
  % de puntos en relación a la dificultad de la pregunta

accion(hermione, respondioPregunta(bezoar, 20, snape)).
accion(hermione, respondioPregunta(pluma, 25, flitwick)).

    









