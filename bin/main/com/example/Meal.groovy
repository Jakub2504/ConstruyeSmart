package com.example

import grails.gorm.annotation.Entity

@Entity
class Meal {
    String name
    String description
    Integer calories
    Date dateConsumed
    User user

    static constraints = {
        name blank: false
        description nullable: true
        calories min: 0
        dateConsumed nullable: false
        user nullable: false
    }

    static mapping = {
        user lazy: false
    }
} 