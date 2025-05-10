package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class ProjectTask {
    ObjectId id
    String name
    String description
    String status = 'PENDIENTE' // PENDIENTE, EN_PROGRESO, COMPLETADA
    Integer priority = 1 // 1: Baja, 2: Media, 3: Alta
    Date startDate
    Date estimatedEndDate
    Date actualEndDate
    Integer estimatedHours
    Integer actualHours
    String assignedTo
    String notes
    
    static belongsTo = [project: Project]
    
    static constraints = {
        name blank: false, maxSize: 100
        description nullable: true, maxSize: 500
        status inList: ['PENDIENTE', 'EN_PROGRESO', 'COMPLETADA']
        priority inList: [1, 2, 3]
        startDate nullable: true
        estimatedEndDate nullable: true
        actualEndDate nullable: true
        estimatedHours min: 0
        actualHours min: 0
        assignedTo nullable: true
        notes nullable: true, maxSize: 1000
    }
    
    static mapping = {
        version false
    }
} 