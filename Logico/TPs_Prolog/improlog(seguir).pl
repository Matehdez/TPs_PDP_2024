%*============================PARCIAL IMPROLOG ====================================================

%*Big Bands
%*Muchos instrumentos de viento y rara vez necesitan improvisar

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).

integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).

integrante(jazzmin, santi, bateria).

%Integrante, relaciona un grupo con una persona del grupo y un instrumento

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

%Nivel, relaciona persona, con instrumento y su nivel del mismo

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

%Instrumento, relaciona instrumento con tipo 

%*PUNTO 1------------------------------------------------
%Saber si un grupo tiene buena base
%si hay algun integrante de grupo que toque ritmico
%si hay algun integrante de grupo que toque armonico

tieneBuenaBase(Grupo):-
    integrante(Grupo, _, _),
    tieneInstrumentoArmonico(Grupo),
    tieneInstrumentoRitmico(Grupo).

tieneInstrumentoRitmico(Grupo) :-
    integrante(Grupo, _ , Instrumento),
    instrumento(Instrumento, ritmico).

tieneInstrumentoArmonico(Grupo) :-
    integrante(Grupo, _ , Instrumento),
     instrumento(Instrumento, armonico).

%*PUNTO 2------------------------------------------------
%Saber si una persona se destaca en un grupo
%El nivel con el que toca es al menos 2 puntos mas de los demas

seDestaca(Persona,Grupo):-
    integrante(Grupo,Persona,Instrumento),
    nivelQueTiene(Persona,Instrumento,Nivel),
    findall((Integrante,OtroInstrumento),integrante(Grupo,Integrante,OtroInstrumento),Instrumentos),
    forall((member((Integrante,OtroInstrumento),Instrumentos),nivelQueTiene(Integrante,OtroInstrumento,NivelGrupo),Integrante\=Persona),(abs(Nivel-2)>NivelGrupo)).

%*PUNTO 3 ------------------------------------------------------------
%Relacionar mediante gropo/2
%Un grupo con su tipo de grupo
%cada grupo puede ser bigband o formacionParticular

grupo(vientosDelEste, bigBand([bateria, bajo, piano])).
grupo(sophieTrio, [contrabajo, guitarra, violin]).
grupo(jazzmin, [bateria, bajo, trompeta, piano, guitarra]).

%*PUNTO 4---------------------------------------------------------------
%Saber si hay cupo

%Para BigBand siempre hay grupo para instrumientos dmelodicos de viento

hayCupo(Instrumento, Grupo) :-
    sirveParaGrupo(Grupo, Instrumento),
    forall(integrante(Grupo, _, Instrumento2), Instrumento\=Instrumento2).

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).


%independientemente del tipo, se cumple:
%hay cupo si nadie toca ese instrumento en el grupo
%El instrumento sirve para el tipo de grupo

sirveParaGrupo(Grupo, Instrumento) :-
    grupo(Grupo, Instrumentos),
    member(Instrumento, Instrumentos).
    