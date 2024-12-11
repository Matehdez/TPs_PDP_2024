%*IMPROLOG-----------------------------------------------------------------------

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(sophieTrio, mateo, contrabajo).


integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).


%Agregados-----------------------
integrante(vientosDelEste, mateo, trompeta).
integrante(vientosDelEste, homero, saxo).
integrante(vientosDelEste, marge, saxo).
integrante(vientosDelEste, tomas, saxo).
integrante(vientosDelEste, maggie, pandereta).
%---------------------------------

integrante(jazzmin, santi, bateria).

integrante(estudio1, santi, voz).
integrante(estudio1, luis, contrabajo).
integrante(estudio1, lore, violin).
integrante(estudio1, lisa, saxo).
integrante(estudio1, mateo, bateria).



%Integrante, relaciona un grupo con una persona del grupo y un instrumento

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).
nivelQueTiene(mateo, bateria, 4).


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

%*PUNTO1
%Saber si un grupo tiene buena base
%Hay alguien que toque instrumento armonico y alguien mas ritmico

grupoTal(Grupo) :-
    integrante(Grupo, Persona, _),
    integrante(Grupo, Persona2, _),
    tocaArmonico(Persona),
    tocaRitmico(Persona2),
    Persona \= Persona2.

tieneBuenaBase(Grupo) :-
    grupoTal(Grupo).

tocaArmonico(Persona):-
    integrante(_, Persona, Instrumento),
    instrumento(Instrumento, armonico).

tocaRitmico(Persona):-
    integrante(_, Persona, Instrumento),
    instrumento(Instrumento, ritmico).

%*PUNTO 2
%Saber si una persona se destaca en un grupo
%El nivel con el que toca es al menos 2 puntos mas de los demas

seDestaca(Persona, Grupo) :-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    forall((integrante(Grupo, Persona2, _), Persona \= Persona2), 
           (nivelQueTiene(Persona2, _, Nivel2), Nivel >= Nivel2 + 2)).

%*PUNTO 3
%Se estan armando distintos grupos
%grupo/2 , relaciona un grupo con su tipo
%Tipo puede ser bigband o formacionParticular

%vientos del este es BB
%SophieTrio es [Contrabajo, Guitarra, Violin]
%jazzmin es [bateria, bajo, trompeta, piano, guitarra]

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacionST).
grupo(jazzmin, formacionJazz).
grupo(estudio1, ensamble).


sirven(formacionST, [contrabajo, guitarra, violin]).
sirven(formacionJazz, [bateria, bajo, trompeta, piano, guitarra]).

%*PUNTO 4
%saber si hay cupo para un instrumento en un grupo
%En BB siempre hay para instrumentos melodicos de viento
%Independientemente del grupo, nadie tiene que tocarlo para que haya cupo
%Ademas el instrumento sirve para ese tipo de grupo

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)),
    not(integrante(Grupo, Instrumento, _)).

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, Tipo),
    sirven(Tipo, Instrumentos),
    member(Instrumento, Instrumentos),
    not(integrante(Grupo, _, Instrumento)).

%*PUNTO 5
%Saber si una persona puede incorporarse a un grupo y con qué instrumento
%la persona no debe formar parte de ese grupo
%hay cupo para ese instrumento
%nivel esperado mayor o igual al minimo de grupo

%Nivel de BB min 1
%Nivel de formacionParticular 7-InstrumentosBuscados

puedeIncorporarse(Persona, Grupo) :-
    nivelQueTiene(Persona, Instrumento, Nivel),
    not(integrante(Grupo, Persona, _)),
    hayCupo(Instrumento, Grupo),
    grupo(Grupo, _),
    cumpleNivel(Grupo, Nivel).

cumpleNivel(Grupo, NivelPersona) :-
    grupo(Grupo, bigBand),
    NivelPersona >= 1.

cumpleNivel(Grupo, NivelPersona) :-
    grupo(Grupo, Tipo),
    sirven(Tipo, Instrumentos),
    length(Instrumentos, Cantidad),
    NivelPersona >= 7 - Cantidad.

%*PUNTO 6
%Saber si a una persona se la dejo en banda
%ocurre cuando no forma parte de un grupo y no se puede unir a ninguno

seLaDejoEnBanda(Persona) :-
    nivelQueTiene(Persona, _, _),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(Persona, _)).
    
%*PUNTO 7
%Saber si un grupo puede tocar
%Se cumple si con los integrantes que tocan algun instrumento logran cumplir las necesidades minimas del grupo:

%para las bb, hay que tener buena base y al menos 5 personas que toquen viento
%para lasFormsPart, deben tener para todos los instruemntos requeridos alguien que los toque.

puedeTocar(Grupo) :-
    necesidades(Grupo).

necesidades(Grupo) :-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    findall(Instrumento, (integrante(Grupo, _ , Instrumento), instrumento(Instrumento, melodico(viento))), Viento),
    length(Viento, Cantidad),
    Cantidad >= 5.

necesidades(Grupo) :-
    grupo(Grupo, Tipo),
    sirven(Tipo, Instrumentos),
    forall(member(Instrumento, Instrumentos), integrante(Grupo, _, Instrumento)).

necesidades(Grupo) :-
    grupo(Grupo, ensamble),
    tieneBuenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).

%*PUNTO 8
%Queremos incorporar otro tipo de grupo: Ensambles

%Para cada ensamble, debera informarse cual es el nivel minimo que tiene que tener una persona para poder incorporarse
%Cualquier instrumento sirve para los ensambles
%Para que pueda tocar hace falta buena base, y al menos una persona que toque melodico
    








