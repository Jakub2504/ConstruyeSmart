package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class ProjectNote {
    ObjectId id
    String title
    String content
    Date dateCreated = new Date()
    String category // GENERAL, PROBLEMA, SOLUCION, IDEA
    String priority // BAJA, MEDIA, ALTA
    Boolean isImportant = false
    
    static belongsTo = [project: Project]
    
    static constraints = {
        title blank: false, maxSize: 100
        content blank: false, maxSize: 2000
        category inList: ['GENERAL', 'PROBLEMA', 'SOLUCION', 'IDEA']
        priority nullable: true, inList: ['BAJA', 'MEDIA', 'ALTA']
    }
    
    static mapping = {
        version false
    }
} 