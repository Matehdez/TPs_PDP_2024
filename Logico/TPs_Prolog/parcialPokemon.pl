%*PARCIAL POKEMON JUEVES TM

%*PARTE 1 : POKEDEX

%POKEMONES
%Pokemones. De estos conocemos sus tipos.

pokemon(pikachu, electrico).
pokemon(charizard, fuego).
pokemon(venusaur, planta).
pokemon(blastoise, agua).
pokemon(totodile, agua).
pokemon(snorlax, normal).
pokemon(rayquaza, dragon).
pokemon(rayquaza, volador).
%Arceus no se considera, pues desconocemos su tipo

%el predicado podria haberse llamado tipo y no pokemon, pero a efectos practicos y 
%debido a que ya finalice el desarrollo del codigo antes de darme cuenta
%de esto, lo dejaré así. Me parece importante comentarlo.

%Agregado para testear
% pokemon(ditto, normal).

%ENTRENADORES
%Entrenadores: En el camino nos encontramos con otros entrenadores. De estos conocemos que pokemones tienen:

entrenador(ash, pikachu).
entrenador(ash, charizard).

entrenador(brock, snorlax).

%Agregado para testear
%entrenador(brock, eeve).

entrenador(misty, blastoise).
entrenador(misty, venusaur).
entrenador(misty, arceus).

%Lo agrego para testear
% entrenador(profesorOak, ditto).

%Entonces será pokemon si tiene tipo, o bien si es entrenado
esPokemon(Pokemon) :-
    pokemon(Pokemon, _).
esPokemon(Pokemon) :-
    entrenador(_, Pokemon).

%*PUNTO 1
% Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo.
esDeTipoMultiple(Pokemon) :-
    pokemon(Pokemon, Tipo),
    pokemon(Pokemon, OtroTipo),
    Tipo\=OtroTipo.

%*PUNTO 2
% Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene.
esLegendario(Pokemon) :-
    esDeTipoMultiple(Pokemon),
    not(entrenador(_, Pokemon)).

%*PUNTO 3
%Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene. 

esMisterioso(Pokemon) :-
    esPokemon(Pokemon),
    not(entrenador(_, Pokemon)).

esMisterioso(Pokemon) :-
    esUnicoEnSuTipo(Pokemon).

esUnicoEnSuTipo(Pokemon) :-
    pokemon(Pokemon, Tipo),
    forall((pokemon(OtroPokemon, OtroTipo), Pokemon \= OtroPokemon), Tipo \= OtroTipo).

%*PARTE 2
% Mientras exploramos el mundo Pokémon vemos que los pokemones hacen movimientos e iremos recopilando en nuestra pokédex.

% Movimientos. Hasta ahora conocemos las siguientes clases de movimientos:

% Físicos: Son de una determinada potencia.
% Especiales: Además de tener una potencia, son de un determinado tipo.
% Defensivos: Reducen el daño recibido. Tienen un porcentaje de reducción.
movimiento(mordedura, fisico(95)). 
movimiento(impactrueno, especial(electrico, 40)).
movimiento(garraDragon, especial(dragon, 100)). 
movimiento(proteccion, defensivo(0.1)). 
movimiento(placaje, fisico(50)). 
movimiento(alivio, defensivo(1)).
%Se agrega para testear
%movimiento(plantosis, especial(planta, 100)). 

conoceMovimiento(pikachu, mordedura). 
conoceMovimiento(pikachu, impactrueno). 
conoceMovimiento(charizard, garraDragon). 
conoceMovimiento(charizard, mordedura). 
conoceMovimiento(blastoise, proteccion). 
conoceMovimiento(blastoise, placaje). 
conoceMovimiento(arceus, impactrueno). 
conoceMovimiento(arceus, garraDragon). 
conoceMovimiento(arceus, proteccion). 
conoceMovimiento(arceus, placaje). 
conoceMovimiento(arceus, alivio). 

% Snorlax no puede usar ningún movimiento.
%Como en nuestra base de datos registramos solo los movimientos conocidos, no deberiamos registrar un movimiento que no es
%conocido por ningun pokemon; prolog asume que si no existe entonces no es conocido (Principo universo cerrado)

%*PUNTO 1
% El daño de ataque de un movimiento, lo cual se calcula de la siguiente forma:

% En los movimientos físicos, es su potencia
% En los movimientos defensivos es 0
% En los movimientos especiales está dado por su potencia multiplicado por:
% 1.5 si es un tipo básico (fuego, agua, planta o normal)
% 3 si es de tipo Dragón
% 1 en cualquier otro caso

danioAtaque(Movimiento, Danio) :-
    movimiento(Movimiento, fisico(Danio)).

danioAtaque(Movimiento, 0) :-
    movimiento(Movimiento, defensivo(_)).

danioAtaque(Movimiento, Danio) :-
    movimiento(Movimiento, especial(dragon, Potencia)),
    Danio is Potencia * 3.

danioAtaque(Movimiento, Danio) :-
    movimiento(Movimiento, especial(Tipo, Potencia)),
    esBasico(Tipo),
    Danio is Potencia * 1.5.

danioAtaque(Movimiento, Danio) :-
    movimiento(Movimiento, especial(_, Potencia)),
    Danio is Potencia * 1.

esBasico(fuego).
esBasico(agua).
esBasico(planta).
esBasico(normal).

%*PUNTO 2
% La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los daños de ataque de 
% los movimientos que puede usar.

capacidadOfensiva(Pokemon, Capacidad) :-
    esPokemon(Pokemon),
    findall(Danio, (conoceMovimiento(Pokemon, Movimiento), danioAtaque(Movimiento, Danio)), Danios),
    sum_list(Danios, Capacidad).

%*PUNTO 3
%Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva total superior a 200 o 
%son misteriosos.

esPicante(Entrenador) :-
    entrenador(Entrenador, _),
    forall((entrenador(Entrenador, Pokemon), esPokemon(Pokemon)), (capacidadOfensiva(Pokemon, Capacidad), Capacidad > 200)).

esPicante(Entrenador) :-
    entrenador(Entrenador, _),
    forall(entrenador(Entrenador, Pokemon), (esMisterioso(Pokemon))).

%!ACLARACION GENERAL
%!Debido al backtracking de prolog, es posible que se muestren repetidos los resultados. 