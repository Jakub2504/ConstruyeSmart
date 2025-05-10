package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Favorite {
    ObjectId id
    User user
    Tutorial tutorial
    Date dateCreated

    static constraints = {
        user nullable: false
        tutorial nullable: false
    }

    static mapping = {
        collection "favorites"
    }
} 