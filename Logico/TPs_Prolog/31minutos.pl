%*============================PARCIAL 31 MINUTOS =================================================
%* Canciones
%* De las canciones se conocen sus compositores y su cantidad de reproducciones.

% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 

cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
%Revisa el archivo del repo, que este hecho estaba con un argumento de más.

cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).


%* También se conoce el ranking de top 3 canciones más valoradas por los críticos de música durante los últimos 5 meses. 
%* Los críticos cambian mucho de opinión por lo que es común que una canción tenga diferente posición en el ranking a 
%*lo largo de los meses.

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).
rankingTop3(mayo, 2, tangananicaTanganana).


%* PUNTO 1 -------------------------------------------------------------------------------
% Saber si una canción es un hit, lo cual ocurre si aparece en el ranking top 3 de todos los meses.

% Ejemplo: No hay ningún hit actualmente. Por ejemplo, a Tangananica Tanganana le falta estar en mayo y a Lala 
% le falta abril y mayo.

esHit(Nombre) :-
    cancion(Nombre, _, _),
    forall(rankingTop3(Mes, _, _ ), rankingTop3(Mes, _ , Nombre)).


%*PUNTO 2 --------------------------------------------------------------------------------
% Saber si una canción no es reconocida por los críticos, lo cual ocurre si tiene muchas reproducciones y 
% nunca estuvo en el ranking. Una canción tiene muchas reproducciones si tiene más de 7000000 reproducciones.

noEsReconocida(Nombre):-
    cancion(Nombre, _ , Reproducciones),
    tieneMuchasReproducciones(Reproducciones),
    nuncaEstuvoEnRanking(Nombre).

tieneMuchasReproducciones(Reproducciones) :-
    Reproducciones > 7000000.

nuncaEstuvoEnRanking(Nombre) :-
    not(rankingTop3(_, _, Nombre)).

%*PUNTO 3 --------------------------------------------------------------------------------
% Saber si dos compositores son colaboradores, lo cual ocurre si compusieron alguna canción juntos.

colabora(Compositor1, Compositor2) :-
    cancion(_, Compositores, _),
    member(Compositor1, Compositores),
    member(Compositor2, Compositores),
    Compositor1 \= Compositor2.

%*Trabajos=======================================================================================
%En el noticiero 31 Minutos cada trabajador puede tener múltiples trabajos. 
%Algunos de los tipos de trabajos que existen son:

% Los conductores, de los cuales nos interesa sus años de experiencia.

/*Los periodistas, de los cuales nos interesa sus años de experiencia y su título, 
el cual puede ser licenciatura o posgrado. */

/*Los reporteros, de los cuales nos interesa sus años de experiencia y la cantidad de notas que hicieron a lo 
largo de su carrera.*/

%* Modelar en la solución a los siguientes trabajadores:--------------------------------------------------------
% Tulio, conductor con 5 años de experiencia.
trabaja(tulio, titulo(conductor, 5)).

%! trabaja(Nombre, trabajo()).

% Bodoque, periodista con 2 años de experiencia con un título de licenciatura, y 
% también reportero con 5 años de experiencia y 300 notas realizadas.
trabaja(bodoque, titulo(periodista, 2, licenciatura)).
trabaja(bodoque, titulo(reportero, 5, 300)).

% Mario Hugo, periodista con 10 años de experiencia con un posgrado.
trabaja(marioHugo, titulo(periodista, 10, posgrado)).


% Juanin, que es un conductor que recién empieza así que no tiene años de experiencia.
%No lo declaro

%* Conocer el sueldo total de una persona, el cual está dado por la suma de los sueldos de cada uno de sus trabajos. 
%* El sueldo de cada trabajo se calcula de la siguiente forma:

sueldoTotal(Persona, SueldoTotal) :-
    trabaja(Persona, _),
    findall(Sueldo, (trabaja(Persona, Titulo),sueldo(Titulo, Sueldo)), Sueldos),
    sumlist(Sueldos, SueldoTotal).

persona(Persona) :-
    trabaja(Persona, _).

% El sueldo de un conductor es de 10000 por cada año de experiencia
sueldo(titulo(conductor, XP), Sueldo) :-
    Sueldo is XP * 10000.

% El sueldo de un reportero también es 10000 por cada año de experiencia más  100 por cada nota que haya hecho 
% en su carrera.

sueldo(titulo(reportero, XP, Notas), Sueldo) :-
    Sueldo is (XP * 10000) + (100 * Notas).

% Los periodistas, por cada año de experiencia reciben 5000, pero se les aplica un porcentaje de incremento del 20% 
% cuando tienen una licenciatura o del 35% si tienen un posgrado.

sueldo(titulo(periodista, XP, licenciatura), Sueldo) :-
    Sueldo is (XP * 5000  * 1.2).

sueldo(titulo(periodista, XP, posgrado), Sueldo) :-
    Sueldo is (XP * 5000 * 1.35).


%* PUNTO 6 ==========================================================================
% Agregar un nuevo trabajador que tenga otro tipo de trabajo nuevo distinto a los anteriores. 

%Maquillador
%Experiencia

% Agregar una forma de calcular el sueldo para el nuevo trabajo agregado 
% ¿Qué concepto de la materia se puede relacionar a esto?







