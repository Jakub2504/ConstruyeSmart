package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Tutorial {
    ObjectId id
    String title
    String description
    String difficultyLevel // Básico, Intermedio, Avanzado
    Integer estimatedTime // en minutos
    List<String> requiredTools = []
    List<String> requiredMaterials = []
    List<String> steps = []
    String videoUrl
    String imageUrl
    Integer views = 0
    Float rating = 0.0
    Integer ratingCount = 0
    List<String> tags = []
    User author
    boolean isPublic = true
    boolean allowComments = true
    Date dateCreated
    Date lastUpdated

    static hasMany = [comments: Comment]

    static constraints = {
        title blank: false, maxSize: 200
        description maxSize: 1000
        difficultyLevel inList: ['Básico', 'Intermedio', 'Avanzado']
        estimatedTime min: 0
        videoUrl nullable: true, url: true
        imageUrl nullable: true, url: true
        rating nullable: true, min: 0f, max: 5f
        ratingCount min: 0
        requiredMaterials nullable: true
        requiredTools nullable: true
        steps nullable: false
        tags nullable: true
        author nullable: false
    }

    static mapping = {
        collection "tutorials"
        description type: 'text'
        requiredMaterials type: 'text'
        requiredTools type: 'text'
        steps type: 'text'
        tags type: 'text'
    }
} 