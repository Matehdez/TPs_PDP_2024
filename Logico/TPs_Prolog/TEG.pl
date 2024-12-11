continente(americaDelSur).
continente(americaDelNorte).
continente(asia).
continente(oceania).

%estaEn:
%Define en qué continente está un país
estaEn(americaDelSur, argentina).
estaEn(americaDelSur, brasil).
estaEn(americaDelSur, chile).
estaEn(americaDelSur, uruguay).
estaEn(americaDelNorte, alaska).
estaEn(americaDelNorte, yukon).
estaEn(americaDelNorte, canada).
estaEn(americaDelNorte, oregon).
estaEn(asia, kamtchatka).
estaEn(asia, china).
estaEn(asia, siberia).
estaEn(asia, japon).
estaEn(oceania,australia).
estaEn(oceania,sumatra).
estaEn(oceania,java).
estaEn(oceania,borneo).

%jugador:
%Define los jugadores disponibles en la partida
jugador(amarillo).
jugador(magenta).
jugador(negro).
jugador(blanco).

%aliados:
%Define las alianzas que existen durante la partida
aliados(X,Y):- alianza(X,Y).
aliados(X,Y):- alianza(Y,X).
alianza(amarillo,magenta).

%el numero son los ejercitos
ocupa(argentina, magenta, 5).
ocupa(chile, negro, 3).
ocupa(brasil, amarillo, 8).
ocupa(uruguay, magenta, 5).
ocupa(alaska, amarillo, 7).
ocupa(yukon, amarillo, 1).
ocupa(canada, amarillo, 10).
ocupa(oregon, amarillo, 5).
ocupa(kamtchatka, negro, 6).
ocupa(china, amarillo, 2).
ocupa(siberia, amarillo, 5).
ocupa(japon, amarillo, 7).
ocupa(australia, negro, 8).
ocupa(sumatra, negro, 3).
ocupa(java, negro, 4).
ocupa(borneo, negro, 1).

% Usar este para saber si son limitrofes ya que es una relacion simetrica
sonLimitrofes(X, Y) :- limitrofes(X, Y).
sonLimitrofes(X, Y) :- limitrofes(Y, X).

limitrofes(argentina,brasil).
limitrofes(argentina,chile).
limitrofes(argentina,uruguay).
limitrofes(uruguay,brasil).
limitrofes(alaska,kamtchatka).
limitrofes(alaska,yukon).
limitrofes(canada,yukon).
limitrofes(alaska,oregon).
limitrofes(canada,oregon).
limitrofes(siberia,kamtchatka).
limitrofes(siberia,china).
limitrofes(china,kamtchatka).
limitrofes(japon,china).
limitrofes(japon,kamtchatka).
limitrofes(australia,sumatra).
limitrofes(australia,java).
limitrofes(australia,borneo).
limitrofes(australia,chile).

%! Se pide definir los siguientes predicados de modo que sean completamente inversibles. Además agregar tests para mínimo los casos de prueba comentados.

%* PARTE A ==================================================================================================================================================
%loLiquidaron/1 que se cumple para un jugador si no ocupa ningún país.
% Caso de prueba Un jugador que no ocupe ningún país está liquidado (x ej. el blanco) 

loLiquidaron(Jugador) :-
    jugador(Jugador),
    not(ocupa(_, Jugador, _)).

%ocupaContinente/2 que relaciona un jugador y un continente si el jugador ocupa todos los países del mismo.
% Caso de prueba Si tiene todos los países el jugador ocupa el continente (x ej. el amarillo con americaDelNorte)

ocupaContinente(Jugador, Continente) :-
    jugador(Jugador),
    continente(Continente),
    forall(estaEn(Continente, Pais), ocupa(Pais, Jugador, _)).

%seAtrinchero/1 que se cumple para los jugadores que ocupan países en un único continente.
% Caso de prueba Si está en un único continente se atrincheró (x ej. el magenta en américa del sur)

seAtrinchero(Jugador):-
    jugador(Jugador),
    continente(Continente),
    forall(ocupa(Pais, Jugador, _), estaEn(Continente, Pais)).

%* PARTE B ==================================================================================================================================================
/*puedeConquistar/2 que relaciona un jugador y un continente si este puede atacar a cada país que le falte. 
Es decir, no ocupa dicho continente, pero todos los países del mismo que no tiene son limítrofes a alguno que ocupa y a su vez ese país no es de un aliado.*/
% Ejemplo para el/los caso/s de prueba: Tanto el amarillo como el negro pueden conquistar asia, ninguno más está en condiciones de conquistar otros continentes.

puedeConquistar(Jugador, Continente) :-
    jugador(Jugador), jugador(Aliado), 
    continente(Continente),
    not(ocupaContinente(Jugador, Continente)),
    ocupa(OtroPais, Jugador, _), 
    forall((estaEn(Continente, Pais), not(ocupa(Pais, Jugador, _))), (sonLimitrofes(Pais, OtroPais), not(esDeAliado(Jugador, Aliado, Pais)))).

esDeAliado(Jugador, Aliado, Pais) :-
    alianza(Jugador, Aliado), 
    ocupa(Pais, Aliado, _).

elQueTieneMasEjercitos(Jugador, Pais) :-
    jugador(Jugador),
    estaEn(_, Pais), 
    forall(ocupa(_, _ , Fichas), ocupa(Pais, Jugador, Cantidad)),
    Cantidad > Fichas.
    



