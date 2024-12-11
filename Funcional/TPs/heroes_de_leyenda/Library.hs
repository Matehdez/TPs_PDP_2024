module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================Heroes de Leyenda=================================== *--
-- *APROBAD * --

-- * ENUNCIADO
{--Bien hecho, camaradas! ¡Otra campaña exitosa dedicada al
--Olimpo! Hemos de celebrar con el botín obtenido esta noche,
--¡porque no sabemos si el día de mañana podremos disfrutarlo!
Nos remontamos a tiempos remotos, una época antigua, donde
la línea entre hombre y Dios estaba mucho más desdibujada.
Así es: nos encontramos en la Grecia antigua, los héroes y la
guerra son nuestra moneda corriente, y la sangre y los gritos
comparten mesa con nosotros.
Todo héroe tiene un nombre, pero por lo general nos referimos
a ellos por su epíteto . Sin embargo, hay muchos héroes que
no conocemos. Esto se debe a que todo héroe tiene un
reconocimiento y aquellos con uno bajo no han logrado pasar a
la historia, aunque agradecemos eternamente su coraje ante la
adversidad. Para ayudarse en sus pesares del día a día, los
héroes llevan consigo diversos artefactos, que tienen una
rareza, indicativos de lo valiosos que son.--}

-- * PUNTO 1

data Heroe = UnHeroe {
    epiteto :: String, 
    reconocimiento :: Number ,
    artefactos :: [Artefacto],
    listaTareas :: [Tarea]
} deriving (Show, Eq)

type Tarea = (Heroe -> Heroe)

data Artefacto = UnArtefacto {
    nombre :: String,
    rareza :: Number
}deriving (Show, Eq)

-- * PUNTO 2
--2) Hacer que un héroe pase a la historia. Esto varía según el índice de reconocimiento que tenga el
--héroe a la hora de su muerte:
pasoAlaHistoria :: Heroe -> Heroe
pasoAlaHistoria heroe 
    |reconocimiento heroe > 1000 = heroe {epiteto = "El mítico"}
    |reconocimiento heroe >= 500 = heroe {epiteto = "El magnífico", artefactos = agregarArtefacto lanzaDelOlimpo (artefactos heroe)}
    |reconocimiento heroe > 100 = heroe {epiteto = "Hoplita", artefactos = agregarArtefacto xiphos (artefactos heroe)}
    |otherwise = heroe

lanzaDelOlimpo = UnArtefacto "Lanza del Olimpo" 100

agregarArtefacto :: Artefacto -> [Artefacto] -> [Artefacto]
agregarArtefacto artefacto  = (++) [artefacto]

xiphos = UnArtefacto "Xiphos" 50

-- * PUNTO 3
-- Encontrar un artefacto: el héroe gana tanto reconocimiento como rareza del artefacto, además de 
--guardarlo entre los que lleva.

encontrarArtefacto :: Artefacto -> Tarea
encontrarArtefacto artefacto heroe = heroe {reconocimiento = operacionesNumeros (+) (rareza artefacto) (reconocimiento heroe), artefactos = agregarArtefacto artefacto (artefactos heroe)}

operacionesNumeros :: (Number->Number->Number) -> Number -> Number -> Number
operacionesNumeros operacion n m = operacion n m

--Escalar el Olimpo: esta ardua tarea recompensa a quien la realice otorgándole 500 unidades de
--reconocimiento y triplica la rareza de todos sus artefactos, pero desecha todos aquellos que luego de
--triplicar su rareza no tengan un mínimo de 1000 unidades. Además, obtiene "El relámpago de Zeus"
--(un artefacto de 500 unidades de rareza).

-- ? Preguntar por que no puedo usar composicion
escalarOlimpo :: Tarea
escalarOlimpo heroe = heroe {reconocimiento = operacionesNumeros (+)  500 (reconocimiento heroe), artefactos = (agregarArtefacto relampagoZeus) . descartarArtefactos . triplicarRarezaArtefactos . artefactos $ heroe}

triplicarRarezaArtefactos :: [Artefacto] -> [Artefacto]
triplicarRarezaArtefactos artefactos = map rarezaTriplicada  artefactos

rarezaTriplicada :: Artefacto -> Artefacto
rarezaTriplicada  artefacto = artefacto {rareza = operacionesNumeros (*) 3 (rareza artefacto)}

descartarArtefactos :: [Artefacto] -> [Artefacto]
descartarArtefactos artefactos = filter (rarezaMayorA 1000) artefactos  

rarezaMayorA :: Number -> Artefacto -> Bool
rarezaMayorA n artefacto = (rareza artefacto) >= n

relampagoZeus = UnArtefacto "El relámpago de Zeus" 500

--Ayudar a cruzar la calle: incluso en la antigua Grecia los adultos mayores necesitan ayuda para ello.
--Los héroes que realicen esta tarea obtiene el epíteto "Groso", donde la última 'o' se repite tantas veces
--como cuadras haya ayudado a cruzar. Por ejemplo, ayudar a cruzar una cuadra es simplemente
--"Groso", pero ayudar a cruzar 5 cuadras es "Grosooooo".

ayudarAcruzar :: Number -> Tarea
ayudarAcruzar cuadras heroe = heroe {epiteto = (grosoSegun cuadras)}

grosoSegun :: Number -> String
grosoSegun n =  (++) "Gros" (replicate n 'o')

--Matar una bestia: Cada bestia tiene una debilidad (por ejemplo: que el héroe tenga cierto artefacto, o
--que su reconocimiento sea al menos de tanto). Si el héroe puede aprovechar esta debilidad, entonces
--obtiene el epíteto de "El asesino de <la bestia>". Caso contrario, huye despavorido, perdiendo su
--primer artefacto. Además, tal cobardía es recompensada con el epíteto "El cobarde".

data Bestia = UnaBestia {
    alias :: String,
    debilidad :: Debilidad
} deriving (Show, Eq)

type Debilidad = (Heroe -> Bool)

matarBestia :: Bestia -> Tarea 
matarBestia bestia heroe 
    |aprovechaDebilidad (debilidad bestia) heroe = heroe {epiteto = asesinoDeBestia (alias bestia)}
    |otherwise = pierdePrimerArtefactoYesCobarde heroe

pierdePrimerArtefactoYesCobarde :: Heroe -> Heroe
pierdePrimerArtefactoYesCobarde heroe = heroe {epiteto = "El cobarde" , artefactos = tail . artefactos $ heroe}

asesinoDeBestia :: String -> String
asesinoDeBestia nombreBestia = "Asesino de" ++ nombreBestia

aprovechaDebilidad :: Debilidad -> Heroe -> Bool
aprovechaDebilidad debilidad heroe = debilidad heroe

-- * PUNTO 4
--Modelar a Heracles , cuyo epíteto es "Guardián del Olimpo" y tiene un reconocimiento de 700. Lleva
--una pistola de 1000 unidades de rareza (es un fierro en la antigua Grecia, obviamente que es raro) y el
--relámpago de Zeus. Este Heracles es el Heracles antes de realizar sus doce tareas, hasta ahora
--sabemos que solo hizo una tarea...

heracles = UnHeroe "Guardián del Olimpo" 700 [fierroGriego, relampagoZeus] [(matarBestia leonDeNemea)]

fierroGriego = UnArtefacto "Fierro de Heracles" 1000

-- * PUNTO 5
--Modelar la tarea "matar al león de Nemea", que es una bestia cuya debilidad es que el epíteto del
--héroe sea de 20 caracteres o más. Esta es la tarea que realizó Heracles.

leonDeNemea :: Bestia
leonDeNemea  =  UnaBestia "Leon de Nemea" debilidadNemea

debilidadNemea :: Debilidad
debilidadNemea = (>=20).length.epiteto

-- *PUNTO 6
--Hacer que un héroe haga una tarea. Esto nos devuelve un nuevo héroe con todos los cambios que
--conlleva realizar una tarea.

realizarTarea :: Heroe-> Tarea -> Heroe
realizarTarea heroe tarea  = tarea heroe


-- * PUNTO 7
--Hacer que dos héroes presuman sus logros ante el otro. Como resultado, queremos conocer la tupla
--que en primer lugar al ganador de la contienda, y en segundo al perdedor. Cuando dos héroes
--presumen, comparan de la siguiente manera:

type Presumidos = (Heroe, Heroe)

ganadorPresumido :: Presumidos -> Heroe
ganadorPresumido (ganador, _ ) = ganador

perdedorPresumido :: Presumidos -> Heroe
perdedorPresumido ( _ , perdedor) = perdedor

sePresumen :: (Heroe, Heroe) -> Presumidos
sePresumen (heroe1 ,heroe2)
    |reconocimiento heroe1 > reconocimiento heroe2 = (heroe1, heroe2)
    |reconocimiento heroe1 < reconocimiento heroe2 = (heroe2, heroe1)
    |rarezaArtefactos (artefactos heroe1) > rarezaArtefactos (artefactos heroe2) = (heroe1, heroe2) 
    |rarezaArtefactos (artefactos heroe1) <  rarezaArtefactos (artefactos heroe2) = (heroe2, heroe1) 
    |otherwise = sePresumen .realizanSusTareas $ (heroe1, heroe2)

--a) Si un héroe tiene más reconocimiento que el otro, entonces es el ganador.

--b) Si tienen el mismo reconocimiento, pero la sumatoria de las rarezas de los artefactos de un
--héroe es mayor al otro, entonces es el ganador.

rarezaArtefactos :: [Artefacto] -> Number
rarezaArtefactos artefactos = sum (map rareza artefactos)

--c) Caso contrario, ambos realizan todas las tareas del otro, y vuelven a hacer la comparación
--desde el principio. Llegado a este punto, el intercambio se hace tantas veces sea necesario
--hasta que haya un ganador.

realizanSusTareas:: (Heroe, Heroe) -> (Heroe, Heroe)
realizanSusTareas (heroe1, heroe2) = (realizarLabor (listaTareas heroe2) heroe1, realizarLabor (listaTareas heroe1) heroe2)

type Labor = [Tarea]

realizarLabor :: Labor -> Heroe -> Heroe
realizarLabor tareas heroe = foldl realizarTarea heroe tareas

-- * PUNTO 8
-- ¿Cuál es el resultado de hacer que presuman dos héroes con reconocimiento 100, ningún artefacto y
--ninguna tarea realizada?

heroeTorpe = UnHeroe "Torpe" 100 [] []

-- ^No hay respuesta, ya que la evaluacion es infinita

-- * PUNTO 9
--Obviamente, los Dioses no se quedan cruzados de brazos. Al
--contrario, son ellos quienes imparten terribles misiones ante
--nuestros héroes. Claro es el ejemplo de Heracles con sus
--doce tareas, o bien conocidas bajo el nombre de labores.
--Llamamos labor a un conjunto de tareas que un héroe realiza
--secuencialmente.

--Hacer que un héroe realice una labor, obteniendo
--como resultado el héroe tras haber realizado todas las
--tareas.

-- ^ya está hecho en el punto 7 :)

-- * PUNTO 10
--Si invocamos la función anterior con una labor infinita,
-- ¿se podrá conocer el estado final del héroe? ¿Por qué?

-- ^No, no podriamos conocer el estado final del heroe ya que al tener una lista infinita de labores, 
-- ^Se quedará evaluando infinitamente esperando un resultado final que nunca llegará