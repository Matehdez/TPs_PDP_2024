//=======================================EL NUEVO MIGUELITO ====================================
// PUNTO 1

/* Tenemos platos
Cada plato tiene caracteristicas compartidas
Luego, cada plato particular puede ser de un tipo diferentes

Una hamburguesa tiene diferentes tipos de clases de pan

----------------------------------------------------------------

Luego hay comensales, y hay diferentes tipos de clase de comensal

-----------------------------------------------------------------

Un comensal puede cambiar de tipo de clase*/

//CLASE PLATO =========================================================
class Plato {

method paraCeliaco()

method valoracion()

method peso()

method esEspecial() = self.peso() > 250

method precio() {
  const precioBase = self.valoracion() * 300
if (self.paraCeliaco()) {
  return precioBase + 1200
}else {
  return precioBase
}
}

}

//CLASE PROVOLETA =========================================================

class Provoleta inherits Plato {
  const peso

  override method peso() = peso

  var property tieneEmpanado

  override method paraCeliaco() = ! tieneEmpanado

  override method esEspecial() = super() && tieneEmpanado

  override method valoracion() {
    if (self.esEspecial()) { //if (self.esEspecial()) 120 else 80
      return 120
    } else {
      return 80
    }
  }

}

//CLASE HAMBURGUESA =========================================================

class Hamburguesa inherits Plato {
  var pesoCarne

  method pesoCarne() = pesoCarne

  var property tipoPan

  method pesoPan() = tipoPan.peso()

  override method peso() = pesoCarne + self.pesoPan()

  override method paraCeliaco() = tipoPan.paraCeliaco()

  override method valoracion() = self.peso() / 10

}

class TipoPan {
  method peso()

   method paraCeliaco()

}

//Aqui mi duda es si tengo que crearlos como clase o como objetos, ya que tienen un comportamiento definido
object industrial inherits TipoPan {
  override method peso() = 60

  override method paraCeliaco() = false

}

object casero inherits TipoPan {
  override method peso() = 100

  override method paraCeliaco() = false
}

object maiz inherits TipoPan {
  override method peso() = 30

  override method paraCeliaco() = true
}

//CLASE BURGUER DOBLE =========================================================

class HamburguesaDoble inherits Hamburguesa {
  override method pesoCarne() = super() * 2

  override method esEspecial() = self.peso() > 500

}

//CLASE CORTE CARNE =========================================================

class CorteCarne inherits Plato {
const peso

override method peso() = peso

var property tipoCoccion

var property tipoCorte

override method valoracion() = 100

}

//CLASE PARILLADA =========================================================

class Parillada inherits Plato {
  var property platos

  override method peso() = platos.sum({plato => plato.peso()})

  override method esEspecial() = super() && platos.size() >= 3

  override method paraCeliaco() = platos.all({plato => plato.paraCeliaco()})

  override method valoracion() = platos.max({plato=> plato.valoracion()})
}

//PUNTO 2
//COMENSALES

class Comensal {
  var property dinero

  method leAgrada(comida) = tipoComensal.gusta(comida)

  method comprar(parrilla, comida) {
    if(not self.puedePagar(comida)) {
      throw new ExcepcionDinero ( message = "No hay fondos suficientes")
    }else{
      if (not parrilla.estaDisponible(comida)){
        throw new ExcepcionPlatos ( message = "No hay platos disponibles para elegir")
      } else{
        dinero -= comida.precio()
        parrilla.vender(comida, self)
      }
      
    }
  }

  method puedePagar(comida) = comida.precio() <= dinero

  var property tipoComensal

  method darseGusto(parrilla) {
    var platoValioso = parrilla.platoMasValioso()
    if(not parrilla.hayPlatosDisponibles()) {
      throw new ExcepcionPlatos ( message = "No hay platos disponibles para elegir")
    }else{
      if(self.leAgrada(platoValioso)){
        self.comprar(parrilla, platoValioso)
      }
      
    }
  }

  method recibirDinero(_dinero) {
    dinero += _dinero
  }

  method cambiarHabito() = tipoComensal.cambiarHabito(self)

  method tieneCeliaquia() = tipoComensal.esCeliaco()

  method esRico() = dinero >= 10000

}

class ExcepcionPlatos inherits DomainException {}
class ExcepcionDinero inherits DomainException {}


//TIPOS DE COMENSALES

class TipoComensal {

  method cambiarHabito(comensal) {}

  method esCeliaco() = false
}

object celiaco inherits TipoComensal{
  method gusta(comida) = comida.paraCeliaco()

  override method esCeliaco() = true 

  override method cambiarHabito(comensal) = if (comensal.esRico()) comensal.tipoComensal(paladarFino)
}

object paladarFino inherits TipoComensal{
  method gusta(comida) = comida.esEspecial() || comida.valoracion() > 100

  override method cambiarHabito(comensal) = if (comensal.tieneCeliaquia()) comensal.tipoComensal(celiaco) else comensal.tipoComensal(todoTerreno)

}

object todoTerreno inherits TipoComensal{
  method gusta(_) = true

  override method cambiarHabito(comensal) = if (comensal.tieneCeliaquia()) comensal.tipoComensal(celiaco) else comensal.tipoComensal(paladarFino)

}

//Parrilla

object parrillaMiguelito {
  var property platosDisponibles = []

  var property comensalesHabituales = #{}

  var property dineroDisponible = 0

  method platoMasValioso() = platosDisponibles.max({plato=> plato.valoracion()})

  method estaDisponible(plato) = platosDisponibles.contains(plato)

  method hayPlatosDisponibles() = self.platosDisponibles().isEmpty()

  method vender(comida, comensal) {
    dineroDisponible += comida.precio()
    platosDisponibles.remove(comida)
    comensalesHabituales.add(comensal)
  }

  method regalarDinero(comensal, _dinero) = comensal.recibirDinero(_dinero)

  method promocion(_dinero) = comensalesHabituales.forEach({comensal => comensal.recibirDinero(_dinero)})


}

//PUNTO 3 ===================================
