package com.example

import grails.converters.JSON
import java.text.SimpleDateFormat
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class PlannerController {
    def springSecurityService

    def index() {
        def sortBy = params.sort ?: 'dateCreated'
        def order = params.order ?: 'desc'
        def status = params.status
        def priority = params.priority

        def tasks = Task.createCriteria().list {
            if (status) {
                eq('status', status)
            }
            if (projectId) {
                project {
                    eq('id', projectId.toLong()) // Asociación con proyecto
                }
            }
            order(sortBy, order) // Ordenar de forma segura
        }

        // Ordenar la lista después de obtenerla
        if (sortBy) {
            tasks = tasks.sort { a, b ->
                def aValue = a[sortBy]
                def bValue = b[sortBy]
                if (order == 'desc') {
                    return bValue <=> aValue
                } else {
                    return aValue <=> bValue
                }
            }
        }
        
        def statuses = ['Pendiente', 'En Progreso', 'Completada', 'Cancelada']
        def priorities = ['Baja', 'Media', 'Alta', 'Urgente']
        
        [tasks: tasks, 
         statuses: statuses, 
         priorities: priorities,
         currentSort: sortBy,
         currentOrder: order,
         currentStatus: status,
         currentPriority: priority]
    }

    def getTask() {
        def task = Task.get(params.id)
        if (task) {
            def taskData = [
                id: task.id,
                name: task.name,
                description: task.description,
                startDate: task.startDate?.format('yyyy-MM-dd'),
                endDate: task.endDate?.format('yyyy-MM-dd'),
                status: task.status,
                priority: task.priority
            ]
            render taskData as JSON
        } else {
            render(status: 404, [error: 'Tarea no encontrada'] as JSON)
        }
    }

    def quickUpdate() {
        try {
            def task = Task.get(params.id)
            if (!task) {
                render(status: 404, [error: 'Tarea no encontrada'] as JSON)
                return
            }

            if (params.status) {
                task.status = params.status
            }
            if (params.priority) {
                task.priority = params.priority
            }
            if (params.startDate) {
                task.startDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.startDate)
            }
            if (params.endDate) {
                task.endDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.endDate)
            }

            if (task.save()) {
                render([success: true, message: 'Tarea actualizada exitosamente'] as JSON)
            } else {
                render(status: 400, [error: 'Error al actualizar la tarea'] as JSON)
            }
        } catch (Exception e) {
            log.error("Error en actualización rápida: ${e.message}", e)
            render(status: 500, [error: 'Error al actualizar la tarea'] as JSON)
        }
    }

    def save() {
        try {
            def json = request.JSON
            if (!json.name?.trim()) {
                render(status: 400, [error: "El nombre de la tarea es requerido"] as JSON)
                return
            }

            def dateFormat = new SimpleDateFormat("yyyy-MM-dd")
            def startDate = json.startDate ? dateFormat.parse(json.startDate) : null
            def endDate = json.endDate ? dateFormat.parse(json.endDate) : null

            def task = new Task(
                name: json.name.trim(),
                description: json.description?.trim(),
                startDate: startDate,
                endDate: endDate,
                status: json.status ?: 'Pendiente',
                priority: json.priority ?: 'Media',
                user: springSecurityService.currentUser
            )

            if (task.startDate && task.endDate && task.endDate < task.startDate) {
                render(status: 400, [error: "La fecha de fin debe ser posterior a la fecha de inicio"] as JSON)
                return
            }

            if (!task.validate()) {
                render(status: 400, [error: "Error al crear la tarea: " + task.errors.allErrors.collect { it.defaultMessage }.join(", ")] as JSON)
                return
            }

            if (task.save()) {
                render([success: true, message: "Tarea creada exitosamente"] as JSON)
            } else {
                render(status: 400, [error: "Error al crear la tarea"] as JSON)
            }
        } catch (Exception e) {
            log.error("Error al crear tarea: ${e.message}", e)
            render(status: 500, [error: "Error al crear la tarea: ${e.message}"] as JSON)
        }
    }

    def update() {
        try {
            def task = Task.get(params.id)
            if (!task) {
                flash.error = "Tarea no encontrada"
                return redirect(action: "index")
            }

            if (!params.name?.trim()) {
                flash.error = "El nombre de la tarea es requerido"
                return redirect(action: "index")
            }

            def dateFormat = new SimpleDateFormat("yyyy-MM-dd")
            def startDate = params.startDate ? dateFormat.parse(params.startDate) : null
            def endDate = params.endDate ? dateFormat.parse(params.endDate) : null

            task.properties = [
                name: params.name.trim(),
                description: params.description?.trim(),
                startDate: startDate,
                endDate: endDate,
                status: params.status,
                priority: params.priority
            ]

            if (task.startDate && task.endDate && task.endDate < task.startDate) {
                flash.error = "La fecha de fin debe ser posterior a la fecha de inicio"
                return redirect(action: "index")
            }

            if (!task.validate()) {
                flash.error = "Error al actualizar la tarea: " + task.errors.allErrors.collect { it.defaultMessage }.join(", ")
                return redirect(action: "index")
            }

            if (task.save()) {
                flash.message = "Tarea actualizada exitosamente"
            } else {
                flash.error = "Error al actualizar la tarea"
            }
        } catch (Exception e) {
            log.error("Error al actualizar tarea: ${e.message}", e)
            flash.error = "Error al actualizar la tarea: ${e.message}"
        }
        redirect(action: "index")
    }

    def delete() {
        try {
            def json = request.JSON
            def task = Task.get(json.id)
            if (!task) {
                render([success: false, error: "Tarea no encontrada"] as JSON)
                return
            }

            task.delete(flush: true)
            render([success: true, message: "Tarea eliminada exitosamente"] as JSON)
        } catch (Exception e) {
            log.error("Error al eliminar tarea: ${e.message}", e)
            render([success: false, error: "Error al eliminar la tarea"] as JSON)
        }
    }

    def bulkUpdate() {
        try {
            def taskIds = params.list('taskIds')
            def status = params.status
            def priority = params.priority

            if (!taskIds) {
                render(status: 400, [error: 'No se seleccionaron tareas'] as JSON)
                return
            }

            def updatedCount = 0
            taskIds.each { id ->
                def task = Task.get(id)
                if (task) {
                    if (status) task.status = status
                    if (priority) task.priority = priority
                    if (task.save()) updatedCount++
                }
            }

            render([success: true, message: "${updatedCount} tareas actualizadas"] as JSON)
        } catch (Exception e) {
            log.error("Error en actualización masiva: ${e.message}", e)
            render(status: 500, [error: 'Error al actualizar las tareas'] as JSON)
        }
    }

    def bulkDelete() {
        def json = request.JSON
        def taskIds = json.taskIds

        if (!taskIds) {
            render([success: false, error: 'No se proporcionaron IDs de tareas'] as JSON)
            return
        }

        try {
            taskIds.each { taskId ->
                def task = Task.get(taskId)
                if (task) {
                    task.delete()
                }
            }
            render([success: true, message: 'Tareas eliminadas exitosamente'] as JSON)
        } catch (Exception e) {
            render([success: false, error: 'Error al eliminar las tareas: ' + e.message] as JSON)
        }
    }
} 