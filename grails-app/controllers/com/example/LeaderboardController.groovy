package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured('ROLE_USER')
class LeaderboardController {

    LeaderboardService leaderboardService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond leaderboardService.list(params), model:[leaderboardCount: leaderboardService.count()]
    }

    def show(String id) {
        Leaderboard leaderboard = Leaderboard.get(id)
        respond leaderboard
    }

    def triarOpcio() {
        println params['op']
        redirect action: "index"
    }

    def create() {
        respond new Leaderboard(params)
    }

    def save(Leaderboard leaderboard) {
        if (leaderboard == null) {
            notFound()
            return
        }

        try {
            leaderboardService.save(leaderboard)
        } catch (ValidationException e) {
            respond leaderboard.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'leaderboard.label', default: 'Leaderboard'), leaderboard.id])
                redirect leaderboard
            }
            '*' { respond leaderboard, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond leaderboardService.get(id)
    }

    def update(Leaderboard leaderboard) {
        if (leaderboard == null) {
            notFound()
            return
        }

        try {
            leaderboardService.save(leaderboard)
        } catch (ValidationException e) {
            respond leaderboard.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'leaderboard.label', default: 'Leaderboard'), leaderboard.id])
                redirect leaderboard
            }
            '*'{ respond leaderboard, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        leaderboardService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'leaderboard.label', default: 'Leaderboard'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'leaderboard.label', default: 'Leaderboard'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
