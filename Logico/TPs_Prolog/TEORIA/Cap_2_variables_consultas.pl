%%-------------------------------------------------------------- CAPITULO 2 %%--------------------------------------------------------------------------------------------------

%3 Inversibilidad
%Decimos que un predicado es inversible cuando admite consultas con variables libres para sus argumentos: 
%en el caso de los hechos no hay restricciones así que tanto come/2 como pastas/1 son totalmente inversibles.

mortal(Persona):-humano(Persona).
humano(socrates).
humano(deadpool).

%Conjunciones
viveEn(tefi, lanus).
viveEn(gise, lanus).
viveEn(alf, lanus).
viveEn(dodain, liniers).
docente(alf).
docente(tefi).
docente(gise).
docente(dodain).
%Se dice que cualquier docente que vive en lanus es un afortunado:
afortunado(Persona):-
    docente(Persona), 
    viveEn(Persona, lanus).

%Disyunciones
%Se dice entonces que, “Si una persona es docente o vive en Lanús es afortunada”
afortunada(Persona):-docente(Persona).
afortunada(Persona):-viveEn(Persona, lanus).

%Practica-------------------------------------------

gustaDe(juan, maria).
gustaDe(pedro, ana).
gustaDe(pedro, nora).
gustaDe(Persona, zulema) :-
    gustaDe(Persona, nora).


/*⣿⣿⣿⣿⣿⢟⢋⠘⡘⢉⠃⡙⠑⡁⠢⡨⢁⠀⠲⣩⠚⣏⠹⢻⠿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⠋⠄⡥⢁⠐⠀⠐⠀⠀⠄⠀⠄⠀⡈⠐⠁⠈⠂⡐⠀⠙⡠⢙⢿⣿⣿⣿⣿
⣿⣿⢧⢏⡈⢂⠀⠈⠀⠂⠀⠐⠀⠐⠀⠠⠀⠀⠀⠀⠈⠀⠀⡈⠐⠀⠵⡝⣽⣿⣿⣿
⣿⡿⡑⡅⡊⠀⠀⠁⠀⠐⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠄⠈⠀⠀⠀⠁⠨⡨⣷⡽⣿⣿
⡿⠬⢌⠂⠄⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⡈⠃⠭⢪⣿
⣯⠑⠀⢀⠀⠀⠀⠀⠀⠄⠠⡂⢄⢌⢄⢄⡐⣌⡢⡡⡐⡄⡠⠀⠀⠀⠀⠀⠈⠀⡽⡪
⣯⠣⠀⢀⠀⠄⢀⠌⡴⣩⢯⣪⡺⣢⢗⡜⡮⡮⣺⡱⣏⢞⡜⡦⡡⡄⡀⠀⠀⠀⠐⣸
⣧⠁⠄⠠⠀⡔⡥⣺⢕⢯⢞⢼⢕⢯⣪⢻⡜⣯⢺⡕⣯⢪⡏⣞⢜⡜⣔⠀⠀⡀⠂⣽
⡾⠀⠄⢀⢎⣞⢵⡝⣵⡫⣳⢝⡮⣳⢕⡯⣺⢕⣗⣝⢮⡳⡪⡮⣪⢪⢢⢓⠄⡀⠠⣿
⣿⠀⠂⢌⡞⣮⢳⣝⣮⣫⡷⣻⡽⡾⣝⢾⣝⢷⢵⣝⢮⢮⡻⣜⢖⢕⢕⠕⡥⠀⢠⣿
⣿⣇⠀⣪⢞⠊⡑⢑⠕⠙⠾⡝⡽⣫⢞⡷⣹⡳⡳⡝⡵⠳⠹⠌⠣⠋⠪⢪⠪⠄⢐⣿
⣿⣿⡀⢮⢰⡕⠷⡢⢆⠌⡠⠠⣪⢣⣟⢾⡵⡝⡕⢅⠄⢄⠠⠂⡖⠲⡢⣂⢙⠆⣾⣿
⣿⢿⠇⣺⢕⢎⠕⣥⡠⡀⢴⢣⡪⣳⢝⢷⢕⡭⣊⠢⡪⣶⡀⡠⡨⠂⢱⢌⢆⢳⣿⣿
⣇⢺⢆⡿⣸⢳⡪⣆⢧⡫⣪⢶⡹⣎⢗⡯⡺⡰⣅⢫⢪⡲⣩⢪⢊⡕⡬⡲⣡⢋⡉⣿
⣧⠳⣕⢽⡪⡷⣝⢮⡳⣝⢮⣣⢟⡜⡧⣻⡘⢦⠱⡱⡥⣫⢪⢗⡝⣜⢮⠺⡔⣕⠀⣿
⣿⣏⢪⡳⣝⢾⡕⣯⡺⣕⣯⢞⡵⣹⡺⡼⣕⢕⢅⠝⣮⢎⡷⡱⣝⢜⢎⡳⡱⠜⣰⣿
⣿⣿⢌⡷⣹⢧⡻⣮⢻⡮⣳⢏⢞⡕⣟⢽⡪⡣⢪⢊⠜⣷⢝⢮⢎⢮⢱⡑⡕⡃⣽⣿
⣿⣿⢪⡎⡷⣝⢷⡹⣗⣽⢫⡗⡵⣰⢵⣑⢌⡄⡢⣡⡺⡵⣫⢗⡵⣑⢕⠬⡪⡐⢿⣿
⣿⣿⣮⣎⢗⢽⡪⣟⢮⢳⢝⡎⣯⣪⣗⢵⢯⡺⣜⠴⡱⢝⢜⠵⡕⣎⠢⡓⣌⣔⣽⣿
⣿⣿⣿⣿⡱⣫⢮⣫⢎⡳⢵⢫⠞⢎⢞⢕⡫⡱⡑⠝⢜⢕⢕⢝⢜⠔⡍⡪⣾⣿⣿⣿
⣿⣿⣿⣿⣝⢎⡗⣵⡫⡾⣶⢖⡽⣨⢧⢕⡬⣔⢕⢕⢖⡵⡣⡳⡑⡕⡘⣼⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡜⢮⢵⡹⣺⢳⣏⢟⡕⣗⠹⡪⡪⡣⡫⡎⢮⠪⡕⢌⠪⢰⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡱⡱⡝⢮⣳⣝⣯⣻⢜⡵⣕⢮⡺⡕⣏⢪⠊⡆⡑⢡⣻⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⢕⢮⢊⢗⢜⢮⣎⢗⡟⣞⢮⡳⡱⡕⢅⠣⢈⠔⡨⠢⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣝⢕⡧⣪⡘⢕⢜⢫⢎⢞⡪⡪⡣⡑⢑⠐⢄⠅⡪⡘⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡜⣧⢫⢖⡕⡵⣨⢢⡑⢄⡑⡐⢄⠌⡄⢱⢀⡣⡜⡬⢿⣿⣿⣿⣿⣿*/