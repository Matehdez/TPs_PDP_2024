module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================PdPop=================================== *--
-- * APROBADO * --

data Cancion = UnaCancion {
    nombre :: String,
    duracion :: Number,
    instrumentos :: [String]
} deriving (Show, Eq)

type Repertorio = [Cancion]

data Banda = UnaBanda {
    nombreBanda :: String,
    repertorio :: Repertorio
} deriving (Show, Eq)

patternMaching = UnaCancion "Pattern Matching" 4 ["Guitarra", "Bajo", "Bateria"]
seisDieciocho = UnaCancion "Seis Dieciocho" 3 ["Teclado", "Guitarra"]
laVidaHaskell = UnaCancion "La vida en Haskell" 5 []

pdPop = UnaBanda "PdPop" [patternMaching, seisDieciocho, laVidaHaskell]

-- Punto 1 --------------------------------------------------------------------------
aceptacion :: Cancion -> Number
aceptacion cancion 
    | head (nombre cancion) == 'M' = 500
    | even $ duracion cancion = (*10).length $ nombre cancion 
    | instrumentos cancion == [] = 10
    | otherwise = 0

-- Punto 2 --------------------------------------------------------------------------
mamahuevo = UnaCancion "Mamahuevo" 7 []
ricarditoPitoRico = UnaCancion "Ricardito Pito Rico" 2 ["Guitarra", "Bajo", "Bateria"]

-- Punto 3 --------------------------------------------------------------------------

ordenAlfabetico :: Cancion -> Cancion -> Cancion
ordenAlfabetico cancion1 cancion2 
    | nombre cancion1 > nombre cancion2 = cancion1
    | otherwise = cancion2

-- Punto 4 --------------------------------------------------------------------------
esAcapella :: Cancion -> Bool
esAcapella cancion = instrumentos cancion == []

-- Punto 5 --------------------------------------------------------------------------
esAceptada ::  Cancion -> Bool
esAceptada  = (>60) . aceptacion 

-- Punto 6 --------------------------------------------------------------------------
type Instrumento = String

sonNecesarios :: Instrumento -> Cancion -> Bool
sonNecesarios instrumento cancion = elem instrumento (instrumentos cancion)

-- Punto 7 --------------------------------------------------------------------------
tocarCancion :: Cancion -> Cancion
tocarCancion cancion 
    |esAceptada cancion = cancion
    |otherwise = cancion {duracion = duracion cancion /2}


