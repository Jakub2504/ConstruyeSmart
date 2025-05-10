package com.example

import grails.gorm.services.Service
import grails.gorm.transactions.Transactional
import org.bson.types.ObjectId

@Service(Project)
class ProjectService {
    Project get(Serializable id) {
        return Project.get(id)
    }
    
    List<Project> list(Map args) {
        return Project.list(args)
    }
    
    Long count() {
        return Project.count()
    }
    
    void delete(Serializable id) {
        Project.get(id)?.delete()
    }
    
    Project save(Project project) {
        if (!project) return null
        
        try {
            project.save()
            return project
        } catch (Exception e) {
            log.error("Error al guardar el proyecto: ${e.message}", e)
            return null
        }
    }
    
    List<Project> search(User user, Map params) {
        def criteria = Project.createCriteria()
        return criteria.list {
            eq('user', user)
            
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