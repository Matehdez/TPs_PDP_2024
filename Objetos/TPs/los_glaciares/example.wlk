object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

class Glaciar {
  const property lugarDesemboca //puede ser glaciar o masa de agua

  var masa

  method nevada(_masa) {
    masa += _masa
  }

  method caeTempano(_masa) {
    masa -= _masa
  }

}

class Tempano {
  var property tipo
}

class TipoTempano{
  method parteVisible()
}