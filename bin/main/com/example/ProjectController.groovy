package com.example

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.gorm.transactions.Transactional

@Secured(['ROLE_USER'])
class ProjectController {
    SpringSecurityService springSecurityService
    ProjectService projectService

    def index() {
        def user = springSecurityService.currentUser
        def projects = Project.findAllByUser(user)
        [projects: projects, projectService: projectService]
    }

    def create() {
        [project: new Project(), projectService: projectService]
    }

    @Transactional
    def save(Project project) {
        if (!project) {
            flash.error = "Proyecto no válido"
            redirect action: "index"
            return
        }
        
        try {
            project.user = springSecurityService.currentUser
            project.save()
            
            if (!project.hasErrors()) {
                flash.message = "Proyecto creado exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al crear el proyecto: ${project.errors}"
                render view: "create", model: [project: project, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al guardar el proyecto: ${e.message}", e)
            flash.error = "Error al crear el proyecto: ${e.message}"
            render view: "create", model: [project: project, projectService: projectService]
        }
    }

    def show(Long id) {
        def project = projectService.get(id)
        if (!project) {
            flash.error = "Proyecto no encontrado"
            redirect action: "index"
            return
        }
        [project: project, projectService: projectService]
    }

    def edit(Long id) {
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
            project.save()
            
            if (!project.hasErrors()) {
                flash.message = "Proyecto actualizado exitosamente"
                redirect action: "show", id: project.id
            } else {
                flash.error = "Error al actualizar el proyecto: ${project.errors}"
                render view: "edit", model: [project: project, projectService: projectService]
            }
        } catch (Exception e) {
            log.error("Error al actualizar el proyecto: ${e.message}", e)
            flash.error = "Error al actualizar el proyecto: ${e.message}"
            render view: "edit", model: [project: project, projectService: projectService]
        }
    }

    @Transactional
    def delete(Long id) {
        try {
            def project = projectService.get(id)
            if (!project) {
                flash.error = "Proyecto no encontrado"
                redirect action: "index"
                return
            }
            
            project.delete()
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