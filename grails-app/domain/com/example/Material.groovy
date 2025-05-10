package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Material {
    ObjectId id
    String name
    String category // Madera, Metal, Pintura, etc.
    String description
    String unit // kg, m, l, etc.
    Double pricePerUnit
    String store
    String location
    String brand
    String specifications
    String imageUrl

    static constraints = {
        name blank: false, maxSize: 100
        category blank: false
        description maxSize: 500
        unit blank: false
        pricePerUnit min: 0.0
        store nullable: true
        location nullable: true
        brand nullable: true
        specifications nullable: true
        imageUrl nullable: true, url: true
    }

    static mapping = {
        collection "materials"
    }
} 