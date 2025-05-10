package com.example

import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper
import org.springframework.beans.factory.annotation.Value

@Transactional
class ApiIntegrationService {

    @Value('${google.maps.api.key}')
    String googleMapsApiKey

    @Value('${openweathermap.api.key}')
    String openWeatherMapApiKey

    @Value('${youtube.api.key}')
    String youtubeApiKey

    @Value('${home.depot.api.key}')
    String homeDepotApiKey

    def getNearbyHardwareStores(String location) {
        try {
            def url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location}&radius=5000&type=hardware_store&key=${googleMapsApiKey}"
            def response = new URL(url).text
            def json = new JsonSlurper().parseText(response)
            return json.results.collect { store ->
                [
                    name: store.name,
                    address: store.vicinity,
                    rating: store.rating,
                    location: [store.geometry.location.lat, store.geometry.location.lng]
                ]
            }
        } catch (Exception e) {
            log.error("Error al obtener tiendas cercanas: ${e.message}")
            return []
        }
    }

    def getWeatherForecast(String location) {
        try {
            def url = "https://api.openweathermap.org/data/2.5/forecast?q=${location}&appid=${openWeatherMapApiKey}&units=metric&lang=es"
            def response = new URL(url).text
            def json = new JsonSlurper().parseText(response)
            return json.list.collect { forecast ->
                [
                    date: new Date(forecast.dt * 1000),
                    temperature: forecast.main.temp,
                    description: forecast.weather[0].description,
                    icon: forecast.weather[0].icon
                ]
            }
        } catch (Exception e) {
            log.error("Error al obtener el pronóstico del tiempo: ${e.message}")
            return []
        }
    }

    def searchTutorialVideos(String query) {
        try {
            def url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=${query}&type=video&key=${youtubeApiKey}&maxResults=5"
            def response = new URL(url).text
            def json = new JsonSlurper().parseText(response)
            return json.items.collect { video ->
                [
                    title: video.snippet.title,
                    description: video.snippet.description,
                    thumbnail: video.snippet.thumbnails.default.url,
                    videoId: video.id.videoId
                ]
            }
        } catch (Exception e) {
            log.error("Error al buscar videos tutoriales: ${e.message}")
            return []
        }
    }

    def getMaterialPrices(String materialName) {
        try {
            def url = "https://api.homedepot.com/v1/products/search?query=${materialName}&key=${homeDepotApiKey}"
            def response = new URL(url).text
            def json = new JsonSlurper().parseText(response)
            return json.products.collect { product ->
                [
                    name: product.name,
                    price: product.price,
                    store: product.store,
                    availability: product.availability
                ]
            }
        } catch (Exception e) {
            log.error("Error al obtener precios de materiales: ${e.message}")
            return []
        }
    }

    def getToolRentalLocations(String toolName, String location) {
        try {
            def url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location}&radius=5000&keyword=${toolName}+rental&key=${googleMapsApiKey}"
            def response = new URL(url).text
            def json = new JsonSlurper().parseText(response)
            return json.results.collect { place ->
                [
                    name: place.name,
                    address: place.vicinity,
                    rating: place.rating,
                    location: [place.geometry.location.lat, place.geometry.location.lng]
                ]
            }
        } catch (Exception e) {
            log.error("Error al obtener ubicaciones de alquiler: ${e.message}")
            return []
        }
    }
} 