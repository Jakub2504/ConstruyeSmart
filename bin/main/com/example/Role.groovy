package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Role {
    ObjectId id
    String authority

    static mapping = {
        cache true
    }

    static constraints = {
        authority blank: false, unique: true
    }
} 