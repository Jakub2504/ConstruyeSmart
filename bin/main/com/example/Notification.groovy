package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class Notification {
    ObjectId id
    User recipient
    String type // 'comment', 'reply', 'update'
    String message
    boolean isRead = false
    Date dateCreated
    Map<String, Object> data = [:]

    static constraints = {
        recipient nullable: false
        type inList: ['comment', 'reply', 'update']
        message blank: false, maxSize: 500
        data nullable: true
    }

    static mapping = {
        collection "notifications"
    }
} 