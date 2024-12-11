% - PERMUTACIONES -

% permutacion/2: permutacion(Lista, Lista Permutada)
% Funciona como permutation/2 pero está declarada de forma recursiva.

permutacion([X],[X]).
permutacion([X | OtraLista], Permutada):-
    permutacion(OtraLista,UnaLista),
    insertarRandom(X,UnaLista,Permutada).

insertarRandom(X,XS,[X|XS]).
insertarRandom(X,[Nuevo | Lista], [Nuevo | OtraLista]):-
    insertarRandom(X,Lista,OtraLista).

/*

    Ejemplo de uso:

    permutacion([1,2,3],Permutacion).

    Permutacion = [1, 2, 3] ;
    Permutacion = [2, 1, 3] ;
    Permutacion = [2, 3, 1] ;
    Permutacion = [1, 3, 2] ;
    Permutacion = [3, 1, 2] ;
    Permutacion = [3, 2, 1] ;

*/

% - TODAS LAS COMBINACIONES POSIBLES -

% combinar/2: combinar(Lista, Lista Combinada)

combinar([], []).

combinar([Cabeza|Cola], [Cabeza|OtraCola]):-
    combinar(Cola, OtraCola).

combinar([_|Cola], Lista):-
    combinar(Cola, Lista).

/*
    Ejemplo de uso:

    combinar([1,2,3],Combinacion).

    Combinacion = [1, 2, 3] ;
    Combinacion = [1, 2] ;
    Combinacion = [1, 3] ;
    Combinacion = [1] ;
    Combinacion = [2, 3] ;
    Combinacion = [2] ;
    Combinacion = [3] ;
    Combinacion = [].

*/

% - COMBINACIONES AGARRADOS DE A N ELEMENTOS -

combinacionesAgrupadas(0, _, []).

combinacionesAgrupadas(Cantidad, [X|Xs], [X|Ys]):-
  Cantidad > 0,
  Cantidad1 is Cantidad - 1,
  combinacionesAgrupadas(Cantidad1, Xs, Ys).

combinacionesAgrupadas(Cantidad, [_|Xs], Ys):-
  Cantidad > 0,
  combinacionesAgrupadas(Cantidad, Xs, Ys).

/*

    Ejemplo de uso:

    combinacionesAgrupadas(2,[1,2,3],CombinacionesDeA2).

    CombinacionesDeA2 = [1, 2] ;
    CombinacionesDeA2 = [1, 3] ;
    CombinacionesDeA2 = [2, 3] ;

    Para este caso [1, 2] = [2, 1] por lo tanto, no muestra los que sean iguales (pero permutados)

*/

% - COMBINACIONES AGARRADOS DE A N ELEMENTOS (+ Permutaciones)-

combinacionesAgrupadasPermutadas(0, _, []).

combinacionesAgrupadasPermutadas(Cantidad, Lista, [X|Ys]) :-
  Cantidad > 0,
  select(X, Lista, Resto),
  Cantidad1 is Cantidad - 1,
  combinacionesAgrupadasPermutadas(Cantidad1, Resto, Ys).

combinacionesAgrupadasPermutadas(Cantidad, [_|Xs], Ys):-
  Cantidad > 0,
  combinacionesAgrupadasPermutadas(Cantidad, Xs, Ys).

/*

    Ejemplo de uso:

    combinacionesAgrupadasPermutadas(2, [1,2,3], CombinacionesPermutadasDeA2).

    CombinacionesPermutadasDeA2 = [1, 2] ;
    CombinacionesPermutadasDeA2 = [1, 3] ;
    CombinacionesPermutadasDeA2 = [1, 3] ;
    CombinacionesPermutadasDeA2 = [2, 1] ;
    CombinacionesPermutadasDeA2 = [2, 3] ;
    CombinacionesPermutadasDeA2 = [2, 3] ;
    CombinacionesPermutadasDeA2 = [3, 1] ;
    CombinacionesPermutadasDeA2 = [3, 2] ;
    CombinacionesPermutadasDeA2 = [3, 2] ;
    CombinacionesPermutadasDeA2 = [2, 3] ;
    CombinacionesPermutadasDeA2 = [3, 2] ;

    Para este caso [1, 2] /= [2, 1] por lo tanto, muestra todas las combinaciones y las permutaciones.

*/

% - DISTANCIA DE RELACIONES DE DEPENDENCIA -

% rango/2: Relaciona dos cosas que Superior es inmediatamente "mayor" a Inferior.
rango(Superior,Inferior).

% La distancia es una si Superior es inmediatamente mayor a Inferior
distancia(Superior,Inferior,1):-
    rango(Superior,Inferior).

% En caso de que Superior no sea inmediatamente mayor a Inferior (y necesite intermedios)
distancia(Superior,Inferior,Distancia):-
    rango(Superior,Intermedio),
    distancia(Intermedio,Inferior,DistanciaIntermedia),
    Distancia is DistanciaIntermedia + 1.

% - DISTANCIAS SIMÉTRICAS -

% Es decir: distancia(Superior,Inferior) = distancia(Inferior,Superior)

distanciaSimetrica(Superior,Inferior,Distancia):-
    distancia(Superior,Inferior,Distancia).

distanciaSimetrica(Superior,Inferior,Distancia):-
    distancia(Inferior,Superior,Distancia).

% - ANTECESORES -

% Caso base: una persona es su propio antecesor.
% Es útil si queres incluir a la propia persona en la lista de antecesores.

antecesor(Persona,Antecesor).

antecesores(Persona, [Persona]) :-
    antecesor(Persona,_).

% Caso recursivo: encuentra todos los antecesores de los antecesores.
antecesores(Persona, [Antecesor | RestoAntecesores]) :-
    antecesor(Persona, Antecesor),
    antecesores(Antecesor, RestoAntecesores).

% - MEJOR SEGÚN CRITERIO - // Dificil de usar, recomiendo implementarlo de otra manera y no recurrir a esto :s

% Caso base: Si solo hay un elemento, ese es el mejor.
mejorSegunCriterio([Elemento], Elemento, _).

% Caso recursivo: Compara el primer elemento con el mejor del resto de la lista.
mejorSegunCriterio([Elemento1, Elemento2 | Resto], Mejor, Criterio) :-
    comparar(Elemento1, Elemento2, Criterio, MejorElemento),
    mejorSegunCriterio([MejorElemento | Resto], Mejor, Criterio).

% Predicados que evalúan el criterio directamente.
comparar(Elemento1, Elemento2, mayorQue, Elemento1) :- Elemento1 > Elemento2.
comparar(Elemento1, Elemento2, mayorQue, Elemento2) :- Elemento1 =< Elemento2.

comparar(Elemento1, Elemento2, menorQue, Elemento1) :- Elemento1 < Elemento2.
comparar(Elemento1, Elemento2, menorQue, Elemento2) :- Elemento1 >= Elemento2.

% Si querés agregar nuevos criterios, deberias declarar su atomo como 3° parámetro, y definir en la regla cual es el criterio, por ejemplo:

comparar(Elemento,OtroElemento,criterioMumukiano,Elemento):- hacerCriterioMumukiano(Elemento,OtroElemento).

hacerCriterioMumukiano(Elemento,OtroElemento). % Aplicar el criterio entre ambos elementos.

% --------------------------------------------------------------------------------------------------------------------------------------------

/*
    Funciones de la GUÍA de LENGUAJES con sus parámetros (porque no los tiene :c)
*/

% Longitud de una lista
length(Lista,Longitud).

% Concatenación de listas: Siendo que Concatenacion es la suma de juntar Lista1 y Lista2
append(Lista1, Lista2, Concatenacion).

% Unión de listas como si fueran conjuntos, por ejemplo union([1,2],[2,3],Union). Union = [1,2,3] (Que es la unión de ambos conjuntos)
union(Lista1,Lista2,Union).

% Intersección de listas como si fueran conjuntos, por ejemplo intersection([1,2],[2,3],Interseccion). Interseccion = [2] (Que es la intersección de ambos conjuntos)
intersection(Lista1,Lista2,Interseccion).

% Acceso a un elemento de una lista por índice (un LIST GET de toda la vida)

% Considerando que la lista arranca en el índice 0
nth0(Indice,Lista,Elemento).

% Considerando que la lista arranca en el índice 0
nth1(Indice,Lista,Elemento).
 
% Pertenencia de un elemento en una lista, el análogo a elem de Haskell. Da true si Elemento está en Lista
member(Elemento,Lista).

% Elemento Máximo y Mínimo (ORDENABLE) de una lista.
max_member(Maximo,Lista).
min_member(Minimo,Lista).

% Sumatoria de elementos (NUMÉRICOS) de una lista.
sumlist(Lista,Sumatoria).

% Aplanar una lista, es decir [[1,2,3]] -> [1,2,3]
flatten(Lista,Aplanada).

% Quitar elementos REPETIDOS de una lista.
list_to_set(Lista,SinRepetidos).

% Dar vuelta una lista, literalmente REVERSE de Haskell
reverse(Lista,Reversa).

% ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Finalmente, le pedí a CHATGPT que me diera algunas funciones recursivas que podían ser de utilidad, te las dejo por si EN ALGÚN CASO muy AISLADO y LOCO, las necesitas

% Elimina la primera aparición de un elemento en una lista.
eliminar(X, [X|Resto], Resto).
eliminar(X, [Cabeza|Resto], [Cabeza|Resultado]) :-
    eliminar(X, Resto, Resultado).

% Determina si una lista es una sublista de otra lista.
sublista([], _).
sublista([X|RestoSub], [X|Resto]) :-
    sublista(RestoSub, Resto).
sublista(Sublista, [_|Resto]) :-
    sublista(Sublista, Resto).

% Esta función aplica un predicado a cada elemento de una lista, generando una nueva lista.

map(_, [], []).
map(Predicado, [X|Xs], [Y|Ys]) :-
    call(Predicado, X, Y),
    map(Predicado, Xs, Ys).

% Filtra una lista, manteniendo solo los elementos que satisfacen un predicado.
filtrar(_, [], []).
filtrar(Predicado, [X|Xs], [X|Ys]) :-
    call(Predicado, X),
    filtrar(Predicado, Xs, Ys).
filtrar(Predicado, [_|Xs], Ys) :-
    filtrar(Predicado, Xs, Ys).

% Reduce una lista aplicando un predicado binario y acumulando un resultado.
foldl(_, Acumulador, [], Acumulador).
foldl(Predicado, Acumulador, [X|Xs], Resultado) :-
    call(Predicado, Acumulador, X, NuevoAcumulador),
    foldl(Predicado, NuevoAcumulador, Xs, Resultado).
