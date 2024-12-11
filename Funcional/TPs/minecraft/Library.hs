module Library where
import PdePreludat
import Data.List (sortBy, intersect)

-- *===================================Minecraft=================================== *--
-- ^REVISAR * --

-- * CONCEPTOS GENERALES
--En este videojuego, existen personajes cuyo objetivo es minar materiales y construir nuevos objetos.
--Los personajes tienen un nombre, un puntaje y un inventario con todos los materiales que poseen. 
--De un mismo material se pueden tener varias unidades.
--Para ello, se define el siguiente tipo de dato

type Material = String

data Personaje = UnPersonaje {
nombre:: String,
puntaje:: Number,
inventario:: [Material]
} deriving Show

steve = UnPersonaje "Steve" 750 ["Madera", "Madera", "Fosforo", "Pollo", "Lana", "Tintura", "Fosforo"]
herobrine = UnPersonaje "Herobrine" 1000 ["Sueter", "Fogata", "Pollo", "Pollo"]

-- * CRAFT
--Craftear consiste en construir objetos a partir de otros objetos. Para ello se cuenta con recetas que consisten en una 
--lista de materiales que se requieren para craftear un nuevo objeto. En ninguna receta hace falta más de una unidad del 
--mismo material. La receta también especifica el tiempo que tarda en construirse. Todo material puede ser componente de 
--una receta y todo objeto resultante de una receta también es un material y puede ser parte en la receta de otro.

data Receta = UnaReceta {
    objeto :: Material,
    listaCrafteo :: [Material],
    tiempoCrafteo :: Number
} deriving (Show, Eq)

fogata = UnaReceta "Fogata" ["Madera", "Fosforo"] 10
polloAsado = UnaReceta "Pollo Asado" ["Fogata", "Pollo"] 300
sueter = UnaReceta "Sueter" ["Lana", "Agujas", "Tintura"] 600

-- * PUNTO 1
--Hacer las funciones necesarias para que un jugador craftee un nuevo objeto
--El jugador debe quedar sin los materiales usados para craftear

-- ^ Pude hacer todo el punto 1, salvo la funcion recursiva en donde,
-- ^ Si bien sabia que hacer, no sabia como implementarlo

craftear :: Personaje -> Receta -> Personaje
craftear personaje receta = (quitarMateriales receta) $ sumoPuntosYagregoObjeto personaje receta

sumoPuntosYagregoObjeto :: Personaje -> Receta -> Personaje
sumoPuntosYagregoObjeto personaje receta
    |puedeCraftear personaje receta = personaje {puntaje= puntaje personaje + (10 * tiempoCrafteo receta), inventario =concat [inventario personaje , [objeto receta]] }
    |otherwise = personaje {puntaje = puntaje personaje -100}

puedeCraftear :: Personaje -> Receta -> Bool
puedeCraftear personaje receta = length (materialesDeReceta receta (inventario personaje))  == length(listaCrafteo receta)  

materialesDeReceta :: Receta-> [Material] -> [Material]
materialesDeReceta receta   = intersect (listaCrafteo receta) 

-- ?
quitarMateriales :: Receta -> Personaje-> Personaje
quitarMateriales  receta personaje= personaje {inventario = foldr quitarUnaVez (inventario personaje) (listaCrafteo receta)}

quitarUnaVez :: Material -> [Material] -> [Material]
quitarUnaVez material (x:xs)
    |material == x = xs
    |otherwise = x : quitarUnaVez material xs

-- * PUNTO 2
--Dado un personaje y una lista de recetas: 
recetaComida = [polloAsado, fogata]
recetaChill = [polloAsado, sueter]
recetaInvierno = [fogata, sueter]

filtroDobles :: Personaje -> [Receta] -> [Receta]
filtroDobles personaje recetas  = filter (duplicaPuntos personaje) recetas

duplicaPuntos :: Personaje -> Receta -> Bool
duplicaPuntos personaje receta  = puntaje (craftear personaje receta) >= puntaje personaje *2

crafteoMasivo :: Personaje -> [Receta] -> Personaje
crafteoMasivo  = foldl craftear

masPuntosAlReves :: Personaje -> [Receta] ->Bool
masPuntosAlReves personaje recetas = puntaje (crafteoMasivo personaje (reverse recetas)) > puntaje (crafteoMasivo personaje recetas)

-- * MINE
--Biomas -> Materiales
--Si se quiere minar, se debe tener la herramienta necesaria segun el bioma

data Bioma = UnBioma {
    alias :: String,
    materiales :: [Material],
    requisito :: Material

} deriving (Show, Eq)

artico = UnBioma "Artico" ["Hielo", "Iglu", "Lobo"] "Sueter"

--Cuando un personaje mina, con la herramienta necesaria, suma a su inventario y gana 50 puntos

-- * PUNTO 1
--Hacer una función minar, que dada una herramienta, un personaje y un bioma, permita obtener cómo queda el personaje.

type Herramienta = [Material] -> Material

hacha:: Herramienta
hacha = last

espada :: Herramienta
espada = head

pico :: Number -> Herramienta
pico n materiales = (!!) materiales n

minar ::Herramienta -> Personaje -> Bioma -> Personaje
minar herramienta personaje bioma 
    |tieneRequisito personaje bioma = agregoObjetoYSumoBioma personaje bioma herramienta
    |otherwise = personaje 

agregoObjetoYSumoBioma :: Personaje -> Bioma -> Herramienta -> Personaje
agregoObjetoYSumoBioma personaje bioma herramienta= personaje {inventario =concat [inventario personaje , [herramienta (materiales bioma)]], puntaje = puntaje personaje + 50}


tieneRequisito :: Personaje -> Bioma -> Bool
tieneRequisito personaje bioma = elem (requisito bioma) (inventario personaje) 

-- * PUNTO 2
--Definir las herramientas mencionadas y agregar dos nuevas. Mostrar ejemplos de uso. Hacerlo de manera que agregar en 
--el futuro otras herramientas no implique modificar la función minar.

--Utilizando la función composición, usar una que permita obtener un material del medio del conjunto de materiales.
pala :: Herramienta
pala materiales = (!!) materiales 1 

--Utilizando una expresión lambda, inventar una nueva herramienta, diferente a las anteriores
tijera ::Number -> Herramienta
tijera = \n -> materiales !! n








