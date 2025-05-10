package com.example

import grails.gorm.annotation.Entity

@Entity
class Goal {
    String title
    String description
    Date startDate
    Date targetDate
    Boolean completed = false
    User user

    static constraints = {
        title blank: false
        description nullable: true
        startDate nullable: false
        targetDate nullable: false
        completed nullable: false
        user nullable: false
    }

    static mapping = {
        user lazy: false
    }
} 