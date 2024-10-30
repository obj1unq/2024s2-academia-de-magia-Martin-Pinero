class Academia {

    const property muebles = #{}

    method estaGuardado(cosa){
        return muebles.any({mueble => mueble.tieneGuardado(cosa)})
    }

    method muebleDondeSeGuardo(cosa){
        return muebles.find({mueble => mueble.tieneGuardado(cosa)})
    }

    method sePuedeGuardar(cosa){
        return !self.estaGuardado(cosa) && self.hayMuebleParaGuardar(cosa)
    }

    method hayMuebleParaGuardar(cosa){
        return muebles.any({mueble => mueble.sePuedeGuardarAca(cosa)})
    }

    method mueblesDondeSePuedeGuardar(cosa){
        return muebles.filter({mueble => mueble.sePuedeGuardarAca(cosa)})
    }

    method guardar(cosa){
        self.validarGuardar(cosa)
        self.mueblesDondeSePuedeGuardar(cosa).anyOne().agregar(cosa)
    }

    method validarGuardar(cosa){
        if (not self.sePuedeGuardar(cosa)){
            self.error("No se puede guardar el/la" + cosa)
        }
    }

   
}

class Mueble {

    const property cosas = #{}

    method tieneGuardado(cosa){
        return cosas.contains(cosa)
    }

    method sePuedeGuardarAca(cosa)
    
    method agregar(cosa){
        cosas.add(cosa)
    }

    method utilidad(){
        return self.utilidadDeLasCosas()  / self.precio()
    }

    method utilidadDeLasCosas(){
        return cosas.sum({cosa => cosa.utilidad()})
    }

    method precio()

}

class Baul inherits Mueble {
    const volumenMaximo

    override method sePuedeGuardarAca(cosa){
        return self.volumenOcupado() + cosa.volumen() <= volumenMaximo
    }

    method volumenOcupado(){
        return cosas.sum({cosa => cosa.volumen()})
    }

    override method precio(){
        return volumenMaximo + 2
    }

    override method utilidad(){
        return super() + self.extraSiReliquias()
    }

    method extraSiReliquias(){
        return if (cosas.all({cosa => cosa.esReliquia()})) 2 else 0
    }


}

class GabineteMagico inherits Mueble {
    
    const property precio

    override method sePuedeGuardarAca(cosa){
        return cosa.esMagico()
    }
}

class ArmarioConvencional inherits Mueble {
    var cantidadMaxima

    override method sePuedeGuardarAca(cosa){
        return cosas.size() < cantidadMaxima
    }

    method cantidadMaxima(_cantidadMaxima){ // se agrega el setter para el test
        cantidadMaxima = _cantidadMaxima
    }

    override method precio(){
        return cantidadMaxima *5
    }

}

class Cosa {
    const marca
    const property volumen
    const property esMagico
    const property esReliquia

    method utilidad(){
        return volumen + self.utilidadPorMagia() + self.utilidadPorReliquia() + marca.utilidad(self)
    }

    method utilidadPorMagia() {
        return if (esMagico) 3 else 0
    }

    method utilidadPorReliquia(){
        return if (esReliquia) 5 else 0
    }

}

object cuchuflito {

    method utilidad(cosa){
        return 0
    }

}

object acme {

    method utilidad(cosa){
        return cosa.volumen() / 2
    }
}

object fenix {
    
    method utilidad(cosa){
        return if (cosa.esReliquia()) 3 else 0
    }

}