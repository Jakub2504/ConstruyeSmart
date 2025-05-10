package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Project {
    ObjectId id
    String name
    String description
    String status = 'PLANIFICACION' // PLANIFICACION, EN_PROGRESO, COMPLETADO, CANCELADO
    Date startDate
    Date estimatedEndDate
    Date actualEndDate
    BigDecimal budget
    BigDecimal actualCost
    String location
    String address
    Double latitude
    Double longitude
    String imageUrl
    
    static belongsTo = [user: User]
    static hasMany = [materials: ProjectMaterial, tasks: ProjectTask, notes: ProjectNote]
    
    static constraints = {
        name blank: false, maxSize: 100
        description nullable: true, maxSize: 1000
        status inList: ['PLANIFICACION', 'EN_PROGRESO', 'COMPLETADO', 'CANCELADO']
        startDate nullable: true
        estimatedEndDate nullable: true
        actualEndDate nullable: true
        budget nullable: true, min: 0.0
        actualCost nullable: true, min: 0.0
        location nullable: true
        address nullable: true
        latitude nullable: true
        longitude nullable: true
        imageUrl nullable: true, url: true
    }
    
    static mapping = {
        version false
    }
} 