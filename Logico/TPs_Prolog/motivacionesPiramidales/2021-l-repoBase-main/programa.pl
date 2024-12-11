% Aquí va el código.
necesidad(fisiologico, alimentacion).
necesidad(fisiologico, respiracion).
necesidad(fisiologico, descanso).
necesidad(fisiologico, reproduccion).

necesidad(seguridad, integridadFisica).
necesidad(seguridad, empleo).
necesidad(seguridad, salud).

necesidad(social, amistad).
necesidad(social, afecto).
necesidad(social, intimidad).
necesidad(social, completarPase).

necesidad(reconocimiento, confianza).
necesidad(reconocimiento, respeto).
necesidad(reconocimiento, exito).

necesidad(autorrealizacion, chad).
necesidad(autorrealizacion, millonario).
necesidad(autorrealizacion, estarBasado).



%Agregar hechos para completar la información de las necesidades y niveles con algunos de los ejemplos mencionados e 
%inventando nuevas necesidades e incluso niveles. Se asume que los niveles son distintos y están ordenados 
%jerárquicamente entre sí, que no hay niveles sin necesidades y que una misma necesidad 
%no puede estar en dos niveles a la vez. 

nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

%*PUNTO 2
%Permitir averiguar la separación de niveles que hay entre dos necesidades, 
%es decir la cantidad de niveles que hay entre una y otra.

%Por ejemplo, con los ejemplos del texto de arriba, la separación entre empleo y salud es 0, y 
%la separación entre respiración y confianza es 3.

distanciaNecesidades(Necesidad1, Necesidad2, Distancia):-
    necesidad(Nivel, Necesidad1),
    necesidad(Nivel, Necesidad2),
    Distancia is 0.

distanciaNecesidades(Necesidad1, Necesidad2, Distancia):-
    necesidad(Nivel1, Necesidad1),
    necesidad(Nivel2, Necesidad2),
    distanciaTotalNiveles(Nivel1, Nivel2, Distancia).

distanciaEntreNiveles(NivelSuperior, NivelInferior, 1) :-
    nivelSuperior(NivelSuperior, NivelInferior).

distanciaEntreNiveles(NivelSuperior, NivelInferior, Distancia) :-
    nivelSuperior(NivelSuperior, NivelIntermedio),
    distanciaEntreNiveles(NivelIntermedio, NivelInferior, DistanciaMedia),
    Distancia is DistanciaMedia +1.

distanciaTotalNiveles(NivelSuperior, NivelInferior, D):-
    distanciaEntreNiveles(NivelSuperior, NivelInferior, D).
distanciaTotalNiveles(NivelSuperior, NivelInferior, D):-
    distanciaEntreNiveles(NivelInferior, NivelSuperior, D).



%Modelar las necesidades (sin satisfacer) de cada persona. 
%Recuerden leer los puntos siguientes para saber cómo se va a usar y cómo modelar esta información.

%Por ejemplo:
%Carla necesita alimentarse, descansar y tener un empleo. 
%Juan no necesita empleo pero busca alguien que le brinde afecto. Se anotó en la facu porque desea ser exitoso. 
%Roberto quiere tener un millón de amigos. 
%Manuel necesita una bandera para la liberación, no quiere más que España lo domine ¡no señor!.
%Charly necesita alguien que lo emparche un poco y que limpie su cabeza.

necesitaSatisfacer(carla, alimentacion).
necesitaSatisfacer(carla, descanso).
necesitaSatisfacer(carla, empleo).

necesitaSatisfacer(juan, afecto).
necesitaSatisfacer(juan, exito).

necesitaSatisfacer(juan, afecto).

necesitaSatisfacer(kako, Necesidad) :-
    necesidad(autorrealizacion, Necesidad).


%*PUNTO 4
% Encontrar la necesidad de mayor jerarquía de una persona. 
% En el caso de Carla, es tener un empleo.

%TODO----------------------------------------------------------------------------------------------
esMayor(Necesidad, OtraNecesidad) :-
    distanciaNecesidades(Necesidad, OtraNecesidad, D1),
    distanciaNecesidades(OtraNecesidad, _, D2),
    D1 >= D2.

mayorJerarquia(Persona, Necesidad) :-
    necesitaSatisfacer(Persona, Necesidad),
    forall((necesitaSatisfacer(Persona, OtraNecesidad), Necesidad \= OtraNecesidad), esMayor(Necesidad, OtraNecesidad)).

%*PUNTO 5
% Saber si una persona pudo satisfacer por completo algún nivel de la pirámide.
% Por ejemplo, Juan pudo satisfacer por completo el nivel fisiologico.

pudoSatisfacer(Persona, Nivel) :-
    necesitaSatisfacer(Persona, _),
    necesidad(Nivel, _),
    forall(necesidad(Nivel, Necesidad), not(necesitaSatisfacer(Persona, Necesidad))).

%La teoría de Maslow plantea que la motivación de cualquier persona para actuar parte de sus necesidades y a medida que
 %se satisfacen las necesidades más básicas se manifiestan otras, lo que hace que sus motivaciones también sean 
 %diferentes. 
 
 %En base a eso, uno de sus elementos centrales de es que las personas sólo atienden necesidades 
 %superiores cuando han satisfecho las necesidades inferiores. 
 
 %or ejemplo, las necesidades de seguridad surgen cuando las necesidades fisiológicas están satisfechas. 


%Definir los predicados que permitan analizar si es cierta o no la teoría de Maslow:
%Para una persona en particular.
%Para todas las personas.
%Para la mayoría de las personas. 

%Nota: existen los predicados de aridad 0. Por ejemplo: 
%noLlegoElFinDelMundo :- vive(Alguien).

cumpleTeoria(Persona) :-
    mayorJerarquia(Persona, Necesidad),
    necesidad(Nivel, Necesidad),
    findall(OtroNivel, (pudoSatisfacer(Persona, OtroNivel), Nivel \= OtroNivel), Niveles),
    satisface(Nivel, Niveles).

satisface(_, []).
satisface(Nivel, [X|Niveles]) :-
    nivelSuperior(Nivel,X),
    satisface(Nivel, Niveles).

    



