module Library where
import PdePreludat
import Data.List (sortBy)
import Data.Char (isUpper, isLower, isAscii, isAlpha)

-- *===================================PdPlagio=================================== *--
-- TODO: En Proceso * --

-- * CONCEPTOS GENERALES
--En un sistema de registro de obras literarias,
--existen autores que producen obras y bots que
--detectan eventuales plagios.

--De los autores, ademas de sus obras, se
--conoce también su nombre, y las obras se
--representan con un texto y un año de
--publicación.

-- * AUTORES Y OBRAS

data Autor = UnAutor {
    nombre :: String,
    obras :: [Obra]
} deriving (Show, Eq)

data Obra = UnaObra {
    titulo :: String,
    publicacion :: Number
} deriving (Show, Eq)

a = UnaObra "Había una vez un pato." 1997
b = UnaObra "¡Habia una vez un pato!" 1996
c = UnaObra "Mirtha, Susana y Moria." 2010
d = UnaObra "La semántica funcional del amoblamiento vertebral es riboficiente" 2020
e = UnaObra "La semántica funcional de Mirtha, Susana y Moria." 2022

pepito = UnAutor "Pepito" [a, c]
angela = UnAutor "Angela" [b]
jorge = UnAutor "Jorge" [d]
mateo = UnAutor "Mateo" [e]

-- * PUNTO 2
--Conocer la versión cruda de un texto, que consiste en eliminar los acentos de las letras existentes y
--quitar signos de puntuación y todo carácter que no sea una letra o un número.
--Por ejemplo, la versión cruda de "Había una vez un pato..." es "Habia una vez un pato"

versionCruda :: Obra -> Obra
versionCruda obra = obra {titulo = limpiarTitulo . titulo $ obra}

limpiarTitulo :: String -> String
limpiarTitulo  = arreglaEspeciales.arreglarTildes 

abecedarioEspañol = "QWERTYUIOPASDFGHJKLÑZXCVBNM qwertyuiopasdfghjklñzxcvbnm"

perteneceAbecedario :: Char -> Bool
perteneceAbecedario = flip elem abecedarioEspañol 

arreglaEspeciales :: String -> String
arreglaEspeciales  = filter (perteneceAbecedario) 

arreglarTildes :: String -> String
arreglarTildes  = map reemplazoCaracter 

reemplazoCaracter :: Char -> Char
reemplazoCaracter 'á' = 'a'
reemplazoCaracter 'é' = 'e'
reemplazoCaracter 'í' = 'i'
reemplazoCaracter 'ó' = 'o'
reemplazoCaracter 'ú' = 'u'
reemplazoCaracter 'Á' = 'A'
reemplazoCaracter 'É' = 'E'
reemplazoCaracter 'Í' = 'I'
reemplazoCaracter 'Ó' = 'O'
reemplazoCaracter 'Ú' = 'U'
reemplazoCaracter c   = c  -- Para cualquier otro carácter, devolver el carácter original

-- * PLAGIO
--Se desea detectar si una obra es plagio de la otra. Hay distintas formas de reconocer un plagio, de los
--cuales se conocen las siguientes, pero podrían haber más. En cualquier caso, una obra debe haber
--sido publicada en un año posterior a la obra original para ser considerada un plagio.

type Criterio = (Obra -> Obra -> Bool)

plagioCriterioso ::  Obra -> Obra -> Criterio ->Bool
plagioCriterioso  obra1 obra2 criterio = publicacion obra1 > publicacion obra2 && criterio obra1 obra2 

-- *Copia literal: 
--ocurre cuando la versión cruda de una es igual a la de la otra. Por ejemplo, A es plagio de B.

esLiteral :: Criterio
esLiteral obra1 obra2 = titulo (versionCruda obra1) == titulo (versionCruda $ obra2)

-- *Empieza igual: 
--Los primeros caracteres de una obra son los mismos que otra, y su longitud es
--menor. La cantidad de caracteres a analizar puede ser variable. Por ejemplo, E es plagio de D
--para una cantidad 10, pero no para una cantidad 30.

empiezaIgual :: Number -> Criterio
empiezaIgual n obra1 obra2 = take n (titulo obra1) == take n (titulo obra2)

-- *Le agregaron intro: 
--La obra plagiada empieza a su manera, pero al final incluye totalmente el
--texto de la original. Por ejemplo, E es plagio de C.

agregaronIntro :: Criterio
agregaronIntro obra1 obra2 = length (sacoIntro (titulo obra1) (titulo obra2)) == length (titulo obra2)

sacoIntro :: String -> String -> String
sacoIntro cadenaLarga cadenaCorta = drop (diferenciaIntro cadenaLarga cadenaCorta) cadenaLarga

diferenciaIntro :: String -> String -> Number
diferenciaIntro cadena1 cadena2 = length cadena1 - length cadena2

--las versiones crudas terminan igual
terminaIgual :: Number -> Criterio
terminaIgual n = \obra1 obra2 -> (drop n (titulo obra1)) == titulo obra2

-- * BOTS 
--Existen diferentes bots, y cada uno detecta diversas formas de plagio. Además se conoce su fabricante.

data Bot = UnBot {
    fabricante :: String,
    criteriosDetencion :: [Criterio]
} deriving (Show, Eq)

-- * PUNTO 4
--Modelar dos bots de ejemplo, incluyendo todas las formas de detección existentes hasta ahora.

botEnesimo = UnBot "AMD" [(empiezaIgual 10), (terminaIgual 8)]
botLiteral = UnBot "Ubisoft" [esLiteral, (empiezaIgual 12)]
botDeIntroducciones = UnBot "Tesla" [agregaronIntro, (terminaIgual 5)]

-- * PUNTO 5
-- Un bot detecta si una obra es plagio de otra si verifica alguna de las formas de detección que maneja.

botVsPlagio :: Bot -> Obra -> Obra -> Bool
botVsPlagio bot obra1 obra2 = elem True (hayPlagio (criteriosDetencion bot) obra1 obra2 )

hayPlagio :: [Criterio] -> Obra -> Obra -> [Bool]
hayPlagio criterios obra1 obra2 = map (plagioCriterioso obra1 obra2) criterios

-- *PUNTO 6
--Dado un conjunto de autores y un bot, detectar si es una cadena de plagiadores. Es decir, el segundo
--plagió al primero, el tercero al segundo, y así. Se considera que un autor plagió a otro cuando alguna
--de sus obras es plagio de alguna de las del otro según el bot.

esCadenaDePlagiadores :: [Autor] -> Bot -> Bool
esCadenaDePlagiadores [y] bot = True
esCadenaDePlagiadores (x : y: xs) bot 
    |fuePlagiado bot x y = esCadenaDePlagiadores (y:xs) bot
    |otherwise = False

--Detecta si hay alguna obra de un autor que es plagio de alguna otra obra de otro autor
fuePlagiado :: Bot -> Autor -> Autor  -> Bool
fuePlagiado bot original plagioso  = any (obraPlagiosa bot (obras original)) (obras plagioso)

--Detecta si una obra es plagio en una coleccion
obraPlagiosa :: Bot -> [Obra]  -> Obra -> Bool
obraPlagiosa bot obras obra  = any (botVsPlagio bot obra) obras

-- * PUNTO 7
--Dado un conjunto de autores y un bot, encontrar a los autores que "hicieron plagio pero aprendieron",
--que significa que luego de que el bot detectara que una de sus obras fue plagio de alguna de los otros
--autores, nunca más volvió a plagiar. En definitiva, su plagio detectado fue el primero y el último.

--aprendieronDelPlagio :: [Autor] -> Bot -> [Autor]
--aprendieronDelPlagio 

quienesAprendieron :: Bot -> [Autor] -> [Autor]
quienesAprendieron bot autores = filter (aprendioDelPlagio bot autores) autores

aprendioDelPlagio :: Bot-> [Autor] -> Autor  -> Bool
aprendioDelPlagio bot  autores autor = contadorDePlagios bot autor autores == 1

contadorDePlagios :: Bot -> Autor -> [Autor] -> Number
contadorDePlagios _ _ [] = 0
contadorDePlagios bot autor (x:xs)
    |fuePlagiado bot x autor = 1 + contadorDePlagios bot autor xs 
    |otherwise = contadorDePlagios bot autor xs

-- * PUNTO 8
--Codificar una obra infinita.
obraInfinita = UnaObra (repeat 'a') 2034

--Qué sucede si se desea verificar si esa obra es plagio de otra con cada una de las formas
--existentes? Justificar conceptualmente en cada caso.

-- ^ copia Literal = dara respuesta siempre que se pase la obra finita como segundo parametro

-- ^ empieza igual = dara respuesta siempre

-- ^ agregoIntro = imposible saberlo
