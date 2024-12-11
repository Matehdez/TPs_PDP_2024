%* PARCIAL MOTIVACIONES ==================================================
%* ENUNCIADO =======================================================

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

necesidad(reconocimiento, confianza).
necesidad(reconocimiento, respeto).
necesidad(reconocimiento, exito).

necesidad(autorrealizacion, necesidades()).

%*PUNTO 1-----------------------------------------
nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

%* PUNTO 2----------------------------------------
%Averiguar separacion de niveles entre dos necesidades

separacionNivel(Necesidad1, Necesidad2, Separacion) :-
    necesidad(NivelA, Necesidad1),
    necesidad(NivelB, Necesidad2),
    separacionEntre(NivelA, NivelB, Separacion).

separacionEntre(Nivel, Nivel, 0).
separacionEntre(NivelA, NivelB, Separacion):-
    nivelSuperior(NivelB, NivelMedio),
    separacionEntre(NivelA, NivelMedio, SepAnt),
    Separacion is SepAnt + 1.






