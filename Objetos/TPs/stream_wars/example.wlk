class Stream {
  var cantViwers

  var property invitados

  var nivelHype

  method nivelHype(_nivelHype) {
    nivelHype = _nivelHype
  }

  method nivelHype() = invitados.sum({invitado => invitado.popularidad()})
  

  method estaPegado() = nivelHype > 60

  method cantViewers()
}

class SQV inherits Stream{
  var property cantCanciones

  override method cantViewers() {
    return cantCanciones * 10000
  }

}

class Invitado {
  var popularidad

  var seguidores

  method seguidores(_seguidores) {
    seguidores = _seguidores
  }

  method seguidores() {
    if(juegaConMascotas){
      return cantMascotas * seguidores
    }else{
      return seguidores
    }
  }

  var property cantMascotas

  var juegaConMascotas

  method popularidad() {
    return seguidores/2
  }

  method juegaConMascotas() {
    if (cantMascotas == 0) {
      return false
    }else {
      return juegaConMascotas
    }
  }

}

class HAA inherits Stream{
  const conductor

  var property cantSucesos

  var hayAnalisis

  method hayAnalisis() = conductor.puedeHacerAnalisis(cantSucesos)
  

  override method cantViewers() {
    if(hayAnalisis){
      return 20000
    }else{
      return 10000
    }
  }

  override method nivelHype() = 100

}

class Conductor {
  method puedeHacerAnalisis(_) = true
}

object rebord inherits Conductor {
  method realidadInteresante(cantSucesos) = cantSucesos > 10

  override method puedeHacerAnalisis(cantSucesos) = self.realidadInteresante(cantSucesos)
}

class SesionIndependiente inherits Stream {
  var property cantSuscriptores

  var property hayFrenesi

  method cantSuscriptores(){
    if(hayFrenesi){
      return cantSuscriptores * 2
    }else{
      return cantSuscriptores
    }
  }

  override method cantViewers() {
    return (cantSuscriptores * 1.randomUpTo(3)).truncate(0)
  }


}
