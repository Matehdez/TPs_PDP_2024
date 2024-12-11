module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================Star Wars=================================== *--
-- TODO: En Proceso * --

-- * CONCEPTOS GENERALES
--programa para evaluar el resultado de los peleadores

data Peleador = UnPeleador {
    nombre :: String,
    vida ::Number,
    resistencia :: Number,
    ataquesConocidos :: [Ataque]
} deriving (Show, Eq)


mumuki = UnPeleador "Mumuki" 100 50 [(golpe 8), (patadaEn "Pecho")]

-- * PUNTO 1
--operaciones en peleadores:

estaMuerto :: Peleador -> Bool
estaMuerto peleador = vida peleador == 0

esHabil :: Peleador -> Bool
esHabil peleador = (conocenAtaques 10 peleador) && (resistenciaMayorAn 15 peleador)

perderVida :: Number -> Peleador -> Peleador
perderVida vidaPerdida peleador = peleador  {vida = restaNegativa (vida peleador) vidaPerdida} 

restaNegativa :: Number -> Number -> Number
restaNegativa n m = max 0 (n-m)

conocenAtaques :: Number -> Peleador -> Bool
conocenAtaques n peleador = length(ataquesConocidos peleador)  == n

resistenciaMayorAn :: Number -> Peleador -> Bool
resistenciaMayorAn n peleador = resistencia peleador > n

-- * PUNTO 2
--Implementar ataques

-- * Golpe:
--reduce vida de oponente = intensidad de golpe / resistencia de op

type Ataque = (Peleador -> Peleador) 

golpe :: Number -> Ataque
golpe intensidad defensor = defensor {vida = intensidad / resistencia defensor }

-- * Toque de la muerte
--El oponente muerte

toqueDeLaMuerte :: Ataque
toqueDeLaMuerte defensor = defensor {vida = 0}

-- * Patada
--La patada causa diferente daño dependiendo de la zona de impacto

patadaEn :: String -> Ataque
-- TODO: reanima a muerto
patadaEn "Pecho" defensor = (perderVida 10) defensor
patadaEn "Cara" defensor = defensor {vida = (vida defensor /2)}
patadaEn "Nuca" defensor = defensor {ataquesConocidos = olvidarPrimerAtaque $ ataquesConocidos defensor}
patadaEn _ defensor = defensor

olvidarPrimerAtaque :: [Ataque] -> [Ataque]
olvidarPrimerAtaque (ataque : ataques) = ataques

-- * TRIPLE ataque
-- Realiza un movimiento en particular, pero 3 veces

tripleAtaque :: Ataque -> Ataque
tripleAtaque ataque  = ataque.ataque.ataque

-- * PUNTO 3

burceLee = UnPeleador "Bruce Lee" 200 25 [toqueDeLaMuerte, (golpe 500), (patadaEn "Nuca"), (tripleAtaque (patadaEn "Cara")), ataqueEspecial]

--Reduce la resistencia del oponente a 1
ataqueEspecial :: Ataque
ataqueEspecial defensor = defensor {resistencia = 1}

-- * PUNTO 4
--Recibe una funcion que transforma de a -> b
--recibe un c
-- Recibe una lista de funciones que va de c->b
--Devuelve una funcion que va de c->b

--lo que hace es, itera sobre una lista, aplicandole una compocision
--con g al parametro p, y determina si ese valor es mayor a la
--segunda funcion de la lista aplicada con la funcion 
-- lo que termina haciendo es quedarse con la funcion que aplicada a p,
-- sea el menor posible (de toda la lista)

menorValorSegun :: Ord a => (b->a) -> c -> [c->b] -> (c->b)
menorValorSegun _ _ [funcionAcomparar] =funcionAcomparar
menorValorSegun criterio valor (x:y:xs)
    |(criterio.x) valor < (criterio.y) valor= menorValorSegun criterio valor (x:xs)
    |otherwise = menorValorSegun criterio valor (y:xs)

-- ??
mejorAtaque :: Peleador -> Ataque
mejorAtaque peleador = menorValorSegun vida peleador (ataquesConocidos peleador)

-- * PUNTO 5
--Dado un peleador y un conj. de enemigos

-- * Ataques terribles
--Un ataque es terrible cuando, luego de realziarlo en todos,
--siguen vivos menos de la mitad

esAtaqueTerrible :: Ataque -> [Peleador] -> Bool
esAtaqueTerrible ataque enemigos = length (ataqueAenemigos ataque enemigos) < ((/2).length) enemigos

ataqueAenemigos :: Ataque -> [Peleador] -> [Peleador]
ataqueAenemigos ataque enemigos = map ataque enemigos

-- * Ataques Peligrosos
esPeligroso :: Peleador -> [Peleador] -> Bool
esPeligroso peleador enemigos =  esHabil peleador && any (todosSonMortales (ataquesConocidos peleador) ) enemigos

esAtaqueMortal :: Peleador-> Ataque -> Bool
esAtaqueMortal enemigo ataque  = estaMuerto $ ataque enemigo

todosSonMortales :: [Ataque] -> Peleador -> Bool
todosSonMortales ataques enemigo = all ( esAtaqueMortal enemigo) ataques

-- * Vida peleador

atacanNVeces :: Number -> Peleador -> [Peleador] -> Peleador
atacanNVeces n peleador enemigos = map (loAtacan peleador ataque) ((take n) enemigos)

loAtacan :: Peleador ->Ataque  -> Peleador
loAtacan  defensor ataque = ataque defensor








