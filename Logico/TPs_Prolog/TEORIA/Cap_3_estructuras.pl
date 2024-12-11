%%-------------------------------------------------------------- CAPITULO 3 %%--------------------------------------------------------------------------------------------------
%Estructuras de datos

%Consultas varias ----------------------------------------------
%? 5 = 2 + 3
%false // el número 5 no es igual a la expresión 2 + 3

%? 2 + 3 = 3 + 2
%false // la expresión 2 + 3 no es igual a la expresión 3 + 2

%? 2 + 3 = 2 + 3
%true // son las mismas expresiones

%Para probar las igualdades anteriores, se debe utilizar el operador `is/2`:
% Num is Operacion (la inversibilidad esta restringida)

%Consultas varias ----------------------------------------------
%? 4 is 2 * 2.
%true // se puede unificar 4 a la expresión evaluada 2 * 2

%? 4 is 24 - 6.
%false // 4 no es unificable a 18

%? Z is 2 * 2.
%Z = 4 _ // existe un individuo que satisface la operación 2 * 2, que se evalúa como 4

%%PATTERN MATCHING ===================================================
%A diferencia de Haskell, el pattern matching va a matchear con todas las posibilidades, no restringiendo la imagen a un solo valor.

%Listas ==============================================================
["Borges"].
[1,2,3,4,5].

%Length -----------------------------
%Se considera inveresible

%Member -----------------------------

%Append -----------------------------
%Se considera inversible

%Functores ============================================================
%Los functores permiten agrupar información relacionada.

nacio(karla, fecha(22, 08, 1979)).
compro(cliente(231024, "Nelson Pedernera"),
       producto(pirufio, 239, 1)).



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