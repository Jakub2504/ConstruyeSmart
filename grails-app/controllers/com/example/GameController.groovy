package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class GameController {

    GameService gameService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond gameService.list(params), model:[gameCount: gameService.count()]
    }

    def show(String id) {
        respond gameService.get(id)
    }

    @Secured('ROLE_USER')
    def create() {
        respond new Game(params)
    }

    @Secured('ROLE_USER')
    def save(Game game) {
        if (game == null) {
            notFound()
            return
        }

        println "Current user: "
        game.user = (User) springSecurityService.currentUser
        println game.user

        Random rand = new Random()
        Integer c =  rand.nextInt(5)
        game.appChoice = Choice.values()[c]
        println "User has selected ${game.userChoice}"
        println "App has selected ${game.appChoice}"
        println "Player wins? ${game.isWinner}"

        withForm {
            try {
                game.save(flush: true, failOnError: true)
            } catch (ValidationException e) {
                respond game.errors, view:'create'
                return
            }
        }.invalidToken {
            redirect action: "create"
            return
        }

        redirect controller: "game", action: "index"
        return
    }

    def edit(String id) {
        respond gameService.get(id)
    }

    def update(Game game) {
        if (game == null) {
            notFound()
            return
        }

        try {
            gameService.save(game)
        } catch (ValidationException e) {
            respond game.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'game.label', default: 'Game'), game.id])
                redirect game
            }
            '*'{ respond game, [status: OK] }
        }
    }

    def delete(String id) {
        if (id == null) {
            notFound()
            return
        }

        gameService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'game.label', default: 'Game'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'game.label', default: 'Game'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
