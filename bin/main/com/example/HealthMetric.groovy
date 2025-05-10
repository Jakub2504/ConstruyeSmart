package com.example

import grails.gorm.annotation.Entity

@Entity
class HealthMetric {
    String type
    Double value
    String unit
    Date dateRecorded
    String notes
    User user

    static constraints = {
        type blank: false
        value nullable: false
        unit blank: false
        dateRecorded nullable: false
        notes nullable: true
        user nullable: false
    }

    static mapping = {
        user lazy: false
    }
} 