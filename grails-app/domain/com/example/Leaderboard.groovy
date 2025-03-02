package com.example

import org.bson.types.ObjectId

class Leaderboard {
    ObjectId id
    Date dateCreated
    Date lastUpdated
    User user
    Integer score

    static constraints = {
        user nullable: false
        score nullable: false, min: 0
    }
}
