class Expedicion {
  var property invasiones //que invasiones vamos a hacer en la expedicion

  var property vikingos //invasores

  method cantVikingos() = vikingos.size()

  method valeLaPena() = invasiones.all({inv => inv.valeLaPena()})

  method realizarExpedicion() = invasiones.forEach({inv => inv.repartirBotin(self)})

}

class Invasion {

  method botin()
  method valeLaPena(expedicion)
  method cantidadRepartidaBotin(expedicion) = self.botin() / expedicion.cantVikingos()
  method repartirBotin(expedicion) = expedicion.vikingos().forEach({v => v.recibirDinero(self.cantidadRepartidaBotin(expedicion))})

}

class InvCapital inherits Invasion {
  const defensores 

  const factorRiqueza //puede ser negativo

  override method botin() = defensores + factorRiqueza

  method alcanzaBotin(expedicion) = self.cantidadRepartidaBotin(expedicion).mod(0) //o  sea, se repartio en partes iguales

  override method valeLaPena(expedicion) = self.alcanzaBotin(expedicion) && self.cantidadRepartidaBotin(expedicion) >= 3


}

class InvAldea inherits Invasion {
  const cantItemsRobados

  override method botin() = cantItemsRobados

  method saciaSed() = self.botin() >= 15

  override method valeLaPena(_) = self.saciaSed()
}

class InvAldeaAmurallada inherits InvAldea {

  const cantRequerida

  override method valeLaPena(expedicion) = super(expedicion) && expedicion.cantVikingos() >= cantRequerida
}



class Vikingo {
  var property casta //tipoVikingo

  var property dinero

  method recibirBotin(_dinero) {
    dinero += _dinero
  }

  method puedeExpedicionar() = casta.puedeExpedicionar(self) && self.esProductivo()

  method esProductivo()

  method expedicionar(expedicion) {
    if (self.puedeExpedicionar()) (expedicion.vikingos().add(self)) else (throw new DomainException(message = "El vikingo no puede embarcarse hacia la expedicion"))
  }

  method tieneArmas() = false

  method ascensoSocial() = casta.ascensoSocial(self)

  method esSoldado()

}

class Soldado inherits Vikingo {
  var property cantVidasCobradas

  var property armas //lista de armas

  override method tieneArmas() = armas > 0

  override method esProductivo() = cantVidasCobradas > 20 && self.tieneArmas()

  override method esSoldado() = true


}

class Granjero inherits Vikingo {
  var property cantHijos

  var property hectareas
  
  method hectareasXhijo() = hectareas / cantHijos

  method requisitoHijos()

  override method esProductivo() =
    cantHijos >= self.requisitoHijos() && self.hectareasXhijo() >= 2

  override method esSoldado() = false

}

//CASTA VIKINGOS =========================================================
class Casta {

  method ascensoSocial(vikingo) {}

  method puedeExpedicionar(_) = true

}

object jarl inherits Casta {

  override method ascensoSocial(vikingo) {
    vikingo.casta(karl)
    if(vikingo.esSoldado()) {
      vikingo.armas() +10
    } else {
      vikingo.hijos() + 2
      vikingo.hectareas() +2
    }
    
  }

  override method puedeExpedicionar(vikingo) = not vikingo.tieneArmas()

  
}

object karl inherits Casta {
  override method ascensoSocial(vikingo) {
    vikingo.casta(thrall)
  }
  
}

object thrall inherits Casta {
  
}