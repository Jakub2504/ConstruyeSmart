package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Tool {
    ObjectId id
    String name
    String category // Manual, Eléctrica, Medición, etc.
    String description
    String usageInstructions
    String safetyInstructions
    String imageUrl
    Boolean availableForRent
    Double rentalPricePerDay
    String rentalStore
    String rentalLocation

    static constraints = {
        name blank: false, maxSize: 100
        category blank: false
        description maxSize: 500
        usageInstructions maxSize: 1000
        safetyInstructions maxSize: 1000
        imageUrl nullable: true, url: true
        rentalPricePerDay nullable: true, min: 0.0
        rentalStore nullable: true
        rentalLocation nullable: true
    }

    static mapping = {
        collection "tools"
    }
} 