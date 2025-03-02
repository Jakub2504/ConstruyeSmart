package com.example

import org.bson.types.ObjectId

class Game {
    ObjectId id
    Date dateCreated
    Date lastUpdated
    User user

    Choice userChoice
    Choice appChoice
    Boolean getIsWinner() {
        if(userChoice == null || appChoice == null) return null
        if(userChoice == Choice.PAPER) return appChoice in [Choice.ROCK, Choice.SPOCK]
        else if(userChoice == Choice.ROCK) return appChoice in [Choice.SCISSORS, Choice.LIZARD]
        else if(userChoice == Choice.SCISSORS) return appChoice in [Choice.PAPER, Choice.LIZARD]
        else if(userChoice == Choice.LIZARD) return appChoice in [Choice.PAPER, Choice.SPOCK]
        else return appChoice in [Choice.ROCK, Choice.SCISSORS]
    }

    static transients = ['isWinner']

    static constraints = {
        user nullable: false
        userChoice nullable: false
        appChoice nullable: false
    }
}

enum Choice {
    PAPER(1),
    ROCK(2),
    SCISSORS(3),
    LIZARD(4),
    SPOCK(5)

    private final Integer id
    private Choice(Integer id) { this.id = id }
    Integer id() { id }
}
