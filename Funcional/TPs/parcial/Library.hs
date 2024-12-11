module Library where
import PdePreludat

-- *===================================ParcialPdP=================================== *--

-- * CONCEPTOS GENERALES
-- Se deben analizar los conflictos entre los magos

-- decidi estructurar a los magos de esta manera ya que es necesario acceder a sus atributos para el desarrollo
--del examen
data Mago = UnMago {
    nombre :: String,
    edad :: Number ,
    salud :: Number,
    hechizos :: [Hechizo]
} deriving (Show, Eq)

--Decidi estructurar un hechizo de esta manera, ya que los hechizos transforman un mago entero y lo devuelven distinto,
--con ciertos valores modificados segun sea el hechizo a aplicar
type Hechizo = (Mago -> Mago)

pepe :: Mago
pepe = UnMago "Pepe" 40 100 [(curar 10), lanzarRayo]
harry :: Mago
harry = UnMago "Harry" 21 70 [(curar 30), confundir]
mario :: Mago
mario = UnMago "Mario" 78 3 [(amnesia 1), confundir, lanzarRayo, (curar 70)]
mercy :: Mago
mercy = UnMago "Mercy" 50 100 [(curar 50)]
zeus :: Mago
zeus = UnMago "Zeus" 100 200 (replicate 11 lanzarRayo)
rincenwind :: Mago
rincenwind = UnMago "Rincenwind" 300 100 []

-- * PUNTO 1
--Curar
curar :: Number -> Hechizo
curar n mago = mago {salud = (+n).salud $ mago} 

--Lanzar Rayo
--le hace danio al mago
--Si la salud del mago es mayor a 10, le hace 10 de año
--sino, le quita la mitad de su vida

lanzarRayo :: Hechizo
lanzarRayo mago 
    |salud mago > 10 = mago {salud= salud  mago -10}
    |otherwise = mago {salud = (-) (salud mago) (salud mago /2)}

--Amnesia
--olvida los primeros n hechizos que conozca

amnesia :: Number -> Hechizo
amnesia n mago = mago {hechizos = drop n (hechizos mago)}

--Confundir
--El mago objetivo se ataca a si mismo con su primer hechizo

confundir :: Hechizo
confundir mago = head (hechizos mago) mago

-- * PUNTO 2
-- poder
--El poder de un mago es su salud sumada al resultado de multiplicar su edad por la cant de hechizos que conoce

poder :: Mago -> Number
poder mago = (salud mago) + ((*) (edad mago) (cantHechizosMago mago))
    where cantHechizosMago  = length . hechizos

--danio
--Retorna la cantidad de vida que un mago pierde si se lanza un hechizo
danio :: Mago -> Hechizo -> Number 
-- danio _ curar = 0 --En el examen se me dijo que el hechizo curar no se toma en consideracion
danio mago hechizo = (-) (salud mago) (salud . hechizo $ mago)


--Dif de poder
--Diferencia de poder entre dos magos

diferenciaDePoder :: Mago -> Mago -> Number
diferenciaDePoder mago1 mago2 = diferenciaPositiva (poder mago1) (poder mago2)

diferenciaPositiva :: Number -> Number -> Number
diferenciaPositiva n m = abs (n-m)

-- * PUNTO 3

data Academia = UnaAcademia {
    magos :: [Mago],
    examenDeIngreso :: Examen
} deriving (Show, Eq)

type Examen = (Mago -> Bool)

jujuy :: Academia
jujuy = UnaAcademia [pepe, mario, zeus] historia

historia :: Examen
historia mago = (30>) . edad $ mago

matematica :: Examen
matematica mago = (=='m') . head . nombre $ mago

-- type Consulta = (Ord a) => (Academia -> a)
-- quise crear un type consulta para poder asignarle a cada consulta este tipo de dato, pero no me compilaba :(

--consultas
--filtrar x nombre magos y que no tenga hechizos

--Buscar a Rincenwind, mago que no tiene hechizos

-- *
estaRincenwind :: Academia -> Bool
estaRincenwind academia = (==1) . length $ noTienenHechizo (filtrarPorNombre "Rincenwind" (magos academia))

noTienenHechizo :: [Mago] -> [Mago]
noTienenHechizo  = filter noTieneHechizosMago 

noTieneHechizosMago :: Mago -> Bool
noTieneHechizosMago  =  null . hechizos  

filtrarPorNombre :: String -> [Mago] -> [Mago]
filtrarPorNombre nombreBusca  = filter (nombreIgual nombreBusca) 

nombreIgual :: String -> Mago -> Bool
nombreIgual nombreBusca  =  (==nombreBusca) . nombre 

-- Si todos los magos viejos son noños
--Un mago es viejo cuando tiene mas de 50 años
--Es ñoño si tiene mas hechizos que salud

-- *
sonViejosyEstudiantes ::  Academia -> Bool
sonViejosyEstudiantes  academia = all (esÑoño) (filtrarXCriterio esViejo (magos academia))

-- ^ se vuelve a usar
filtrarXCriterio :: (Mago -> Bool) -> [Mago] -> [Mago]
filtrarXCriterio = filter 

esÑoño :: Mago -> Bool
esÑoño mago = (> (salud $ mago)) . length . hechizos $ mago

esViejo :: Mago -> Bool
esViejo  = (>50).edad

--Cantidad de magos que no pasarian el examen de ingreso si lo volvieran a rendir

-- *
cantQueApruebaExamen :: Academia -> Number
cantQueApruebaExamen academia = length . (apruebanExamen (examenDeIngreso academia)) . magos $ academia

apruebanExamen :: Examen -> [Mago] -> [Mago]
apruebanExamen  = filtrarXCriterio 

--Sumatoria de edad de magos que saaben mas de 10 hechizos
-- *
sumEdad10Hechizos :: Academia -> Number
sumEdad10Hechizos academia = length (filtrarXCriterio tieneMasde10Hechizos (magos academia))

tieneMasde10Hechizos :: Mago -> Bool
tieneMasde10Hechizos  = (>10) . length . hechizos 

sumatoriaDeEdades :: [Number] -> Number
sumatoriaDeEdades  = sum 

edadesMagos :: [Mago] -> [Number]
edadesMagos  = map edad 

-- * EXPRESION CRITERIOSA
consultaXCriterio :: Ord a => (Academia -> a) -> Academia -> a 
consultaXCriterio criterio  = criterio 

-- *PUNTO 4

-- Ord a1 => (t -> a2 -> a1) -> t -> [a2] -> a2
--Entonces, dado un criterio, un elemento y una lista de otros elementos, retorna un valor de la lista
maximoSegun criterio valor comparables = foldl1 (mayorSegun $ criterio valor) comparables

mayorSegun evaluador comparable1 comparable2 
    |evaluador comparable1 >= evaluador comparable2 = comparable1
    |otherwise = comparable2

--mejorHechizoContra
--Dados dos magos, retorna el hechizo del segundo que le haga mas danio al primero
mejorHechizoContra :: Mago -> Mago -> Hechizo
mejorHechizoContra magoDef magoAt = maximoSegun danio magoDef (hechizos magoAt)

--mejor oponente
--Dado un mago y una academia, retorna el mago de la acdemia que tenga la mayor diferencia de poder con el mago recibido
mejorOponente :: Mago -> Academia -> Mago
mejorOponente magoAcomparar academia = maximoSegun diferenciaDePoder magoAcomparar (magos academia)

-- * PUNTO 5
-- no puede ganarle
-- Decimos que el segundo mago no puede ganarle al primero si, luego de hechizarlo con todos los hechizos que conoce,
--la salud del primero sigue siendo la misma

noLePuedeGanar :: Mago -> Mago -> Bool
noLePuedeGanar magoDef magoAt = salud (aplanarHechizos magoAt magoDef) == salud magoDef

aplanarHechizos :: Mago -> Mago -> Mago
aplanarHechizos magoAt magoDef = foldl loHechiza magoDef (hechizos magoAt)

loHechiza :: Mago -> Hechizo  -> Mago
loHechiza magoDef hechizo  = hechizo magoDef




 
