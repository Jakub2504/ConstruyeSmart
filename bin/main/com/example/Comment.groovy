package com.example

class Comment {
    String content
    Date dateCreated
    Date lastUpdated
    User author
    Tutorial tutorial

    static constraints = {
        content blank: false, maxSize: 1000
        author nullable: false
        tutorial nullable: false
    }

    static mapping = {
        content type: 'text'
    }
} 