package com.example

import grails.converters.JSON
import groovy.json.JsonBuilder

class MapaController {

    def nominatimService

    def tiendas() {
        def ciudades = ['Madrid', 'Barcelona', 'Valencia']
        def marcas = ['Obramat', 'BigMat']

        def resultados = []

        ciudades.each { ciudad ->
            marcas.each { marca ->
                def tiendasEncontradas = nominatimService.buscarTiendas(marca, ciudad)
                resultados += tiendasEncontradas.findAll {
                    it?.lat && it?.lon && it?.nombre
                }
            }
        }

        def tiendasJson = new JsonBuilder(resultados).toString()
        [tiendasJson: tiendasJson]
    }
}
