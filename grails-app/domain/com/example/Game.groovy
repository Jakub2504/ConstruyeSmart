package com.example

import org.bson.types.ObjectId

class Game {
    ObjectId id
    Date dateCreated
    Date lastUpdated
    User user

    Choice userChoice
    Choice appChoice
    GameResult getIsWinner() {
        if(userChoice == null || appChoice == null) return null
        if(userChoice == appChoice) return GameResult.DRAW
        else if(userChoice == Choice.PAPER) return appChoice in [Choice.ROCK, Choice.SPOCK] ? GameResult.WIN : GameResult.LOSE
        else if(userChoice == Choice.ROCK) return appChoice in [Choice.SCISSORS, Choice.LIZARD] ? GameResult.WIN : GameResult.LOSE
        else if(userChoice == Choice.SCISSORS) return appChoice in [Choice.PAPER, Choice.LIZARD] ? GameResult.WIN : GameResult.LOSE
        else if(userChoice == Choice.LIZARD) return appChoice in [Choice.PAPER, Choice.SPOCK] ? GameResult.WIN : GameResult.LOSE
        else return appChoice in [Choice.ROCK, Choice.SCISSORS] ? GameResult.WIN : GameResult.LOSE
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

enum GameResult {
    LOSE(0),
    WIN(1),
    DRAW(2)

    private final Integer id
    private GameResult(Integer id) { this.id = id }
    Integer id() { id }
}
