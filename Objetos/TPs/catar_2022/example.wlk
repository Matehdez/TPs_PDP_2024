//CATAR ================================================

class Plato {
  var property azucar
  var property esBonito 

  method calorias() = 3 * azucar + 100 

  method calificacion(chef) = chef.catar(self)

}

class Entrada inherits Plato {
  override method azucar() = 0

  override method esBonito() = true
}

class Principal inherits Plato {

}

class Postre inherits Plato {
  override method azucar() = 120

  const property cantColores

  override method esBonito() = cantColores > 3
}

//CLASS COCINERO ===============================================

class Cocinero {

  var property especialidad

  method cocinar() = especialidad.cocinar()

  method catar(plato) = especialidad.catar(plato)

  method participarTorneo(torneo) {
    const plato = self.cocinar()

    torneo.platosTorneo().add(plato)

    torneo.participantes().add(self)
  }

}

class Especialidad {

  method cocinar()

  method catar(plato)

}

class Chef inherits Especialidad {

  const property limiteCalorias

  override method cocinar() = new Principal (esBonito = true, azucar = limiteCalorias)

  override method catar(plato){

    if (plato.esBonito() && plato.calorias() <= limiteCalorias) 10 else 0
 }
}

class Pastelero inherits Especialidad {

  override method cocinar() = new Postre (cantColores = nivelDulzor / 50)

  const property nivelDulzor 

  override method catar(plato){

  const calificacion = 5 * plato.azucar() / nivelDulzor

  return calificacion.min(10)

 }
  
}

class Souschef inherits Chef {

  override method catar(plato) {
    if (plato.esBonito() && plato.calorias() <= limiteCalorias) 10 else ((plato.calorias() / 100).min(6))

  override method cocinar() = new Entrada ()

  }
}

class Torneo {
  var property platosTorneo 

  var property participantes

  const property catadores 

  //catador.catar(plato) + ...  = calificacionPlato
  method calificacion(plato) = catadores.sum({chef => plato.calificacion(chef)})

  method platoGanador() = platosTorneo.max({plato => self.calificacion(plato)})

  method platoDeParticipante(plato) = participantes.find({p => p.cocinar() == plato})

  method participanteGanador() = self.platoDeParticipante(self.platoGanador())
}