%%-------------------------------------------------------------- CAPITULO 3 %%--------------------------------------------------------------------------------------------------
/*Funciones de Orden Superior:*/

% not/1, 
% forall/2 
% findall/3 

/* Usos de Forall y not ==========================================================================================*/

/*Mientras que el predicado forall/2 trabaja en base a la cuantificación universal: “para todos se cumple”, 
not/1 trabaja en base a la cuantificación individual negativa: “no existe x tal que cumpla...”, por lo tanto son predicados que pueden */

/*Generar variables inversibles ===================================================================================*/

/*Por último, para tener predicados inversibles se necesita ligar las variables que participan de las consultas mediante predicados generadores:*/

% en la negación lógica, porque no es posible en Prolog determinar los individuos que no satisfacen un predicado si no conocemos todo el universo.
% en las cláusulas findall y forall, porque debemos estar atentos a las variables libres y ligadas que participarán dentro de dichas cláusulas.

%Ejercicio integrador =============================================================================================

tiene(juan, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(juan, foto([juan], 1977)).
tiene(juan, libro(saramago, "Ensayo sobre la ceguera")).
tiene(juan, bebida(whisky)).
tiene(valeria, libro(borges, "Ficciones")).
tiene(lucas, bebida(cusenier)).
tiene(pedro, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(pedro, foto([pedro], 2010)).
tiene(pedro, libro(octavioPaz, "Salamandra")).
 
premioNobel(octavioPaz).
premioNobel(saramago).

/*Determinamos que alguien es coleccionista si todos los elementos que tiene son valiosos:*/

% un libro de un premio Nobel es valioso
% una foto con más de 3 integrantes es valiosa
% una foto anterior a 1990 es valiosa
% el whisky es valioso

coleccionista(Alguien):-
    tiene(Alguien, _),
    forall(tiene(Alguien, Cosa), vale(Cosa)).


vale(foto(Gente, _)):-length(Gente, Cantidad), Cantidad > 3.
vale(foto(_, Anio)):-Anio < 1990.
vale(libro(Escritor, _)):-premioNobel(Escritor).
vale(bebida(whisky)).


    