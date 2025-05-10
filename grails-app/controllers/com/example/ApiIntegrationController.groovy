package com.example

class ApiIntegrationController {
    def apiIntegrationService

    def getNearbyHardwareStores() {
        def location = params.location
        def stores = apiIntegrationService.getNearbyHardwareStores(location)
        render(contentType: "application/json") {
            stores
        }
    }

    def getWeatherForecast() {
        def location = params.location
        def forecast = apiIntegrationService.getWeatherForecast(location)
        render(contentType: "application/json") {
            forecast
        }
    }

    def searchTutorialVideos() {
        def query = params.query
        def videos = apiIntegrationService.searchTutorialVideos(query)
        render(contentType: "application/json") {
            videos
        }
    }

    def getMaterialPrices() {
        def materialName = params.materialName
        def prices = apiIntegrationService.getMaterialPrices(materialName)
        render(contentType: "application/json") {
            prices
        }
    }

    def getToolRentalLocations() {
        def toolName = params.toolName
        def location = params.location
        def locations = apiIntegrationService.getToolRentalLocations(toolName, location)
        render(contentType: "application/json") {
            locations
        }
    }
} 