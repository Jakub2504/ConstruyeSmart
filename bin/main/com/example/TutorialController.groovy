package com.example

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class TutorialController {
    def springSecurityService
    def apiIntegrationService

    def index() {
        def tutorials = Tutorial.list()
        [tutorials: tutorials]
    }

    def create() {
        [tutorial: new Tutorial()]
    }

    def save(Tutorial tutorial) {
        tutorial.author = springSecurityService.currentUser
        if (tutorial.save()) {
            flash.message = "Tutorial creado exitosamente"
            redirect action: "show", id: tutorial.id
        } else {
            render view: "create", model: [tutorial: tutorial]
        }
    }

    def show(Long id) {
        def tutorial = Tutorial.get(id)
        if (!tutorial) {
            flash.message = "Tutorial no encontrado"
            redirect action: "index"
            return
        }

        // Incrementar contador de vistas
        tutorial.views = (tutorial.views ?: 0) + 1
        tutorial.save()

        // Obtener videos relacionados de YouTube
        def relatedVideos = apiIntegrationService.getRelatedVideos(tutorial.title)

        [tutorial: tutorial, relatedVideos: relatedVideos]
    }

    def edit(Long id) {
        def tutorial = Tutorial.get(id)
        if (!tutorial) {
            flash.message = "Tutorial no encontrado"
            redirect action: "index"
            return
        }
        [tutorial: tutorial]
    }

    def update(Tutorial tutorial) {
        if (tutorial.save()) {
            flash.message = "Tutorial actualizado exitosamente"
            redirect action: "show", id: tutorial.id
        } else {
            render view: "edit", model: [tutorial: tutorial]
        }
    }

    def delete(Long id) {
        def tutorial = Tutorial.get(id)
        if (tutorial) {
            tutorial.delete()
            flash.message = "Tutorial eliminado exitosamente"
        } else {
            flash.message = "Tutorial no encontrado"
        }
        redirect action: "index"
    }

    def search() {
        def query = params.query
        def tutorials = Tutorial.createCriteria().list {
            or {
                ilike('title', "%${query}%")
                ilike('description', "%${query}%")
                ilike('tags', "%${query}%")
            }
        }
        render(view: "index", model: [tutorials: tutorials, query: query])
    }

    def rate(Long id) {
        def tutorial = Tutorial.get(id)
        if (tutorial) {
            def rating = params.int('rating')
            if (rating >= 1 && rating <= 5) {
                def currentRating = tutorial.rating ?: 0
                def currentCount = tutorial.ratingCount ?: 0
                
                tutorial.rating = ((currentRating * currentCount) + rating) / (currentCount + 1)
                tutorial.ratingCount = currentCount + 1
                
                if (tutorial.save()) {
                    flash.message = "Gracias por tu valoración"
                } else {
                    flash.message = "Error al guardar la valoración"
                }
            } else {
                flash.message = "Valoración inválida"
            }
        } else {
            flash.message = "Tutorial no encontrado"
        }
        redirect action: "show", id: id
    }

    def addStep(Long id) {
        def tutorial = Tutorial.get(id)
        if (tutorial) {
            def step = params.step
            if (step) {
                tutorial.steps = tutorial.steps ?: []
                tutorial.steps << step
                if (tutorial.save()) {
                    flash.message = "Paso añadido exitosamente"
                } else {
                    flash.message = "Error al añadir el paso"
                }
            }
        } else {
            flash.message = "Tutorial no encontrado"
        }
        redirect action: "show", id: id
    }
} 