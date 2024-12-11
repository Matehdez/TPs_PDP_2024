%PUNTO1
%juega(Jugador,Civlizacion)
juega(ana,romanos).
juega(beto,incas).
juega(carola,romanos).
juega(dimitri,romanos).

desarrolloTecnologia(ana,herreria).
desarrolloTecnologia(ana,forja).
desarrolloTecnologia(ana,emplumado).
desarrolloTecnologia(ana,laminas).

desarrolloTecnologia(beto,herreria).
desarrolloTecnologia(beto,forja).
desarrolloTecnologia(beto,fundicion).

desarrolloTecnologia(carola,herreria).

desarrolloTecnologia(dimitri,herreria).
desarrolloTecnologia(dimitri,fundicion).

%Punto2
%expertoEnMetales(Jugador)
expertoEnMetales(Jugador):-
    desarrolloTecnologia(Jugador,herreria),
    desarrolloTecnologia(Jugador,forja),
    desarrolloFundicionOJuegaConRomanos(Jugador).

desarrolloFundicionOJuegaConRomanos(Jugador):-
    desarrolloTecnologia(Jugador,fundicion).

desarrolloFundicionOJuegaConRomanos(Jugador):-
    juega(Jugador,romanos).

%Punto3
%civilizacionPopular(Civilizacion)
civilizacionPopular(Civilizacion):-
    juega(Jugador,Civilizacion),
    juega(OtroJugador,Civilizacion),
    Jugador\=OtroJugador.

%PUNTO4
%alcanceGlobal(Tecnologia)
tecnologia(Tecnologia):-
    desarrolloTecnologia(_,Tecnologia).

alcanceGlobal(Tecnologia):-
    tecnologia(Tecnologia),
    forall(juega(Jugador,_),desarrolloTecnologia(Jugador,Tecnologia)).

%PUNTO5
%civilizacionLider(Civilizacion,Tecnologia)
alcanzoTecnologia(Civilizacion,Tecnologia):-
    juega(Jugador,Civilizacion),
    desarrolloTecnologia(Jugador,Tecnologia).
    
civilizacionLider(Civilizacion):-
    juega(_,Civilizacion),
    forall(tecnologia(Tecnologia),alcanzoTecnologia(Civilizacion,Tecnologia)).



% SEGUNDA PARTE  -------------------------------------

% PUNTO6
/*No se puede ganar la guerra sin soldados. Las unidades que existen son los  
campeones (con vida de 1 a 100), los jinetes (que los puede haber a caballo o a 
camello) y los piqueros, que tienen un nivel de 1 a 3, y pueden o no tener escudo.*/

% Ana tiene un jinete a caballo, un piquero con escudo de nivel 1, y un piquero sin escudo de nivel 2.
tropas(ana, jinete(caballo)).
tropas(ana, piquero(conEscudo, 1)).
tropas(ana, piquero(sinEscudo, 1)).

% Beto tiene un campeón de 100 de vida, otro de 80 de vida, un piquero con escudo nivel 1 y un jinete a camello.
tropas(beto, campeon(100)).
tropas(beto, campeon(80)).
tropas(beto, piquero(conEscudo, 1)).
tropas(beto, piquero(conEscudo, 1)).
tropas(beto, piquero(sinEscudo, 1)).
tropas(beto, piquero(sinEscudo, 1)).
tropas(beto, piquero(sinEscudo, 1)).
tropas(beto, jinete(camello)).

% Carola tiene un piquero sin escudo de nivel 3 y uno con escudo de nivel 2.
tropas(carola, piquero(sinEscudo, 3)).
tropas(carola, piquero(conEscudo, 2)).

%Campeon
calcularVida(campeon(Vida), Vida).

%Jinetes
calcularVida(jinete(caballo), 90).
calcularVida(jinete(camello), 80).

%Piquero
calcularVida(piquero(1, sinEscudo), 50).
calcularVida(piquero(2, sinEscudo), 65).
calcularVida(piquero(3, sinEscudo), 70).

calcularVida(piquero(conEscudo, Nivel), Vida):-
    calcularVida(piquero(sinEscudo, Nivel),VidaSinEscudo),
    Vida is VidaSinEscudo * 1.1.

%PUNTO 7
tropaConMayorVida(Jugador, Tropa):- 
    vidaTropaJugador(Jugador, VidaMayor, Tropa),
    forall(vidaTropaJugador(Jugador, OtraVida, _), OtraVida =< VidaMayor).

vidaTropaJugador(Jugador, Vida, Tropa):-
    tropas(Jugador, Tropa),
    calcularVida(Tropa, Vida).


%PUNTO 8
leGanaA(jinete(_), campeon(_)).
leGanaA(campeon(_), piquero(_, _)).
leGanaA(piquero(_, _), jinete(_)).
leGanaA(jinete(camello), jinete(caballo)).

leGanaA(Tropa1, Tropa2):-
    calcularVida(Tropa1, Vida1),
    calcularVida(Tropa2, Vida2),
    Vida1 > Vida2.

%PUNTO 9
/*Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más piqueros con escudo que sin escudo.
En los ejemplos, Beto es el único que puede sobrevivir a un asedio, pues tiene 1 piquero con escudo y 0 sin escudo.*/

calcularPiquerosConEscudo(Jugador,Cantidad):- 
  findall(_, (tropas(Jugador, piquero(conEscudo, _))), PiquerosConEscudo),
  length(PiquerosConEscudo, Cantidad).

calcularPiquerosSinEscudo(Jugador,Cantidad):-
  findall(_, (tropas(Jugador, piquero(sinEscudo, _))), PiquerosSinEscudo),
  length(PiquerosSinEscudo, Cantidad).

sobreviveAsedio(Jugador):-
    juega(Jugador, _),
    calcularPiquerosConEscudo(Jugador, CantPiquerosConEscudo),
    calcularPiquerosSinEscudo(Jugador, CantPiquerosSinEscudo),
    CantPiquerosConEscudo > CantPiquerosSinEscudo.

%PUNTO 10

necesita(emplumado,herreria).
necesita(punzon, emplumado).

necesita(forja,herreria).
necesita(fundicion, forja).
necesita(horno, fundicion).

necesita(laminas,herreria).
necesita(malla, laminas).
necesita(placas, malla).

necesita(collera, molino).
necesita(arado, collera).

sePuedeDesarrollar(Jugador, Tecnologia):-
    juega(Jugador, _),
    not(desarrolloTecnologia(Jugador, Tecnologia)),
    desarrollo(Jugador, Tecnologia).

desarrollo(_, Tecnologia):-
    not(necesita(Tecnologia,_)).

desarorllo(Jugador, Tecnologia):-
    necesita(Tecnologia, TecnologiaAnterior),
    desarrolloTecnologia(Jugador, TecnologiaAnterior),
    desarrollo(Jugador, TecnologiaAnterior).

% Bonus
% 11) a) 
/*Encontrar un orden válido en el que puedan haberse desarrollado las tecnologías para que un jugador llegue a desarrollar todo lo que tiene. Se espera una relación de jugador con lista de tecnologías.
Ejemplo: Un orden válido para Ana es: herreria, emplumado, forja, láminas. Otro orden válido sería herreria, forja, láminas, emplumado. Pero seguro que Ana no desarrolló primero la forja, porque antes necesitaría la herrería.
Recordar que debe funcionar para cualquier árbol y no sólo para el de el ejemplo. Y recordar que debe ser completamente inversible.*/

%encuentra todas las tecnologias que un jugador desarrolló y las recopila en una lista.
tecnologiasDesarrolladas(Jugador,Tecnologias):-
    findall(Tecnologia,desarrolloTecnologia(Jugador,Tecnologia),Tecnologias).

%usando tecnologiasDesarrolladas obtiene la lista de todas las tecnologias desarrolladas del jugador y encuentra orden válido de desarrollo, se arma con construirOrden.
ordenValido(Jugador,Orden):-
    tecnologiasDesarrolladas(Jugador,Tecnologias),
    construirOrden(Tecnologias, [], Orden).

%caso base, si la lista está vacía el orden construido es el mismo que el orden Parcial acumulado.
construirOrden([],Orden,Orden). 

%caso en el que se puede agregar una tecnología a la lista Parcial. 
construirOrden([Tecnologia | Restantes], LParcial, Orden):-
    puedeAgregar(Tecnologia, LParcial),
    construirOrden(Restantes, [Tecnologia|LParcial], Orden).

%caso en el que no se puede agregar tecnología a la lista.
construirOrden([Tecnologia|Restantes], LParcial, Orden) :-
    not(puedeAgregar(Tecnologia, LParcial)),
    construirOrden(Restantes, LParcial, Orden).

puedeAgregar(Tecnologia, LLParcial) :-
    forall(requiere(Tecnologia, Dependencia),
    member(Dependencia, LLParcial)).

% b) 
% ¿Qué sucede cuando se consulta si existe un orden válido para Dimitri? ¿Por qué?
/*Cuando se consulta si existe un orden válido para Dimitri la respuesta es "Orden = [laminas, emplumado, forja, herreria] ;
ya que Dimitri ya desarrolló herrería.*/

% 12)
/*
Dado un jugador defensor, encontrar el ejército que debo crear para ganarle a todo su ejército. El ejército atacante debe tener el 
mismo tamaño, y suponer que las batallas son uno contra uno, cada integrante atacante ataca a un integrante defensor.
Ejemplo: Para ganarle al ejército de Carola (que es un piquero sin escudo de nivel 3 y uno con escudo de nivel 2) hacen falta dos 
campeones de cualquier vida, o dos piqueros con escudo nivel 3, o campeón y un piquero con escudo nivel 3, etc.
Recordar que debe ser completamente inversible.
*/
% ejercitoGanador(JugadorDefensor, EjercitoAtacante).
ejercitoGanador(JugadorDefensor, EjercitoAtacante):-
    unJugador(JugadorDefensor),
    ejercitoDefensor(JugadorDefensor, EjercitoDefensor),
    unidadGanadora(EjercitoDefensor, EjercitoAtacante).

unidadGanadora([UnidadDef | RestoDef], [UnidadAtq | RestoAtq]):-
    gana(UnidadAtq, UnidadDef),
    unidadGanadora(RestoDef, RestoAtq).

unidadGanadora([], []).
    
ejercitoDefensor(JugadorDefensor, EjercitoDefensor):-
    findall(UnidadDefensora, (unidad(JugadorDefensor, Unidades), member(UnidadDefensora, Unidades)), EjercitoDefensor).