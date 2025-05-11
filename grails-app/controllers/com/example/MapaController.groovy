package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON
import groovy.json.JsonBuilder

@Secured
class MapaController {

        def nominatimService

        def tiendas() {
            def ciudades = ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Zaragoza', 'Málaga', 'Murcia',
                            'Palma', 'Las Palmas de Gran Canaria', 'Bilbao', 'Alicante', 'Córdoba',
                            'Valladolid', 'Vigo', 'Gijón', 'A Coruña', 'Granada', 'Vitoria-Gasteiz',
                            'Elche', 'Oviedo', 'Badalona', 'Cartagena', 'Terrassa', 'Jerez de la Frontera',
                            'Sabadell', 'Móstoles', 'Santa Cruz de Tenerife', 'Pamplona', 'Almería',
                            'Santander', 'Castellón de la Plana', 'Burgos', 'Albacete', 'Alcalá de Henares',
                            'Getafe', 'Salamanca', 'Logroño', 'San Sebastián', 'Huelva', 'Lleida',
                            'Badajoz', 'Tarragona', 'León', 'Cádiz', 'Marbella', 'Jaén']

            def marcas = ['BigMat', 'Obramat', 'Bricomart', 'Bauhaus', 'Leroy Merlin', 'BricoDepot',
                          'La Plataforma de la Construcción', 'Grup Gamma', 'Isolana', 'BdB',
                          'Brico Depôt', 'Ferretería Ortiz', 'Almacenes Cámara', 'Ferrokey',
                          'Bricocentro', 'Punto Matéu', 'Disprofem', 'Saltoki', 'Fergon', 'Mas Obra']

            def resultados = []

            ciudades.each { ciudad ->
                marcas.each { marca ->
                    def tiendasEncontradas = nominatimService.buscarTiendas(marca, ciudad)
                    resultados += tiendasEncontradas.findAll {
                        it && it.nombre && it.lat && it.lon && it.direccion
                    }
                }
            }

            def tiendasJson = new JsonBuilder(resultados).toString()
            [tiendasJson: tiendasJson]

        }
    }

