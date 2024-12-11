// ====================================| LA POROTA | ====================================

/* "La Porota" es una empresa de venta de porotos por peso, y nos pide un sistema para administrar su negocio tipo billetera virtual. "La Porota" tiene un stock 
de porotos y un precio por gramo. Los clientes tienen un único medio de pago (que puede variar en el tiempo) y que es el que usan al momento de realizar la 
compra en La Porota.

Existen por ahora 2 medios de pago (pueden haber más):
- Tarjeta de crédito: al pagar con crédito, aumenta la deuda de la tarjeta en el dinero correspondiente.
- Tarjeta de débito: al pagar con débito, se resta del dinero disponible el valor de la compra.

Hacer que la porota venda una cantidad de gramos de porotos a un cliente. Al hacerlo, debe disminuir el stock y el cliente pagar lo correspondiente.
Tests de una venta (pensar las clases de equivalencia).
Agregar los cupones, que son un medio de pago de un solo uso y con un monto máximo. No pueden usarse 2 veces, ni el monto de la venta puede superar su máximo. */

object laPorota {
  var property stockPorotos = 1000 
  const property precioXgramo = 250 

  method vender(gramos, cliente) {
    if (stockPorotos >= gramos) {
      stockPorotos -= gramos
      cliente.pagar(gramos * precioXgramo)
    } else{
      throw new ExcepcionStock(message= "No hay stock suficiente")
    }
  }
}

class ExcepcionStock inherits DomainException {}

class Cliente {
  var property medioDePago

  method pagar(monto) {
    medioDePago.utilizarMedio(monto)
  }
}

class TarjetaCredito {
  var property deuda

  method utilizarMedio(monto) {
    deuda += monto
  }
}

class TarjetaDebito {
  var property dineroDisponible

  method utilizarMedio(monto) {
    if (dineroDisponible < monto) {
      throw new ExcepcionDineroInsuficiente(message= "No hay dinero suficiente")
    } else {
      dineroDisponible -= monto
      }
    
  }
}

class ExcepcionDineroInsuficiente inherits DomainException {}

class Cupon {
  var tieneUso = true

  method tieneUso() {
    return tieneUso
  }

  const montoMaximo

  method verificarConsumo(monto) {
    if(montoMaximo >= monto) {
      tieneUso = false
    } else {
      throw new ExcepcionMontoMaximo(message= "El monto supera el maximo permitido")
    }
  }

  method utilizarMedio(monto) {
    if(tieneUso) {
      self.verificarConsumo(monto)
    } else {
      throw new ExcepcionUso(message= "El cupon ya fue utilizado")
    }
  }

}

class ExcepcionMontoMaximo inherits DomainException {}
class ExcepcionUso inherits DomainException {}