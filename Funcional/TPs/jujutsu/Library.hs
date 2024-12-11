module Library where
import PdePreludat
import Data.List (sortBy)

-- *===================================Jujutsu=================================== *--
-- * APROBADO * --

data Clan = UnClan{
    alias:: String,
    hechiceros :: [Hechicero]
} deriving (Show, Eq)


data Hechicero = UnHechicero {
    nombre :: String,
    antiguedad :: Number,
    clan :: Clan,
    grado :: Number

} deriving (Show, Eq)

-- * PUNTO 1---------------------------------------------------------------------------------------------

--Nobara, una  hechicera estudiante con tan solo un año de antigüedad luchando contra maldiciones, 
--forma parte del clan Kugisaki y es una hechicera de grado 3.

--Satoru, un hechicero maestro de grado 0, que tiene 15 años de antigüedad y es parte del clan Gojo.

--Maki, una estudiante con 3 años de antigüedad, es parte del clan Zenin y tiene un grado 4.

--Yuji, un novato en la escuela de hechicería por lo que posee una antigüedad de 0 años, 
--es parte del clan Itadori y tiene un grado 1.

kugisaki = UnClan "Kugisaki" [nobara]
gojo = UnClan "Gojo" [satoru]
zenin = UnClan "Zenin" [maki]
itadori = UnClan "Itadori" [yuji]


nobara = UnHechicero {nombre = "Nobara",antiguedad= 1 ,clan= kugisaki,grado= 3 }
satoru = UnHechicero "Satoru" 15 gojo 0 
maki = UnHechicero "Maki" 3 zenin 4 
yuji = UnHechicero "Yuji" 0 itadori 1 

equipo1 = [nobara, maki]
equipo2 = [satoru, yuji]
equipo3 = [nobara, yuji, maki]

-- * PUNTO 2---------------------------------------------------------------------------------------------
--Para pelear contra las maldiciones los hechiceros se agrupan en equipos. 
--Nos interesa saber cuándo un equipo está preparado, lo cual se da si el equipo tiene más de 3 integrantes.

type Equipo = [Hechicero] 

estaPreparado :: Equipo -> Bool
estaPreparado  = (>3).length

-- * PUNTO 3---------------------------------------------------------------------------------------------
--Existen algunos grupos que podemos decir que son invencibles, 
--esto sucede cuando existe al menos un integrante que sea de grado especial, 
--ya que son los hechiceros más poderosos y pueden con cualquier maldición.

esInvencible :: Equipo -> Bool
esInvencible  = any esEspecial 

esEspecial :: Hechicero -> Bool
esEspecial  = (==0) . grado  

-- * PUNTO 4---------------------------------------------------------------------------------------------
--Existen algunos clanes que poseen cierto prestigio dentro del mundo de la hechicería: el clan Zenin, Gojo y Kamo.
--Queremos saber si un hechicero es prestigioso, esto se da cuando pertenece a alguno de los tres clanes mencionados.

esPrestigiosoClan :: Clan -> Bool
esPrestigiosoClan clan = alias clan == "Zenin" || alias clan == "Gojo" || alias clan == "Kamo" 

esPrestigiosoHechicero :: Hechicero -> Bool
esPrestigiosoHechicero hechicero = esPrestigiosoClan $ clan hechicero

-- * PUNTO 5---------------------------------------------------------------------------------------------
--Queremos saber si un grupo es favorito de los altos mandos, 
--esto se da cuando todos los integrantes del mismo son prestigiosos.

esFavorito :: Equipo -> Bool
esFavorito  = all esPrestigiosoHechicero

-- * PUNTO 6---------------------------------------------------------------------------------------------
--Nos interesa saber de un grupo quienes son los expertos, que estarán al mando de las misiones. 
--Decimos que los expertos serán aquellos que tengan más de un año de antigüedad.

sonExpertos :: Equipo -> Equipo
sonExpertos = filter tieneXP

tieneXP :: Hechicero -> Bool
tieneXP  = (1>) . antiguedad

-- * PUNTO 7---------------------------------------------------------------------------------------------
--Queremos que sea posible subir de grado a nuestros hechiceros a medida que se vuelven más fuertes. 
--Para esto se le restará un punto a su grado, subiendo así a la siguiente categoría. En el caso de 
--que sea un hechicero de grado especial, es decir que su grado es 0, como es el rango máximo, quedará en el mismo rango.

subirGrado ::Hechicero -> Hechicero
subirGrado hechicero 
    |grado hechicero == 0 = hechicero
    |otherwise = hechicero {grado = grado hechicero - 1}

-- * PUNTO 8---------------------------------------------------------------------------------------------
--Queremos saber si un grupo es capaz de hacerle frente a cualquier maldición. 
--Esto puede suceder cuando el grupo es invencible, o bien si está preparado, 
--de forma que pueden tener muchas habilidades para enfrentarla.

resisteMaldicion :: Equipo -> Bool
resisteMaldicion equipo  = esInvencible equipo || estaPreparado equipo

--Luego de derrotar a una maldición poderosa, ¡la batalla les genera un power up! Queremos que sea posible que 
--un grupo tenga un power up, es decir subirle el grado a cada integrante.

powerUp :: Equipo -> Equipo
powerUp equipo
    |resisteMaldicion equipo = map subirGrado equipo
    |otherwise = equipo

-- * PUNTO 9---------------------------------------------------------------------------------------------
--Nuestros hechiceros no solo pueden hacer misiones en equipo, en ciertos casos queremos que tengan misiones en solitario, 
--para esto los del alto mando deben decidir entre dos hechiceros, quien es el más apto. 
--Para ello, comparan el nivel de los hechiceros según el criterio que se necesite:

--Algunas misiones son un poco difíciles, por lo que queremos que vaya aquel hechicero con mayor nivel tryhard. 
--Este se calcula como la división entre 1 y el grado anterior del hechicero. 
--Por ejemplo si un hechicero tiene grado 0, la división sería 1 / (0+1)

--Otras misiones requieren tener cierto nivel burocrático, que dependerá de la cantidad de letras de su clan.

--Mientras que otras van a depender del nivel intimidante, que será la letra mayor de su clan. 
--Por ejemplo, para el clan Itadori, su letra máxima es la t, para el clan Gojo, la letra máxima es la o; 
--en este caso el hechicero más intimidante sería el del clan Itadori.

--Por último, en otros casos necesitamos que tengan un nivel de sigilo 
--que será calculado con la cantidad de años de experiencia multiplicado por 6.

nivelTryhard :: Hechicero -> Number
nivelTryhard hechicero = 1 / grado hechicero +1 

nivelBurocratico :: Hechicero -> Number
nivelBurocratico = length . alias . clan 

nivelIntimidante :: Hechicero -> Char
nivelIntimidante  = head . alias . clan  

nivelSigilo :: Hechicero -> Number
nivelSigilo  = (*6) . antiguedad 

compararSegun :: Ord a => (Hechicero -> a) -> Hechicero -> Hechicero -> Hechicero
compararSegun criterio hechicero1 hechicero2
    |criterio hechicero1 > criterio hechicero2 = hechicero1
    |otherwise = hechicero2

masAptoSegun :: Ord a => (Hechicero -> a)-> Equipo -> Hechicero
masAptoSegun criterio  = foldl1 (compararSegun criterio)

sumarUno :: Number -> Number
sumarUno  = (+1)




