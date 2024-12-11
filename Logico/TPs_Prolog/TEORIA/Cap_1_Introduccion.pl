%%-------------------------------------------------------------- INTRODUCCION AL PARADIGMA LOGICO %%--------------------------------------------------------------------------------------------------
%3 Predicados e individuos
%La base de conocimiento se conforma de predicados: 
%el predicado pastas tiene aridad 1, esto significa que un solo individuo participa de la relación, por eso se escribe pastas/1. 
%A los predicados que tienen un solo argumento se los llama monádicos, y expresan características o atributos de los individuos en cuestión.

pastas(ravioles).
pastas(fideos).
pastas(involtinis).

%* Consultas de prueba ------------------------------------------
%1 ?- pastas(fideos).
%true.

%2 ?- pastas(_).
%true .

%4 ?- pastas(_).
%true ;
%true.

%5 ?- pastas(x).
%false.

%7 ?- pastas(Comida).
%Comida = ravioles ;
%Comida = fideos.

come(juan, ravioles).
come(brenda, fideos).
gusta(brenda, fideos).

%* Consultas de prueba ------------------------------------------
%4 ?- come(Alguien, fideos).
%Alguien = brenda.

%5 ?- gusta(_, fideos).
%true.

%6 ?- come(juan, _).
%true.

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