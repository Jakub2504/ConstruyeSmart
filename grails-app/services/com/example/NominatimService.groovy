package com.example

import groovy.json.JsonSlurper

class NominatimService {

    private static final String NOMINATIM_URL = 'https://nominatim.openstreetmap.org/search'

    def buscarTiendas(String nombre, String ciudad) {
        def urlStr = "https://nominatim.openstreetmap.org/search?q=${URLEncoder.encode(nombre + ' ' + ciudad, 'UTF-8')}&format=json&limit=3&addressdetails=1"
        def connection = new URL(urlStr).openConnection()
        connection.setRequestProperty("User-Agent", "ConstruyeSmart/1.0")

        def json = new JsonSlurper().parse(connection.inputStream)

        return json.collect {
            [
                    nombre   : nombre,
                    direccion: it.display_name,
                    lat      : it.lat,
                    lon      : it.lon
            ]
        }
    }

}
