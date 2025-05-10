package com.example

class CommentController {
    def springSecurityService

    def save(Long tutorialId) {
        def tutorial = Tutorial.get(tutorialId)
        if (!tutorial) {
            flash.message = "Tutorial no encontrado"
            redirect controller: "tutorial", action: "index"
            return
        }

        if (!tutorial.allowComments) {
            flash.message = "Los comentarios no están permitidos en este tutorial"
            redirect controller: "tutorial", action: "show", id: tutorialId
            return
        }

        def comment = new Comment(
            content: params.content,
            author: springSecurityService.currentUser,
            tutorial: tutorial
        )

        if (comment.save()) {
            // Crear notificación para el autor del tutorial
            if (tutorial.author != springSecurityService.currentUser) {
                new Notification(
                    recipient: tutorial.author,
                    type: 'comment',
                    message: "${springSecurityService.currentUser.username} ha comentado en tu tutorial '${tutorial.title}'",
                    data: [tutorialId: tutorial.id, commentId: comment.id]
                ).save()
            }

            flash.message = "Comentario publicado exitosamente"
        } else {
            flash.message = "Error al publicar el comentario"
        }

        redirect controller: "tutorial", action: "show", id: tutorialId
    }

    def delete(Long id) {
        def comment = Comment.get(id)
        if (comment) {
            def tutorialId = comment.tutorial.id
            if (comment.author == springSecurityService.currentUser || 
                comment.tutorial.author == springSecurityService.currentUser) {
                comment.delete()
                flash.message = "Comentario eliminado exitosamente"
            } else {
                flash.message = "No tienes permiso para eliminar este comentario"
            }
            redirect controller: "tutorial", action: "show", id: tutorialId
        } else {
            flash.message = "Comentario no encontrado"
            redirect controller: "tutorial", action: "index"
        }
    }

    def edit(Long id) {
        def comment = Comment.get(id)
        if (!comment) {
            flash.message = "Comentario no encontrado"
            redirect controller: "tutorial", action: "index"
            return
        }

        if (comment.author != springSecurityService.currentUser) {
            flash.message = "No tienes permiso para editar este comentario"
            redirect controller: "tutorial", action: "show", id: comment.tutorial.id
            return
        }

        [comment: comment]
    }

    def update(Long id) {
        def comment = Comment.get(id)
        if (!comment) {
            flash.message = "Comentario no encontrado"
            redirect controller: "tutorial", action: "index"
            return
        }

        if (comment.author != springSecurityService.currentUser) {
            flash.message = "No tienes permiso para editar este comentario"
            redirect controller: "tutorial", action: "show", id: comment.tutorial.id
            return
        }

        comment.content = params.content
        if (comment.save()) {
            flash.message = "Comentario actualizado exitosamente"
        } else {
            flash.message = "Error al actualizar el comentario"
        }

        redirect controller: "tutorial", action: "show", id: comment.tutorial.id
    }
} 