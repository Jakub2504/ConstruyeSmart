package com.example

import com.mongodb.client.MongoClients
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.gorm.transactions.Transactional

@Secured(['ROLE_USER'])
class ProjectController {
    SpringSecurityService springSecurityService
    ProjectService projectService

    def index() {
        def user = springSecurityService.currentUser
        def projects = Project.findAllByUser(user) // Listar solo proyectos del usuario actual
        [projects: projects, projectService: projectService]
    }


    def create() {
        [project: new Project(), projectService: projectService]
    }

    @Transactional
    def save(Project project) {
        def currentUser = springSecurityService.currentUser // Usuario autenticado

        if (!currentUser) {
            flash.error = "Debes iniciar sesión para crear un proyecto."
            redirect action: "index"
            return
        }

        if (!project) {
            flash.error = "Información del proyecto no válida."
            redirect action: "index"
            return
        }

        try {
            // Asignar el usuario autenticado al proyecto
            project.user = currentUser

            // Guardar el proyecto usando el servicio
            projectService.save(project)

            // Validar si hubo errores en el guardado
            if (!project.hasErrors()) {
                flash.message = "Proyecto '${project.name}' creado exitosamente."
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al crear el proyecto."
                render view: "create", model: [project: project, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al guardar el proyecto: ${e.message}", e)
            flash.error = "Error al crear el proyecto. Por favor, inténtalo nuevamente."
            render view: "create", model: [project: project, projectService: projectService]
        }
    }

def show(String id) {
    def currentUser = springSecurityService.currentUser
    def project = projectService.get(id)
    
    if (!project) {
        flash.error = "Proyecto no encontrado"
        redirect action: "index"
        return
    }
    
    // Obtener tareas del Planner para este proyecto
    def plannerTasks = []
    
    try {
        // Obtener la conexión a MongoDB
        def mongo = com.mongodb.client.MongoClients.create("mongodb://localhost:27017")
        
        // Usar la base de datos "construyesmart"
        def database = mongo.getDatabase("construyesmart")
        def taskCollection = database.getCollection("task")
        
        // Obtener todas las tareas
        def allTasks = new ArrayList()
        def projectName = project.name
        
        // Buscar tareas que coincidan principalmente por "projectName"
        def filter = com.mongodb.client.model.Filters.or(
            com.mongodb.client.model.Filters.eq("projectName", projectName),
            com.mongodb.client.model.Filters.eq("project", projectName)
        )
        
        taskCollection.find(filter).into(allTasks)
        
        // Convertir los documentos a objetos para la vista
        def dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy")
        allTasks.each { doc ->
            def taskMap = [:]
            
            // Manejar diferentes tipos de ID
            def taskId = doc.get("_id")
            taskMap.id = taskId?.toString()
            
            // Datos básicos de la tarea
            taskMap.name = doc.getString("name") ?: "Sin nombre"
            taskMap.description = doc.getString("description") ?: ""
            taskMap.status = doc.getString("status") ?: "Pendiente"
            taskMap.priority = doc.getString("priority") ?: "Media"
            
            // Fechas
            if (doc.containsKey("startDate")) {
                def startDate = doc.get("startDate")
                if (startDate instanceof Date) {
                    taskMap.startDateFormatted = dateFormat.format(startDate)
                } else {
                    taskMap.startDateFormatted = startDate?.toString()
                }
            }
            if (doc.containsKey("endDate")) {
                def endDate = doc.get("endDate")
                if (endDate instanceof Date) {
                    taskMap.endDateFormatted = dateFormat.format(endDate)
                } else {
                    taskMap.endDateFormatted = endDate?.toString()
                }
            }
            
            plannerTasks.add(taskMap)
        }
        
        // Asegúrate de cerrar la conexión
        mongo.close()
        
    } catch (Exception e) {
        log.error("Error al obtener tareas del Planner: ${e.message}", e)
    }
    
    [project: project, plannerTasks: plannerTasks]
}



    def edit(String id) { // Cambiado a String para manejar ObjectId
        def project = projectService.get(id)
        if (!project) {
            flash.error = "Proyecto no encontrado"
            redirect action: "index"
            return
        }
        [project: project, projectService: projectService]
    }

    @Transactional
    def update(Project project) {
        if (!project) {
            flash.error = "Proyecto no válido"
            redirect action: "index"
            return
        }

        try {
            if (projectService.save(project)) {
                flash.message = "Proyecto actualizado exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Errores al actualizar el proyecto: ${project.errors}"
                render view: "edit", model: [project: project]
            }
        } catch (Exception e) {
            log.error("Error al actualizar el proyecto: ${e.message}", e)
            flash.error = "Error al actualizar el proyecto: ${e.message}"
            render view: "edit", model: [project: project]
        }
    }

    @Transactional
    def delete(String id) { // Cambiado a String para manejar ObjectId
        try {
            def project = projectService.get(id)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }

            projectService.delete(id)
            flash.message = "Proyecto eliminado exitosamente"
        } catch (Exception e) {
            log.error("Error al eliminar el proyecto: ${e.message}", e)
            flash.error = "Error al eliminar el proyecto: ${e.message}"
        }
        redirect action: "index"
    }

    def addMaterial(Long id) {
        def project = projectService.get(id)
        if (!project) {
            flash.error = "Proyecto no encontrado"
            redirect action: "index"
            return
        }

        [project: project, material: new ProjectMaterial(), projectService: projectService]
    }

    @Transactional
    def saveMaterial(ProjectMaterial material) {
        if (!material) {
            flash.error = "Material no válido"
            redirect action: "index"
            return
        }

        try {
            def project = projectService.get(params.projectId as Long)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }

            material.project = project
            material.save()

            if (!material.hasErrors()) {
                flash.message = "Material agregado exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al agregar el material: ${material.errors}"
                render view: "addMaterial", model: [project: project, material: material, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al guardar el material: ${e.message}", e)
            flash.error = "Error al agregar el material: ${e.message}"
            render view: "addMaterial", model: [project: project, material: material, projectService: projectService]
        }
    }

    def addTask(Long id) {
        def project = projectService.get(id)
        if (!project) {
            flash.error = "Proyecto no encontrado"
            redirect action: "index"
            return
        }

        [project: project, task: new ProjectTask(), projectService: projectService]
    }

    @Transactional
    def saveTask(ProjectTask task) {
        if (!task) {
            flash.error = "Tarea no válida"
            redirect action: "index"
            return
        }

        try {
            def project = projectService.get(params.projectId as Long)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }

            task.project = project
            task.save()

            if (!task.hasErrors()) {
                flash.message = "Tarea agregada exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al agregar la tarea: ${task.errors}"
                render view: "addTask", model: [project: project, task: task, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al guardar la tarea: ${e.message}", e)
            flash.error = "Error al agregar la tarea: ${e.message}"
            render view: "addTask", model: [project: project, task: task, projectService: projectService]
        }
    }

    def addNote(Long id) {
        def project = projectService.get(id)
        if (!project) {
            flash.error = "Proyecto no encontrado"
            redirect action: "index"
            return
        }

        [project: project, note: new ProjectNote(), projectService: projectService]
    }

    @Transactional
    def saveNote(ProjectNote note) {
        if (!note) {
            flash.error = "Nota no válida"
            redirect action: "index"
            return
        }

        try {
            def project = projectService.get(params.projectId as Long)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }

            note.project = project
            note.save()

            if (!note.hasErrors()) {
                flash.message = "Nota agregada exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al agregar la nota: ${note.errors}"
                render view: "addNote", model: [project: project, note: note, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al guardar la nota: ${e.message}", e)
            flash.error = "Error al agregar la nota: ${e.message}"
            render view: "addNote", model: [project: project, note: note, projectService: projectService]
        }
    }

    @Transactional
    def updateStatus(Long id) {
        try {
            def project = projectService.get(id)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }

            project.status = params.status
            project.save()

            if (!project.hasErrors()) {
                flash.message = "Estado del proyecto actualizado exitosamente"
            } else {
                flash.error = "Error al actualizar el estado del proyecto: ${project.errors}"
            }
        } catch (Exception e) {
            log.error("Error al actualizar el estado del proyecto: ${e.message}", e)
            flash.error = "Error al actualizar el estado del proyecto: ${e.message}"
        }
        redirect action: "show", id: id
    }

    def search() {
        try {
            def user = springSecurityService.currentUser
            def projects = projectService.search(user, params)
            render view: "index", model: [projects: projects, projectService: projectService]
        } catch (Exception e) {
            log.error("Error al buscar proyectos: ${e.message}", e)
            flash.error = "Error al buscar proyectos: ${e.message}"
            redirect action: "index"
        }
    }
}