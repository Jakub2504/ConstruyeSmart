package com.example

class FavoriteController {
    def springSecurityService

    def toggle(Long tutorialId) {
        def tutorial = Tutorial.get(tutorialId)
        if (!tutorial) {
            flash.message = "Tutorial no encontrado"
            redirect controller: "tutorial", action: "index"
            return
        }

        def user = springSecurityService.currentUser
        def favorite = Favorite.findByUserAndTutorial(user, tutorial)

        if (favorite) {
            favorite.delete()
            flash.message = "Tutorial eliminado de favoritos"
        } else {
            new Favorite(user: user, tutorial: tutorial).save()
            flash.message = "Tutorial añadido a favoritos"
        }

        redirect controller: "tutorial", action: "show", id: tutorialId
    }

    def index() {
        def user = springSecurityService.currentUser
        def favorites = Favorite.findAllByUser(user, [sort: "dateCreated", order: "desc"])
        [favorites: favorites]
    }
} 