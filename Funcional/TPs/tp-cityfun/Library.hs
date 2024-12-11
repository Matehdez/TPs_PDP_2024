module Library where
import PdePreludat

data Ciudad = UnaCiudad
  { nombre :: String,
    anioDeFundacion :: Number,
    atracciones :: [String],
    costoVida :: Number
  }
  deriving (Show, Eq, Ord)

---Definimos Ciudadess---
baradero :: Ciudad
baradero =
  UnaCiudad
    { nombre = "Baradero",
      anioDeFundacion = 1615,
      atracciones = ["Parque del Este", "Museo Alejandro Barbich"],
      costoVida = 150
    }

nullish :: Ciudad
nullish =
  UnaCiudad
    { nombre = "Nullish",
      anioDeFundacion = 1800,
      atracciones = [],
      costoVida = 140
    }

caletaOlivia :: Ciudad
caletaOlivia =
  UnaCiudad
    { nombre = "Caleta Olivia",
      anioDeFundacion = 1901,
      atracciones = ["El gorosito", "Faro Costanera"],
      costoVida = 120
    }

maipu :: Ciudad
maipu =
  UnaCiudad
    { nombre = "Maipu",
      anioDeFundacion = 1878,
      atracciones = ["Fortin Kakel"],
      costoVida = 115
    }

azul :: Ciudad
azul =
  UnaCiudad
    { nombre = "Azul",
      anioDeFundacion = 1832,
      atracciones = ["Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
      costoVida = 190
    }

anioLimite :: Number
anioLimite = 1800

----------------------------------------------------------------------- PUNTO 1

valorDeUnaCiudad :: Ciudad -> Number
valorDeUnaCiudad ciudad = valorCiudad (anioDeFundacion ciudad) (atracciones ciudad) (costoVida ciudad)

valorCiudad :: Number -> [String] -> Number -> Number
valorCiudad _ [] costoVida = 2 * costoVida
valorCiudad anioDeFundacion atracciones costoVida
  | anioDeFundacion < anioLimite = ((5 *) . (-) anioLimite) anioDeFundacion
  | otherwise = 3 * costoVida

----------------------------------------------------------------------- PUNTO 2

vocales :: String
vocales = "aeiouAEIOU"

esVocal :: Char -> Bool
esVocal letra = letra `elem` vocales

atraccionCopada :: Ciudad -> Bool
atraccionCopada ciudad = any esVocal (primerasLetras ciudad)

primerasLetras :: Ciudad -> [Char]
primerasLetras ciudad = map head (atracciones ciudad)

ciudadSobria :: Number -> Ciudad -> Bool
ciudadSobria cantidad = esSobria cantidad . atracciones

esSobria ::  Number -> [String] -> Bool
esSobria _ [] = False
esSobria cantidad atracciones = all ((> cantidad) . length) atracciones

tieneNombreRaro :: Ciudad -> Bool
tieneNombreRaro = (< 5) . length . nombre

----------------------------------------------------------------------- PUNTO 3

--- Definio Eventos ---
type Evento = Ciudad -> Ciudad

-- Sumar nueva atracción
agregarAtraccion :: String -> Evento
agregarAtraccion atraccion ciudad = ciudad {atracciones = atraccion : atracciones ciudad}

aumentarCostoDeVida :: Number -> Ciudad -> Ciudad
aumentarCostoDeVida porcentaje ciudad = ciudad {costoVida = ((* (porcentaje / 100 + 1)) . costoVida) ciudad}

nuevaAtraccion :: String -> Evento
nuevaAtraccion atraccion = aumentarCostoDeVida 20 . agregarAtraccion atraccion

-- Crisis
disminuirCostoDeVida :: Ciudad -> Ciudad
disminuirCostoDeVida ciudad = ciudad { costoVida =   0.9 * costoVida ciudad}

cerrarUltimaAtraccion :: Ciudad -> Ciudad
cerrarUltimaAtraccion ciudad = ciudad {atracciones = cerrarUltima (atracciones ciudad)}

cerrarUltima :: [String] -> [String]
cerrarUltima [] = []
cerrarUltima atracciones = init atracciones

crisis :: Evento
crisis = cerrarUltimaAtraccion . disminuirCostoDeVida

-- Remodelación
agregarPrefijoNew :: Ciudad -> Ciudad
agregarPrefijoNew ciudad = ciudad {nombre = "New " ++ nombre ciudad}

remodelacion :: Number -> Evento
remodelacion porcentaje  =  agregarPrefijoNew . aumentarCostoDeVida porcentaje

-- Reevaluacion
reevaluacion :: Number -> Evento
reevaluacion letras ciudad
  | ciudadSobria letras ciudad = aumentarCostoDeVida 10 ciudad
  | otherwise = ciudad {costoVida = costoVida ciudad - 3}

----------------------------------------------------------------------- PUNTO 4: Un año para recordar
transformacionCiudad :: Number -> Number -> Ciudad -> Ciudad
transformacionCiudad cantLetras porcentaje = reevaluacion cantLetras . crisis . remodelacion porcentaje

---Declaro años---
data Anio = UnAnio{
    numero :: Number,
    eventos :: [Evento]
} deriving Show

anio2015 :: Anio
anio2015 = UnAnio{
    numero = 2015,
    eventos = []
}

anio2021 :: Anio
anio2021 = UnAnio{
    numero = 2023,
    eventos = [crisis,nuevaAtraccion "playa"]
}

anio2022 :: Anio
anio2022 = UnAnio{
    numero = 2022,
    eventos = [crisis, remodelacion 5, reevaluacion 7]
}

anio2023 :: Anio
anio2023 = UnAnio{
    numero = 2023,
    eventos = [crisis,nuevaAtraccion "parque",remodelacion 10,remodelacion 20]
}

anio2024 :: Anio
anio2024 = UnAnio{
    numero = 2024,
    eventos = repeat crisis
}

---4.1) Los años pasan...
aplicarEvento :: Ciudad -> Evento -> Ciudad
aplicarEvento ciudad evento = evento ciudad

eventosDelAnio :: Ciudad -> [Evento] -> Ciudad
eventosDelAnio = foldl aplicarEvento

pasoDeUnAnio :: Ciudad -> Anio -> Ciudad
pasoDeUnAnio ciudad = eventosDelAnio ciudad.eventos

--- 4.2) Algo mejor ...
type Criterio = Ciudad -> Number

cantidadDeAtracciones :: Ciudad -> Number
cantidadDeAtracciones = length.atracciones

evaluarCriterio :: Ciudad -> Criterio -> Evento -> Bool
evaluarCriterio ciudad criterio = (> criterio ciudad).(criterio.aplicarEvento ciudad)

------4.3) 4.4) 4.5) Costo de vida/valor de una ciudad que suba/baje

--aplicarCriterio :: Ciudad -> Anio -> Criterio -> Anio
--aplicarCriterio ciudad anio criterio = anio {eventos = filter (evaluarCriterio ciudad criterio) (eventos anio)}
aplicarCriterio :: Ciudad -> Anio -> (Ciudad -> Evento -> Bool) -> Anio
aplicarCriterio ciudad anio eventoQueCumple = anio {eventos = filter (eventoQueCumple ciudad) (eventos anio)}

--pasoDeUnAnioConCriterio :: Ciudad -> Anio -> Criterio -> (Ciudad -> Anio -> Criterio -> Anio)  -> Ciudad
--pasoDeUnAnioConCriterio ciudad anio criterio aplicarCriterio = pasoDeUnAnio ciudad (aplicarCriterio ciudad anio criterio)
pasoDeUnAnioConCriterio :: Ciudad -> Anio -> (Ciudad -> Evento -> Bool) -> Ciudad
pasoDeUnAnioConCriterio ciudad anio = pasoDeUnAnio ciudad.aplicarCriterio ciudad anio

costoDeVidaQueSube :: Ciudad -> Evento -> Bool
costoDeVidaQueSube ciudad = evaluarCriterio ciudad costoVida

costoDeVidaQueBaje :: Ciudad -> Evento -> Bool
costoDeVidaQueBaje ciudad = not.evaluarCriterio ciudad costoVida

valorQueSuba :: Ciudad -> Evento -> Bool
valorQueSuba ciudad evento = valorDeUnaCiudad (evento ciudad) > valorDeUnaCiudad ciudad

-- Aplicación de las funciones en consola
 --pasoDeUnAnioConCriterio azul anio2022 
 --pasoDeUnAnioConCriterio azul anio2022 
----------------------------------------------------------------------- PUNTO 5: Funciones a la orden

verificarOrden :: (a -> a -> Bool) -> [a] -> Bool
verificarOrden _ [_] = True
verificarOrden criterio (x:y:ys) = criterio x y && verificarOrden criterio (y:ys)

--- 5.1) Eventos ordenados

ordenEventos :: Ciudad -> Evento -> Evento -> Bool
ordenEventos ciudad evento1 evento2 = (costoVida.evento1) ciudad < (costoVida.evento2) ciudad

eventosOrdenados :: Ciudad -> Anio -> Bool
eventosOrdenados ciudad anio = verificarOrden (ordenEventos ciudad) (eventos anio)

--- 5.2) Ciudades ordenadas

ordenCiudades :: Evento -> Ciudad -> Ciudad -> Bool
ordenCiudades evento ciudad1 ciudad2 = (costoVida.evento) ciudad1 < (costoVida.evento) ciudad2

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool
ciudadesOrdenadas evento = verificarOrden (ordenCiudades evento)

--- 5.3) Años ordenados

ordenAnios :: Ciudad -> Anio -> Anio -> Bool
ordenAnios ciudad anio1 anio2 = (costoVida.pasoDeUnAnio ciudad) anio1 < (costoVida.pasoDeUnAnio ciudad) anio2

aniosOrdenados :: Ciudad -> [Anio] -> Bool
aniosOrdenados ciudad = verificarOrden (ordenAnios ciudad)
----------------------------------------------------------------------- PUNTO 6: Al infinito, y más allá...
-- Debido a que haskell tiene lazy evaluation, cualquiera de las tres funciones podría dar un resultado solo en caso de que sea False (en algún momento de la recurrencia se detecta un desorden).
-- En caso de que estén en orden, el resultado de la función será siempre true y por ende nunca terminará de evaluar la lista infinita de eventos, no pudiendo dar una respuesta definitiva.