package com.example

import grails.gorm.services.Service
import grails.gorm.transactions.Transactional
import org.bson.types.ObjectId

@Service(Project)
class ProjectService {

    Project get(Serializable id) {
        if (!ObjectId.isValid(id?.toString())) { // Validar que sea un ObjectId válido
            return null
        }
        return Project.get(new ObjectId(id.toString())) // Convertir el ID de String a ObjectId
    }

    List<Project> list(Map args) {
        return Project.list(args)
    }

    Long count() {
        return Project.count()
    }

    void delete(Serializable id) {
        if (ObjectId.isValid(id?.toString())) { // Validar si el ID es válido
            Project.get(new ObjectId(id.toString()))?.delete() // Convertir el ID y eliminar
        } else {
            log.warn("ID no válido para eliminación: ${id}") // Registrar advertencia si el ID no es válido
        }
    }

    Project save(Project project) {
        if (!project) return null

        try {
            if (project.save(flush: true)) { // Guardar con flush
                return project
            } else {
                log.error("Errores al guardar el proyecto: ${project.errors}")
                return null
            }
        } catch (Exception e) {
            log.error("Error al guardar el proyecto: ${e.message}", e)
            return null
        }
    }

    List<Project> search(User user, Map params) {
        def criteria = Project.createCriteria()
        return criteria.list {
            eq('user', user) // Restringir búsquedas al usuario actual

            if (params.name) {
                ilike('name', "%${params.name}%")
            }

            if (params.status) {
                eq('status', params.status)
            }

            if (params.startDate) {
                ge('startDate', Date.parse('yyyy-MM-dd', params.startDate))
            }

            if (params.endDate) {
                le('estimatedEndDate', Date.parse('yyyy-MM-dd', params.endDate))
            }

            if (params.minBudget) {
                ge('budget', params.minBudget as BigDecimal)
            }

            if (params.maxBudget) {
                le('budget', params.maxBudget as BigDecimal)
            }

            order('dateCreated', 'desc')
        }
    }

    double calculateProjectProgress(Project project) {
        if (!project || !project.tasks) return 0.0

        def completedTasks = project.tasks.count { it.status == 'COMPLETADA' }
        return project.tasks.size() > 0 ? (completedTasks / project.tasks.size()) * 100 : 0.0
    }

    BigDecimal calculateProjectCost(Project project) {
        if (!project || !project.materials) return 0.0

        return project.materials.sum { it.totalPrice ?: 0 }
    }

    List<Map> getProjectTimeline(Project project) {
        if (!project) return []

        def timeline = []

        // Agregar fecha de inicio
        if (project.startDate) {
            timeline << [
                    event: 'Inicio del Proyecto',
                    date: project.startDate,
                    type: 'start'
            ]
        }

        // Agregar fecha estimada de fin
        if (project.estimatedEndDate) {
            timeline << [
                    event: 'Fin Estimado',
                    date: project.estimatedEndDate,
                    type: 'estimated'
            ]
        }

        // Agregar fecha real de fin si existe
        if (project.actualEndDate) {
            timeline << [
                    event: 'Fin Real',
                    date: project.actualEndDate,
                    type: 'end'
            ]
        }

        // Agregar eventos de tareas importantes
        project.tasks?.each { task ->
            if (task.status == 'COMPLETADA' && task.actualEndDate) {
                timeline << [
                        event: "Tarea Completada: ${task.name}",
                        date: task.actualEndDate,
                        type: 'task'
                ]
            }
        }

        // Ordenar por fecha
        timeline.sort { it.date }

        return timeline
    }
}