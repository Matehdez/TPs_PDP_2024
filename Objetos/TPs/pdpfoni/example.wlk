class Linea {
  var property tipo //comun, black, platinium

  const property nroTelefono

  var property packs //lista de packs

  method packsActivos() = packs.filter({pack => not pack.estaVencido()}) //lista de packs ACTIVOS

  var property consumos //lista de consumos 

  method fechaConsumo() = consumos.map({consumo => consumo.fecha()})

  var property hoy  // define hoy as the current date

  method ultConsumos() = consumos.filter({consumo => hoy.between(consumo.fecha(), consumo.fecha().plusdays(29))})

  method costoTotUltConsumos() = self.ultConsumos().sum({consumo => consumo.costoXservicio()})

  method costoPromUltConsumos() = self.costoTotUltConsumos() / self.ultConsumos().size()

  method adquirirPack(pack) = packs.add(pack)

  method puedeRealizarConsumo(consumo) = tipo.puedeRealizarConsumo(consumo)

  method packUtilizado(consumo) = packs.find({pack => pack.puedeSatisfacer(consumo)})

  method registrarConsumo(consumo) {
    if (self.puedeRealizarConsumo(consumo)){
      self.packUtilizado(consumo).consumirPack(consumo)
      consumos.add(consumo)
    }else {
      if (tipo.puedeSumarDeuda()){
        tipo.sumarDeuda(consumo)
        consumos.add(consumo)
      }else 
      throw new DomainException(message = "No se pudo realizar el consumo")
    }
  }

}

class TipoLinea {
  var property linea

  method puedeRealizarConsumo(consumo) = linea.packs().any({pack => pack.puedeSatisfacer(consumo) && not pack.estaVencido()})

  method puedeSumarDeuda() = false

}

class Comun inherits TipoLinea {
  
}
class Black inherits TipoLinea {
  var property deuda = 0

  override method puedeSumarDeuda() = true

  method sumarDeuda(consumo) {
    linea.packUtilizado(consumo).consumirPack(consumo)
    var creditoDisp = linea.packUtilizado(consumo).creditoDisp()
    if(creditoDisp < 0){
      deuda = creditoDisp.abs()
    }

  }
}
class Platinium inherits TipoLinea {
  
  override method puedeRealizarConsumo(consumo) = true
  
}


class Consumo {
  var property empresa

  var property fecha

  method costoXservicio()

  method esConsumoTelefonico() 

  method esConsumoInternet()

}

class ConsumoInternet inherits Consumo {
  var property mbConsumidos

   override method costoXservicio() = empresa.precioXMB() * mbConsumidos

   override method esConsumoTelefonico() = false

   override method esConsumoInternet() = true
}

class ConsumoTelefono inherits Consumo {
    var property segConsumidos

   override method costoXservicio() {
    var precioFijo = empresa.precioFijoSeg()

    if(segConsumidos <=30){
      return precioFijo
    }else{
      var ultimosSegundos = segConsumidos - 30
      return precioFijo + (ultimosSegundos * empresa.precioXSeg())
    }
   }

   override method esConsumoTelefonico() = true

   override method esConsumoInternet() = false

}

//PACKS -------------------------------------------
class Packs {
  const property fechaVencimiento

  var property hoy  // define hoy as the current date

  method estaVencido() = hoy.minusDays(0) == fechaVencimiento

  method puedeSatisfacer(consumo)

  method consumirPack(consumo) {}
}

class CantCredito inherits Packs{
  const property creditoDisp

  override method puedeSatisfacer(consumo) = creditoDisp >= consumo.costoXservicio()

  override method consumirPack(consumo) {
    if (self.puedeSatisfacer(consumo)) (creditoDisp - consumo.costoXservicio())
  }

  override method estaVencido() = super() || creditoDisp == 0

}

class CantMB inherits Packs{
  const property mbDisp

  override method puedeSatisfacer(consumo) = consumo.esConsumoInternet() && mbDisp >= consumo.mbConsumidos()
  
  override method consumirPack(consumo) {
    if (self.puedeSatisfacer(consumo)) (mbDisp - consumo.mbConsumidos())
  }

  override method estaVencido() = super() || mbDisp == 0

}

class CantMBplus inherits CantMB {

  override method puedeSatisfacer(consumo) = super(consumo) || consumo.mbConsumidos() <= 0.1

  override method estaVencido() = false

}

class LlamadasGratis inherits Packs{
  const property tieneLlamadas //bool

  override method puedeSatisfacer(consumo) = consumo.esConsumoTelefonico() && tieneLlamadas

  
}

class InternetIlimitado inherits Packs{
  const property tieneInternet //bool

  override method puedeSatisfacer(consumo) = consumo.esConsumoInternet() && tieneInternet
  
}

//EMPRESA -------------------------------------------
object empresaTelefonica {
  var property precioXMB = 0.1
  var property precioXSeg = 0.05

  const property precioFijoSeg = 1 //Primeros 30 segundos
}