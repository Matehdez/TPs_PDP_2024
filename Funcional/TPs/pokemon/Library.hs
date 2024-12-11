module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================Pokemon=================================== *--
-- * APROBADO * --

-- * CONCEPTOS GENERALES
--Existen los pokemones, que tienen un nombre (por ejemplo Charmander, Gyarados, Tauros, Carpinchos) 
--y un tipo (planta, agua o fuego, por ahora) y se sabe que los pokemones pueden ganar contra otros según su tipo. 
--Planta le gana a agua, agua a fuego y fuego a planta.

data Pokemon = UnPokemon {
    nombre :: String,
    tipo :: String
 } deriving (Show, Eq)

charmander = UnPokemon "Charmander" "Fuego"
flareon = UnPokemon "Flareon" "Fuego"
squirtle = UnPokemon "Squirtle" "Agua"
oddish = UnPokemon "Oddish" "Planta"
gyarados = UnPokemon "Gyarados" "Agua"
carpinchos = UnPokemon "Carpinchos" "Agua"


-- * PUNTO 1
--Dado el código inicial, se quiere conocer a qué pokemones les puede ganar un pokemon dado 
--(es decir, a cuáles aventaja por su tipo). Pensar: ¿Qué cosas necesito recibir? ¿y qué devolver?

lesGana :: Pokemon -> [Pokemon] -> [Pokemon]
lesGana pokemon = filter (leGana pokemon) 

leGana :: Pokemon -> Pokemon -> Bool
leGana pokemon1 pokemon2 = tipo pokemon1 == "Planta" && tipo pokemon2 == "Agua" ||tipo pokemon1 =="Agua" && tipo pokemon2 == "Fuego" ||tipo pokemon1 == "Fuego" && tipo pokemon2 == "Planta"

-- ^ data TipoPokemon = Planta | Agua | Fuego deriving (Show, Eq)

-- ^ tieneVentajaContra :: TipoPokemon -> TipoPokemon -> Bool
-- ^ tieneVentajaContra Planta Agua = True
-- ^ tieneVentajaContra Agua Fuego = True
-- ^ tieneVentajaContra Fuego Planta = True
-- ^ tieneVentajaContra _ _ = False

-- * PUNTO 2
--Teniendo un pokemon, se quiere conocer a cuántos puede ganarle de una lista de pokemones.

cuantosLesGana :: Pokemon -> [Pokemon] -> Number
cuantosLesGana pokemon  = length . lesGana pokemon 

-- * PUNTO 3
--Conocer el pokemon que a más pokemones les puede ganar de una lista.
pokemonGanador :: [Pokemon] -> Pokemon
pokemonGanador pokemones = foldl1 (quienGanaMas pokemones) pokemones

-- ^ En un fold, es crucial primero que se reciba la lista de elementos, asi no tenemos errores de tipo 


quienGanaMas :: [Pokemon]-> Pokemon -> Pokemon  -> Pokemon
quienGanaMas pokemones pokemon1 pokemon2  
    |cuantosLesGana pokemon1 pokemones > cuantosLesGana pokemon2 pokemones = pokemon1
    |otherwise = pokemon2

-- * PUNTO 4
--Se sabe que un destino a donde puede pelear un pokemon puede ser un gimnasio o una liga. 
--Los gimnasios son consecutivos (se sabe cuál es el siguiente de cada uno) y al final de un camino siempre hay una liga.
--Por ahora sólo nos interesan los pokemones contrincantes que existen en una liga.
--Dada la siguiente definición
data Destino = UnGimnasio { nombreGym:: String, siguiente:: Destino }
              | UnaLiga { contrincantes:: [Pokemon] } deriving (Show, Eq)
--Se desea saber si un pokemon está al horno en un destino. En un gimnasio, un pokemon siempre está al horno, y en una liga, 
--está al horno cuando todos los contrincantes pueden ganarle. 

estaAlHorno :: Pokemon -> Destino-> Bool
estaAlHorno _ (UnGimnasio _ _ )= True
estaAlHorno pokemon (UnaLiga pokemones) = not (any (leGana pokemon) pokemones)

gymRoca :: Destino
gymRoca = UnGimnasio "Gimnasio Roca" gymAgua
gymAgua :: Destino
gymAgua = UnGimnasio "Gimnasio Agua" gymElectrico
gymElectrico :: Destino
gymElectrico = UnGimnasio "Gimnasio Electrico" ligaKanto
ligaKanto :: Destino
ligaKanto = UnaLiga [flareon, gyarados, charmander]
gymFuego :: Destino
gymFuego = UnGimnasio "Gimnasio Fuego" gymPlanta
gymPlanta :: Destino
gymPlanta = UnGimnasio "Gimnasio Planta" ligaGali
ligaGali :: Destino
ligaGali = UnaLiga [carpinchos, gyarados]

-- * PUNTO 5
--Saber si puedo viajar de un destino al otro. 
--Consideraciones a tener en cuenta:
--Desde una Liga no puedo viajar a otro destino.
--Desde unGimnasio puedo viajar a miDestino si miDestino se encuentra entre los siguientes destinos de unGimnasio. 
--Es decir, miDestino debe estar en el camino a seguir de unGimnasio.

--Por ejemplo: tenemos el gymRoca, al que le sigue gymAgua, al que le sigue gymElectrico 
--y termina en ligaKanto. Y después tenemos el gymFuego al que le sigue el gymPlanta y termina en ligaGali. 

puedeViajar:: Destino -> Destino -> Bool
puedeViajar (UnaLiga contrincantes) destino = (UnaLiga contrincantes) == destino
puedeViajar origen destino = origen == destino || puedeViajar (siguiente origen) destino


