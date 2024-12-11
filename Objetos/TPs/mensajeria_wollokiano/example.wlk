//SERVICIO DE MENSAJERIA ==========================================

class Mensaje {
  const property usuario

  const property contenido

  method peso() = 5 + contenido.peso() + 1.3

  method contieneTexto(_texto) = contenido.contieneTexto(_texto) || usuario == _texto
}

//CLASES TIPOS DE CONTENIDO-------------------------------------------------------------

class Contenido {
  method peso()

  method contieneTexto(_texto)
}

class Texto inherits Contenido {
  override method peso() = 1

  const property texto

  override method contieneTexto(_texto) = texto.contains(_texto)
}

class Audio inherits Contenido {
  var property segundos

  override method peso() = segundos * 1.2
  
}

class Imagen inherits Contenido {
  const pesoPixel = 2

  const property ancho

  const property alto

  const cantPixeles = ancho * alto

  var property tipoCompresion

  override method peso() = tipoCompresion.peso(cantPixeles * pesoPixel)
  
}

//CLASES TIPOS DE COMPRESION

class TipoCompresion {
  method peso(_peso)

}

object compresionOrig inherits TipoCompresion {
  override method peso(_peso) = _peso
}

class CompresionVar inherits TipoCompresion { 
  const property porcentajeCompresion 

  override method peso(_peso) = _peso * porcentajeCompresion
}

object compresionMax inherits TipoCompresion {
  const pesoMaximo = 10000

  override method peso(_peso) {
    if (_peso <= pesoMaximo) _peso else (_peso.min(pesoMaximo))
  }
}

class Gif inherits Imagen {

  const property cantCuadros

  override method peso() = super() * cantCuadros
  
}

class Contacto inherits Contenido {
  const property usuarioEnviado

  override method peso() = 3

  override  method contieneTexto(_texto) = _texto == usuarioEnviado
  
}

//CLASES CHATS-------------------------------------------------------------
class Chat {

  const property creador

  var property mensajes

  var property notificaciones

  method espacioOcupado() = mensajes.sum({mensaje => mensaje.peso()})

  method cantMensajes() = mensajes.size()

  method enviarMensaje(mensaje) = mensajes.add(mensaje)

  method mensajeMasPesado() = mensajes.max({mensaje => mensaje.peso()})

  method busqueda(_texto) = mensajes.filter({mensaje => mensaje.contieneTexto(_texto)})

  var property participantes

  var property tipoChat

  method puedeEnviarMensaje(chat, usuario, mensaje) = tipoChat.puedeEnviarMensaje(self, usuario, mensaje)

  method enviarMensaje(chat, usuario, mensaje) {
    if (self.puedeEnviarMensaje(self, usuario, mensaje)) {
      mensajes.add(mensaje)
      mensaje.usuario(usuario)
      self.notificaciones() + 1
      usuario.notificaciones() -1 //el que envia no debe acumular notis
    }
  }

  method leer() {
    self.notificaciones(0) 
  }

  
}

//CLASES TIPOS DE CHATS-------------------------------------------------------------


class TipoChat {


  method sePuedeAlmacenar(chat, mensaje) = chat.participantes().all({p => p.tieneEspacioLibre(Mensaje)})

  method emisorEsParticipante(chat, usuario) = chat.participantes().contains(usuario)

  method puedeEnviarMensaje(chat, usuario, mensaje) = self.emisorEsParticipante(chat, usuario) && self.sePuedeAlmacenar(chat, mensaje)

}

class Basico inherits TipoChat {

}

class Premium inherits TipoChat {
  var property restriccion

  override method puedeEnviarMensaje(chat, usuario, mensaje) = super(chat, usuario, mensaje) && restriccion.condicion(chat, usuario, mensaje)
}

//CLASES RESTRICCION-------------------------------------------------------------

class Restriccion {
  method condicion(chat, usuario, mensaje) 
}

object difusion inherits Restriccion{
  method emisorEsCreador(chat, usuario) = usuario == chat.creador()

  override method condicion(chat, usuario, _) = self.emisorEsCreador(chat, usuario)
}

class Restringido inherits Restriccion{

  const property limiteMensajes
  method dentroLimite(cantMensajes) = cantMensajes <= limiteMensajes

  override method condicion(chat, usuario, mensaje) {
    const cantidadAparente = chat.cantMensajes() + 1

    if(self.dentroLimite(cantidadAparente)){
      throw new DomainException(message = "No se puede enviar el mensaje")
    } 
    
  }
}

class Ahorro inherits Restriccion {
  const property pesoMaxMensaje

  override method condicion(chat, usuario, mensaje) = mensaje.peso() < pesoMaxMensaje
}

//CLASES USUARIO-------------------------------------------------------------

class Usuario {

  const espacioTotal 

  method espacioDisponible() {
    return espacioTotal - self.espacioOcupado()
  }

  method espacioOcupado() = chats.sum({chat => chat.espacioOcupado()})

  method tieneEspacioLibre(mensaje) = self.espacioDisponible() >= mensaje.peso()

  var property chats

  method notificaciones() = chats.sum({chat => chat.notificaciones()}) //notificaciones sin leer

  method mensajesMasPesado() = chats.map({chat => chat.mensajeMasPesado()})

  method realizarBusqueda(_texto) = chats.filter({chat => chat.busqueda(_texto)})

  method enviarMensaje(chat, mensaje) = chat.enviarMensaje(chat, self, mensaje)

  method leerChat(chat) = chat.leer()

  method crearChat(chat) {
    self.aniadirChat(chat)
    chat.creador(self)
  }

  method aniadirChat(chat) {
    chats.add(chat)
    chat.participantes().add(self)
  }
}