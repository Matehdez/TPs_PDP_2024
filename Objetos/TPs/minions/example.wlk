// PARCIAL MINIONS ========================================================================================================

/* DOMINIO DEL PROBLEMA 

1 Científico 
Muchos empleados

Clase empleado
- Biciclopes
- Ciclopes


- ROL
  - Soldado
  - Obrero
  - Mucama

- REALIZAR TAREA
  - Arreglar una maquina
  - Defender un sector
  - Limpiar un Sector

*/

// Empleado -----------------------------------------------------------------
class Empleado {
  var stamina
  var habilidadArma //cuantos disparos puede acertar un minion

  method fuerza() = rol.fuerza(self)

  var property rol

  method equipamento() = rol.equipamento()

  method stamina(_stamina) {
    stamina  = _stamina
  }

  method habilidadArma (_habilidadArma) {
    habilidadArma = _habilidadArma
  }

  method puedeRealizar(tarea) = tarea.requisito(self)

  method realizarTarea(tarea) = tarea.realizarTarea(self)

}

class Biclope inherits Empleado {
  override method stamina(_stamina){
    stamina =  _stamina.min(10)
  }

}

class Ciclope inherits Empleado{
  override method habilidadArma (_habilidadArma) {
    super(_habilidadArma) /2
  }

  override method fuerza () = super() /2
  
}

//ROLES ---------------------------------------------------------------------------

class Rol {
  var equipamento = [] //Armas / Herramientas

  var fuerza

  method fuerza(empleado) {
    return empleado.stamina() +2
  }

  method equipamento (_equipamento) {
    equipamento = _equipamento
  }

  method equipamento() {
  return equipamento
  }

  method puedeDefenderSector()

  method defiendeSector() {}
}

class Soldado inherits Rol{

  var property practicas

  override method fuerza(empleado) {
    return super(empleado) + (practicas*2)
  }

  override method puedeDefenderSector() = true

  method arma() = equipamento.head()

  override method defiendeSector() {
    practicas += 1
    self.arma().danio(self.arma().danio() + 2)
    
  }


}

class Arma {
  var property danio
}

class Obrero inherits Rol{
  override method puedeDefenderSector() = true

  
}

class Mucama inherits Rol{
  override method equipamento () {
  return null
  }

  override method puedeDefenderSector() = false

}

//Tarea ----------------------------------------------------------
class Tarea {

  method requisito() 

  method dificultad()

  method requisito(empleado)

  method realizarTarea(empleado)

}

class ArreglarMaquina inherits Tarea {

  const property maquina

  method requisitosHerramientas() = maquina.requisitosHerramientas()

  method staminaRequerida() = maquina.complejidad()


  override method requisito(empleado) = empleado.stamina() == self.staminaRequerida() && empleado.equipamiento().forEach({herramienta => self.requisitosHerramientas().contains(herramienta)})

  override method realizarTarea(empleado) = empleado.stamina(self.staminaRequerida())
  
}

class Maquina {

  const property complejidad

  method requisitosHerramientas() = []

  method complejidad() = complejidad
}

class DefenderSector inherits Tarea {

  const property gradoAmenaza


  override method requisito(empleado) = empleado.rol().puedeDefenderSector() && empleado.fuerza() >= gradoAmenaza

  override method realizarTarea(empleado) = empleado.rol().defiendeSector()
  
  
}