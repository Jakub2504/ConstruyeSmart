package com.example

import groovy.json.JsonSlurper

class NominatimService {

    private static final String NOMINATIM_URL = 'https://nominatim.openstreetmap.org/search'

    def buscarTiendas(String nombreTienda, String ciudad) {
        def query = URLEncoder.encode("${nombreTienda} ${ciudad}", "UTF-8")
        def urlStr = "${NOMINATIM_URL}?q=${query}&format=json&limit=3&addressdetails=1"

        def connection = new URL(urlStr).openConnection()
        connection.setRequestProperty("User-Agent", "ConstruyeSmart/1.0")


        def json = new JsonSlurper().parse(connection.getInputStream())

        return json
                .findAll { it?.lat && it?.lon && it?.display_name }
                .collect {
                    [
                            nombre   : "${nombreTienda} - ${ciudad}",
                            lat      : it.lat as Double,
                            lon      : it.lon as Double,
                            direccion: it.display_name
                    ]
                }

    }
}
