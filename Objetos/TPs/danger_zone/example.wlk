object isis {
  var property ingresos = 0

  method lavanderia(_ingresos) {
    ingresos += _ingresos
  }

    method espiadero(_ingresos) {
    ingresos += _ingresos
  }

}

//CLASS EMPLEADO ===============================================

class Empleado {
  var property habilidades = #{} //

  var property salud //

  method saludCritica() = tipoEmpleado.saludCritica() 

  var property tipoEmpleado

  var property rango

  var property misionesCompletadas

  method esJefe()

  method estaVivo() = salud > 0

  method recibeDanio(_danio) {
    salud -= _danio
  }

  method estaIncapacitado() = salud < self.saludCritica() //

  method puedeUsarHabilidad(habilidad)

  method tieneHabilidad(habilidad) = habilidades.elem(habilidad)

  method sobreviveMision(mision) = tipoEmpleado.sobreviveMision(mision, self)

  method serEspia() {
    if(tipoEmpleado.puedeSerEspia()){
           tipoEmpleado = new Espia()
    }
  }
}

class Comun inherits Empleado{
  var property jefe

  override method puedeUsarHabilidad(habilidad) = not self.estaIncapacitado() && habilidades.contains(habilidad)

  override method esJefe() = false


}

class Jefe inherits Empleado{
  var property subordinados = #{}

  override method puedeUsarHabilidad(habilidad) = subordinados.any({s => s.puedeUsarHabilidad(habilidad)})

  override method esJefe() = true
  
}

//CLASS TIPO EMPLEADO =================================================
class TipoEmpleado {

  method completarMision(mision) {}

  method saludCritica() {}//

  method sobreviveMision(mision, empleado) {
      mision.quienesSobrevivieron().contains(empleado)
      empleado.misionesCompletadas().add(mision)

  }

  method puedeSerEspia() {}

}

class Espia inherits TipoEmpleado {

  override method saludCritica() = 15 //

  override method sobreviveMision(mision, empleado) {
    super(mision, empleado)
    var habilidadesDesconocidas = mision.habilidadesRequeridas().forEach({h => not  empleado.tieneHabilidad(h)})
    habilidadesDesconocidas.forEach({hd => empleado.habilidades().add(hd)})
  }

  override method puedeSerEspia() = true


}

class Oficinista inherits TipoEmpleado {
  var property estrellas //

  method ganaEstrella() { //
    estrellas += 1
  }

  override method saludCritica() = 40 - (5 * estrellas) //

  override method sobreviveMision(mision, empleado) {
    super(mision, empleado)
    self.ganaEstrella()
  }

  override method puedeSerEspia() = estrellas >= 3
 

  
}

//CLASS MISIONES =====================================================
class Mision {
  var property integrantes = tipoMision.integrantes() //

  method quienesSobrevivieron() = tipoMision.quienesSobrevivieron()//quienes completaron la mision

  const property habilidadesRequeridas = #{} //

  var property tipoMision

  var property peligro


  method jefeAsiste(empleado)  {
   if (not empleado.esJefe()){
   integrantes.add(empleado.jefe()) //
   tipoMision = misionGrupal //new misionGrupal()
   } 
  }

  method puedeCompletarMision() = tipoMision.puedeCompletarMision(self)

  method completaMision() = tipoMision.completarMision(self)
}

class TipoMision {

  var property integrantes = #{}

  method puedeCompletarMision(mision)

  method completarMision(mision)

  var property quienesSobrevivieron = #{}


}

object misionIndividual inherits TipoMision{
  override method integrantes() = integrantes.head()

  override method puedeCompletarMision(mision) = mision.habilidadesRequeridas().all({habilidad => integrantes.puedeUsarHabilidad(habilidad)})

  override method completarMision(mision) {
    if (self.puedeCompletarMision(mision)) {
      mision.integrantes().recibeDanio(mision.peligro())
      if (mision.integrantes().salud() > 0) self.quienesSobrevivieron().add(mision.integrantes())
    }
  }



}

object misionGrupal inherits TipoMision{

  override method puedeCompletarMision(mision) = mision.habilidadesRequeridas().all({habilidad => integrantes.any({i => i.puedeUsarHabilidad(habilidad)})})

  override method completarMision(mision) {
    if (self.puedeCompletarMision(mision)) {
      mision.integrantes().forEach({i => i.recibeDanio(mision.peligro() / 3)})
       quienesSobrevivieron = mision.integrantes().filter({i => mision.integrantes().salud() > 0})
      
    }
  }
  
}