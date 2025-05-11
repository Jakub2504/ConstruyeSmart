package com.example

class Tienda {
    String nombre
    String direccion
    Double latitud
    Double longitud
    String ciudad
    Date ultimaActualizacion = new Date()

    static constraints = {
        nombre nullable: false, blank: false
        direccion nullable: false, blank: false
        latitud nullable: false
        longitud nullable: false
        ciudad nullable: true
        ultimaActualizacion nullable: true
    }

    static mapping = {
        version false
        direccion type: 'text'
    }
}