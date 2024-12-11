ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

% Punto 1

%marcaDelModelo(marca, modelo)
marcaDelModelo(peugot, 2008).
marcaDelModelo(peugot, 3008).
marcaDelModelo(mini, countryman).
marcaDelModelo(volkswagen, touareg).
marcaDelModelo(toyota, hilux).

/* b. Si quisiera agregar que el modelo buggy es de la marca mini, puedo agregar un hecho a mi base de conocimientos:
marcaDelModelo(mini, buggy).

En el caso del modelo dkr, no es necesario agregar nada, ya que gracias al principio de universo cerrado aquello
que no está definido en mi base de conocimientos, es falso, por lo que consultar:

marcaDelModelo(mini, dkr). 

Daría falso.
*/

% Punto 2

%ganadorReincidente(Competidor) -> aquel que ganó más de un año. Es decir que existen dos años en los que gano, y esos años son diferentes.
ganadorReincidente(Competidor):-
    ganoEn(UnAnio, Competidor),
    ganoEn(OtroAnio, Competidor),
    UnAnio \= OtroAnio.

ganoEn(Anio, Ganador):-
    ganador(Anio, Ganador, _).

%Punto 3

%insipiraA(Inspirador, Inspirado) -> Un conductor resulta inspirador para otro cuando ganó y el otro no, y también resulta inspirador cuando ganó algún año anterior al otro. En cualquier caso, el inspirador debe ser del mismo país que el inspirado.

/*
Es decir que se cumple cuando:
- Son del mismo pais y
- Puede insipirarlo

Podrá inspirarlo cuando:
- El inspirador ganó y el inspirado no

O bien:
- El inspirador ganó un año anterior al inspirado

*/

inspiraA(Inspirador, Inspirado):-
    sonDelMismoPais(Inspirador, Inspirado),
    puedeInspirarlo(Inspirador, Inspirado).

%sonDelMismoPais(UnCompetidor, OtroCompetidor)
sonDelMismoPais(UnCompetidor, OtroCompetidor):-
    pais(UnCompetidor, Pais),
    pais(OtroCompetidor, Pais),
    UnCompetidor \= OtroCompetidor.

%puedeInspirarlo(Inspirador, Inspirado) -> caso en el que ganó el inspirador y el inspirado no
puedeInspirarlo(Inspirador, Inspirado):-
    ganoEn(Anio, Inspirador),
    not(ganoEn(Anio, Inspirado)).

%caso que el inspirador ganó un año anterior
puedeInspirarlo(Inspirador, Inspirado):-
    ganoEn(UnAnio, Inspirador),
    ganoEn(OtroAnio, Inspirado),
    UnAnio < OtroAnio.

% Punto 4

/*
marcaDeLaFortuna(Conductor, Marca) -> se cumple si el conductor gano solo con vehiculos de esa marca. 
Es decir que no existe una marca diferente a la que usa.
*/

marcaDeLaFortuna(Conductor, Marca):-
    ganoEn(_, Conductor), %tienen que haber ganado
    usoMarca(Conductor, Marca),
    not(ganoConOtraMarca(Conductor, Marca)).

%ganoConOtraMarca(Conductor, Marca)
ganoConOtraMarca(Conductor, Marca):-
    usoMarca(Conductor, Marca),
    usoMarca(Conductor, OtraMarca),
    OtraMarca \= Marca.

%usoMarca(Anio, Conductor, Marca)
usoMarca(Conductor, Marca):-
    ganador(_, Conductor, Vehiculo),
    marca(Vehiculo, Marca).

%marca(Vehiculo, Marca), sabiendo que los vehiculos son de la forma:

/*
auto(modelo)
moto(anioDeFabricacion, suspensionesExtras)
camion(items)
cuatri(marca)
*/

%del auto depende del modelo
marca(auto(Modelo), Marca):-
    marcaDelModelo(Marca, Modelo).

%del cuatri se indica en el functor
marca(cuatri(Marca), Marca).

%la moto se resuelve segun si fue antes o despues del año 2000
marca(Moto, ktm):-
    fabricadaDesdeAnio(2000, Moto).

marca(Moto, yamaha):-
    esMoto(Moto),
    not(fabricadaDesdeAnio(2000, Moto)).

%el camion depende de si lleva o no vodka en los items

marca(Camion, kamaz):-
    lleva(vodka, Camion).

marca(Camion, iveco):-
    esCamion(Camion),
    not(lleva(vodka, Camion)).

fabricadaDesdeAnio(Anio, moto(AnioFabricacion, _)):-
    AnioFabricacion >= Anio.

lleva(Item, camion(Items)):-
    member(Item, Items).

%esMoto(Vehiculo)
esMoto(moto(_,_)).

%esCamion(Vehiculo)
esCamion(camion(_)).

% Punto 5

/*
heroePopular(Conductor) -> se cumple cuando

- Sirvio de inspiracion a alguien y
- Fue el unico en no usar un vehiculo caro cuando gano
*/

heroePopular(Conductor):-
    inspiraA(Conductor, _),
    unicoSinVehiculoCaro(Conductor).

%unicoSinVehiculoCaro(Conductor) -> 
/*
Se cumple si:
- No uso uno vehiculo caro el año que gano
- Se cumple que para todo otro ganador ese mismo año, uso un vehiculo caro
*/
unicoSinVehiculoCaro(Conductor):-
    ganoEn(Anio, Conductor),
    not(usoVehiculoCaro(Conductor, Anio)),
    forall(ganadorDiferente(Anio, Conductor, OtroConductor), usoVehiculoCaro(OtroConductor, Anio)).

ganadorDiferente(Anio, Conductor, OtroConductor):-
    ganoEn(Anio, Conductor),
    ganoEn(Anio, OtroConductor),
    OtroConductor \= Conductor.

usoVehiculoCaro(Conductor, Anio):-
    ganador(Anio, Conductor, Vehiculo),
    esCaro(Vehiculo).

%esCara(Marca)
marcaCara(mini).
marcaCara(toyota).
marcaCara(iveco).

%esCaro(Vehiculo) -> marca cara o bien tiene al menos 3 suspensiones extras
esCaro(Vehiculo):-
    marca(Vehiculo, Marca),
    marcaCara(Marca).

esCaro(Vehiculo):-
    suspensionesExtra(Vehiculo, Suspensiones),
    Suspensiones >= 3.

suspensionesExtra(moto(_, Suspensiones), Suspensiones).
suspensionesExtra(cuatri(_),4).

%PUNTO 6----------------------------------------------------------
%Los corredores se enteraron del sistema que estamos desarrollando y quieren que los ayudemos a planificar su recorrido. 
%Para armar sus estrategias, nos pidieron un programa les permita separar el recorrido en tramos para decidir en qué 
%ciudades frenar a hacer mantenimiento. Para eso:

%Necesitamos un predicado que permita saber cuántos kilómetros existen entre dos locaciones distintas. 

kilometrosViaje(Origen, Destino, Kms):-
    etapa(Origen, Destino, Kms).
kilometrosViaje(Origen, Destino, KmsTotales):-
    etapa(Origen, PuntoIntermedio, KmsIntermedios),
    kilometrosViaje(PuntoIntermedio, Destino, KmsFinales),
    KmsTotales is KmsIntermedios + KmsFinales.

totalViaje(Origen, Destino, Kms):-
    kilometrosViaje(Origen, Destino, Kms).
 totalViaje(Origen, Destino, Kms):-
    kilometrosViaje(Destino, Origen, Kms).

%¡Atención! Debe poder calcularse también entre locaciones que no pertenezcan a la misma etapa. 
%Por ejemplo, entre sanRafael y copiapo hay 208+326+177+274 = 985 km

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

%Saber si un vehículo puede recorrer cierta distancia sin parar. Por ahora (posiblemente cambie) diremos 
%que un vehículo caro puede recorrer 2000 km, mientras que el resto solamente 1800 km. Además, los camiones pueden 
%también recorrer una distancia máxima igual a la cantidad de cosas que lleva * 1000.

%Por ejemplo, una moto(1999,1) como no es cara, puede recorrer 1800 km pero no 1900 km.

noPara(Kms, Vehiculo) :-
    esCaro(Vehiculo),
    Kms<=2000.

