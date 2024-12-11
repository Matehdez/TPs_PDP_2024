module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================Star Wars=================================== *--
-- *APROBADO * --

-- * CONCEPTOS GENERALES
--Las fuerzas rebeldes analizan diferentes estrategias para enfrentarse a las naves espaciales imperiales de Darth Vader.
--Debido a los bajos números de la resistencia decidieron que por cada flota enemiga van a enviar a una única nave 
--para llevar adelante misiones sorpresa. Para ello, decidieron hacer un programa en Haskell Espacial que les permita 
--planificar adecuadamente la lucha contra el lado oscuro simulando estos combates.


data Nave = UnaNave {
    nombre :: String,
    durabilidad :: Number,
    escudo :: Number,
    ataque :: Number,
    poder :: Poder
} deriving (Show, Eq)

type Poder = (Nave -> Nave)

-- * PUNTO 1

disminuirAtaque :: Number -> Nave -> Nave
disminuirAtaque n nave = nave {ataque = restaPositiva(ataque nave) n}

-- ^
restaPositiva :: Number -> Number -> Number
restaPositiva n m = max 0 (n-m)

movimientoTurbo :: Poder
movimientoTurbo nave = nave {ataque= ataque nave +25}

tieFighter = UnaNave "TIE Fighter" 200 100 50 movimientoTurbo

repEmergencia :: Poder
repEmergencia nave = (disminuirAtaque 30) nave {durabilidad= durabilidad nave +50}

xWing = UnaNave "X Wing" 300 150 100 repEmergencia

superTurbo :: Poder

superTurbo  = (reducirDurabilidad 45).movimientoTurbo.movimientoTurbo.movimientoTurbo 

-- ^
reducirDurabilidad :: Number ->Nave -> Nave
reducirDurabilidad n nave = nave {durabilidad = restaPositiva (durabilidad nave) n}

darthVader = UnaNave "Darth Vader" 500 300 200 superTurbo

halconida :: Poder
halconida  = (incrementarEscudo 100).repEmergencia 

incrementarEscudo :: Number -> Nave -> Nave
incrementarEscudo n nave = nave {escudo = escudo nave +n}

halconMilenario = UnaNave "Millennium Falcon" 1000 500 50 halconida

reparar :: Nave -> Nave
reparar nave = nave {escudo = 300}

atacaYrepara :: Poder
atacaYrepara = (disminuirAtaque 50).reparar

esclavoI = UnaNave "Esclavo 1" 700 300 150 atacaYrepara

-- * PUNTO 2
type Flota = [Nave]
flotaImperial = [tieFighter, darthVader]
flotaRebelde = [xWing, halconMilenario]
flotaEspacial = [tieFighter, esclavoI]

durabilidadTotal :: [Nave] -> Number
durabilidadTotal  naves = sum  $ durabilidadFlota naves

durabilidadFlota :: [Nave] -> [Number]
durabilidadFlota  = map accesoDurabilidad 

accesoDurabilidad :: Nave -> Number
accesoDurabilidad  = durabilidad 

-- * PUNTO 3
--Saber cómo queda una nave luego de ser atacada por otra. 

--Cuando ocurre un ataque ambas naves primero activan su 
--poder especial y luego la nave atacada reduce su durabilidad 
--según el daño recibido, que es la diferencia entre el ataque de la
--atacante y el escudo de la atacada.
--(si el escudo es superior al ataque, la nave atacada no es 
--afectada). La durabilidad, el escudo y el ataque nunca pueden ser
--negativos, a lo sumo 0.

ataqueAnave :: Nave -> Nave -> Nave
ataqueAnave naveAt naveDef  
    |escudo naveDef > ataque naveAt = naveDef
    |otherwise = naveDañada naveDef naveAt

activaPoder :: Nave -> Nave
activaPoder nave = poder nave nave

dañoRecibido :: Nave -> Nave -> Number
dañoRecibido naveDef naveAt = (ataque naveAt) - (escudo naveDef) 

naveDañada :: Nave -> Nave -> Nave
naveDañada naveDef naveAt = reducirDurabilidad (dañoRecibido (activaPoder naveDef) (activaPoder naveAt)) naveDef

-- * PUNTO 4
--Averiguar si una nave está fuera de combate, lo que se obtiene 
--cuando su durabilidad llegó a 0. 

fueraDeCombate :: Nave -> Bool
fueraDeCombate nave = durabilidad nave == 0

-- * PUNTO 5
--Averiguar cómo queda una flota enemiga luego de realizar una 
--misión sorpresa con una nave siguiendo una estrategia. 

--Una estrategia es una condición por la cual la nave atacante 
--decide atacar o no una cierta nave de la flota. Por lo tanto la 
--misión sorpresa de una nave hacia una flota significa atacar 
--todas aquellas naves de la flota que la estrategia determine que
--conviene atacar. Algunas estrategias que existen, y que deben 
--estar reflejadas en la solución, son:

type Criterio = (Nave->Bool)

misionSorpresa ::Criterio-> Nave -> Flota -> Flota
misionSorpresa criterio nave flota = map  (ataqueAnave nave)  (estrategiaSegun criterio flota) 

-- * 1. Naves débiles: 
--Son aquellas naves que tienen menos de 200 de escudo.

estrategiaSegun :: Criterio -> Flota -> Flota
estrategiaSegun criterio flota = filter criterio flota

esDebil :: Criterio
esDebil nave = escudo nave < 200

-- * 2. Naves con cierta peligrosidad: 
--Son aquellas naves que tienen un ataque mayor a un valor dado.

--Por ejemplo, en alguna misión se podría utilizar una estrategia 
--de peligrosidad mayor a 300, y en otra una estrategia de 
--peligrosidad mayor a 100.

esPeligrosaSegunGrado :: Number -> Criterio
esPeligrosaSegunGrado n nave =  ataque nave > n

-- * 3. Naves que quedarían fuera de combate: 
--Son aquellas naves de la flota que luego del ataque de la nave 
--atacante quedan fuera de combate. 

quedaFueraDeCombate :: Nave -> Criterio
quedaFueraDeCombate naveAt naveDef = fueraDeCombate $ ataqueAnave naveDef naveAt

-- * 4. Inventar una nueva estrategia
-- * Atacar al lider
--Si en la flota tenemos a Darth Vader, el halcon Milenario, o a Bobba Fett
--Ser{an los objetivos de ataque

esLider :: Criterio
esLider  = evaluaNombreLider

evaluaNombreLider :: Nave -> Bool
evaluaNombreLider nave = nombre nave == "Darth Vader" || nombre nave =="Millennium Falcon" || nombre nave =="Esclavo 1"

-- * PUNTO 6
--Considerando una nave y una flota enemiga en particular, 
--dadas dos estrategias, determinar cuál de ellas es la que 
--minimiza la durabilidad total de la flota atacada y llevar 
--adelante una misión con ella.

ataqueCriterioso :: Criterio -> Criterio-> Nave -> Flota ->Flota
ataqueCriterioso criterio1 criterio2 nave flota 
    |durabilidadTrasMision criterio1 nave flota > durabilidadTrasMision criterio2 nave flota = misionSorpresa criterio2 nave flota
    |otherwise = misionSorpresa criterio1 nave flota 

durabilidadTrasMision :: Criterio -> Nave -> Flota -> Number
durabilidadTrasMision criterio nave flota= durabilidadTotal $ misionSorpresa criterio nave flota

-- * PUNTO 7
-- ?
infinitasNaves :: Flota
infinitasNaves = halconMilenario : infinitasNaves

--No es posible conocer la durabilidad total, pues es imposible
--conocer el resultado de las sumas infinitas de durabilidades
