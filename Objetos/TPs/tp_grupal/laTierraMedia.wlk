//---------------------| La Tierra Media |----------------

// Gandalf----------------

object gandalf{

  var property armas = [baculo, espada]
  
  var vida = 100 // Entre 0 y 100

  method vida() = vida

  method vida(nuevaVida){
    vida = nuevaVida.min(100).max(0)
  }

  method poder() = if(vida >= 10) vida * 15 + self.poderArmas() * 2 else vida * 300 + self.poderArmas() * 2

  method poderArmas() = armas.map({arma=> arma.poder()}).sum()

  method recorrerZona(zona)  = if(zona.puedePasar(self)) zona.consecuencias(self)

}

// Armamento-----------
object baculo{
  method poder() = 400

}

object espada{
  var property origen = elfico
  method poder() = origen.modificador() * 10 
}

// Origen---
object elfico{
  method modificador() = 25
}

object enano{
  method modificador() = 20
}

object humano{
  method modificador() = 15
}

// Recorriendo La Tierra Media ----------------

// Zonas-----------
object lebennin{
  method puedePasar(persona) = persona.poder() > 1500
  method consecuencias(_){}
}

object minasTirith{
  method puedePasar(persona) = !persona.armas().isEmpty()
  method consecuencias(persona) = persona.vida(persona.vida() - 10)
}

object lossarnach{
  method puedePasar(_) = true
  method consecuencias(persona) = persona.vida(persona.vida() + 1) 
}

object gondor{
  var property zonas = [minasTirith, lebennin, lossarnach]
  method puedePasar(persona) =  zonas.all({zona => zona.puedePasar(persona)}) //fold? zonas.fold(persona, {zona => zona.consecuencias(persona)})
  method consecuencias(persona) = zonas.fold(persona, ({persona , zona => zona.consecuencias(persona)}))
}

// Tom Bombadil----------------

object tom { 
  method vida() = 100
  method recorrerZona(_) = true
  method poder() = 2000
}

///////////////////////////////////////////////////////////////////

//=========================================| Segunda Parte |=========================================
///////////////////////////          Arsenal               ///////////////////////////////////////////

class Espada {
  var multiplicador = 0

  method multiplicador(valor){
    if(valor < 1 || valor > 20){
      throw new DomainException(message="El valor del multiplicador debe ser entre 1 y 20")
    } else{
      multiplicador = valor}
    
  }

  method poder(guerrero) = multiplicador*guerrero.valorOrigen() //Caso cualquier otro implementado en Guerrero
   
}

class Daga inherits Espada {
  override method poder(guerrero) = super(guerrero) / 2 
}

class Hacha {
  const mango = 0
  const hojaMetalica = 0

  method poder(_) = mango*hojaMetalica 
}

class Baculo {
  const poder = 0 //se podria no poner =0

  method poder(_) = poder
}


///////////////////////////          Guerreros               ///////////////////////////////////////////
class Guerrero{
  var vida = 0
  var property armas = []

  method vida() = vida

  method modificarVida(cantidad) {
    vida = vida + cantidad
    if (vida < 0) {
      vida = 0
    }
  }

  //method poder() = vida + self.algoQueDependeDeQueTipoDeGuerreroEs() * self.poderArmas()

  method poderArmas() = armas.map({arma=> arma.poder(self)}).sum()   //ARMAS.SUM{ARMA => ARMA.PODER()} | sum hace el trabajo de map

  method valorOrigen() = 10*self.cantidadDeArmas() //Por defecto

  method cantidadDeArmas() = armas.size()
  
  //La region puede ser una zona o un camino que es un conjunto de zonas 
  method recorrer(region) {
    if (region.puedePasar(self)){
      region.consecuenciasAlCruzar(self)
    }
  }

  method cantidadItemsFiltrados(nuevoItem) = 0 //Por defecto
  
}
class Hobbit inherits Guerrero{
  var property items = []

  method poder() = self.vida() + self.cantidadItems()*self.poderArmas()

  //override algoQueDependeDeQueTipoDeGuerreroEs() = self.cantidadItems()
  
  method cantidadItems() = items.size()

  override method cantidadItemsFiltrados(nuevoItem) = items.count({item => item == nuevoItem})  

}

class Enano inherits Guerrero{
  var property factorDePoder = 0

  method poder() = self.vida() + self.factorDePoder()*self.poderArmas()

    //override algoQueDependeDeQueTipoDeGuerreroEs() = self.factorDePoder()

  override method valorOrigen() = 20
}

class Elfo inherits Guerrero{
  var destrezaBase = 2
  var destrezaPropia = 0

  method poder() = self.vida() +(destrezaBase+destrezaPropia)*self.poderArmas()

  //override algoQueDependeDeQueTipoDeGuerreroEs() = self.factorDePoder(destrezaBase+destrezaPropia)

  override method valorOrigen() = 25
}
class Humano inherits Guerrero{
  var limitadorPoder = 0
  
  method poder() = self.vida() +self.poderArmas() / limitadorPoder

  //override poder() = super() / limitadorPoder

  override method valorOrigen() = 15
}

class Maiar inherits Guerrero{
  var property factorBasico = 15
  var property factorAmenaza = 300

  method poder() = if(vida >= 10) vida * factorBasico + self.poderArmas() * 2 else vida * factorAmenaza + self.poderArmas() * 2
}


//? Es conceptualmente correcto que un objeto herede de una superclase?
object gollum inherits Hobbit{

  override method poder() = super()/2 
  
}

object tomBombadill {
  method poder() = 10000000 
}

///////////////////////////          Zonas y Caminos               ///////////////////////////////////////////
class Zona{
  var property requerimiento

  //method puedePasarGrupo(integrantes) = requerimiento.loCumple(integrantes)
  method puedePasar(guerrero)
  method consecuenciasAlCruzar(guerrero)

  method cumpleElRequerimientoExtra(grupo) = requerimiento.loCumple(grupo)
}

class ZonaConPoder inherits Zona{
  const cantidadPoder
  
  override method puedePasar(guerrero) = guerrero.poder() > cantidadPoder

  override method consecuenciasAlCruzar(guerrero) {} //No hay consecuencias

}
class ZonaConArmas inherits Zona{
  const cantidadVida 
  
  override method puedePasar(guerrero) = !guerrero.armas().isEmpty()

  override method consecuenciasAlCruzar(guerrero) {
    guerrero.modificarVida(-cantidadVida)
  }

}

class Camino {
  const zonas = #{}

  method puedePasar(guerrero) = zonas.all({zona => zona.puedePasar(guerrero)})

  method consecuenciasAlCruzar(guerrero) {
    zonas.fold(guerrero,({guerrero,zona => zona.consecuenciasAlCruzar(guerrero)}))
  }

  method puedeAtravesarConRequerimiento(grupo) = zonas.all({zona => zona.cumpleElRequerimientoExtra(grupo)}) 

}
class Grupo{
  var integrantes = #{}
  
  method integrantes() = integrantes

  //La region puede ser una zona o un camino que es un conjunto de zonas
  // en este caso region es un camino
  method recorrer(region) {
    if(self.puedeAtravesar(region) && region.puedeAtravesarConRequerimiento(self)){
      self.consecuenciaAlCruzar(region)
    }
  }
  method puedeAtravesar(region) = integrantes.all({integrante => region.puedePasar(integrante)})

  method consecuenciaAlCruzar(region) = integrantes.forEach({integrante => region.consecuenciasAlCruzar(integrante)})
  //method cumple(requerimiento) = requerimiento.loCumple(self)
  
}


class RequerimientoElemento {
  var property nombreElemento
  var property cantidad

  method loCumple(grupo) = grupo.integrantes().sum({integrante => integrante.cantidadItemsFiltrados(nombreElemento)}) > cantidad

}

class RequerimientoGuerrero {

  method loCumple(grupo) = grupo.integrantes().any({integrante => self.cumple(integrante)})

  method cumple(integrante)  

}

class RequerimientoPoder inherits RequerimientoGuerrero{
  const poderRequerido
  method poderRequerido() = poderRequerido

  override method cumple(integrante) = integrante.poder() > poderRequerido  

}
class RequerimientoVida inherits RequerimientoGuerrero{
  const vidaRequerido

  method vidaRequerido() = vidaRequerido 
  override method cumple(integrante) = integrante.vida() > vidaRequerido 
}

object dosArmas inherits RequerimientoGuerrero{
  method cantidad() = 2 

  override method cumple(integrante) = integrante.cantidadDeArmas() >= self.cantidad()


}