package com.example

import grails.gorm.annotation.Entity

@Entity
class Exercise {
    String name
    String description
    Integer duration
    Integer caloriesBurned
    Date datePerformed
    User user

    static constraints = {
        name blank: false
        description nullable: true
        duration min: 1
        caloriesBurned min: 0
        datePerformed nullable: false
        user nullable: false
    }

    static mapping = {
        user lazy: false
    }
} 