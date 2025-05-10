package com.example

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.bson.conversions.Bson
import org.bson.types.ObjectId
import org.bson.Document
import com.mongodb.client.MongoClients
import com.mongodb.client.MongoClient
import com.mongodb.client.MongoDatabase
import com.mongodb.client.MongoCollection
import com.mongodb.client.model.Filters
import java.text.SimpleDateFormat
import com.mongodb.client.model.Sorts

@Secured(['ROLE_USER'])
class PlannerController {
    
    def springSecurityService
    def projectService // Inyección del servicio de proyectos
    
    // Conexión a MongoDB
    private MongoDatabase getDatabase() {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017")
        return mongoClient.getDatabase("construyesmart")
    }
    
    def index() {
        def projectId = params.projectId
        def project = null
        
        if (projectId) {
            try {
                project = Project.get(projectId)
                if (!project) {
                    log.warn("No se encontró el proyecto con ID: ${projectId}")
                }
            } catch (Exception e) {
                log.error("Error al obtener el proyecto: ${e.message}", e)
            }
        }
        
        def tasks = []
        
        try {
            // Obtener la conexión a MongoDB
            def mongo = com.mongodb.client.MongoClients.create("mongodb://localhost:27017")
            def database = mongo.getDatabase("construyesmart")
            def taskCollection = database.getCollection("task")
            
            // Obtener el usuario actual
            def currentUser = springSecurityService.currentUser
            def userId = currentUser.id.toString()
            
            // Crear filtro base para solo mostrar tareas del usuario actual
            def userFilter = com.mongodb.client.model.Filters.eq("userId", userId)
            
            // Si también hay filtro por proyecto, combinarlo con el filtro de usuario
            def filter = userFilter
            if (project) {
                def projectName = project.name
                def projectIdStr = project.id.toString()
                
                // Crear un filtro OR para buscar por nombre o ID del proyecto
                def projectFilter = com.mongodb.client.model.Filters.or(
                    com.mongodb.client.model.Filters.eq("projectName", projectName),
                    com.mongodb.client.model.Filters.eq("project", projectName),
                    com.mongodb.client.model.Filters.eq("project", projectIdStr),
                    com.mongodb.client.model.Filters.eq("projectId", projectIdStr)
                )
                
                // Combinar filtros: usuario Y proyecto
                filter = com.mongodb.client.model.Filters.and(userFilter, projectFilter)
            }
            
            // Ejecutar la consulta
            def results = new ArrayList()
            taskCollection.find(filter).into(results)
            
            // Convertir los documentos a objetos para la vista
            def dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy")
            results.each { doc ->
                def taskMap = [:]
                
                taskMap.id = doc.get("_id")?.toString()
                taskMap.name = doc.getString("name") ?: "Sin nombre"
                taskMap.description = doc.getString("description") ?: ""
                taskMap.status = doc.getString("status") ?: "Pendiente"
                taskMap.priority = doc.getString("priority") ?: "Media"
                
                // Proyecto
                if (doc.containsKey("projectName")) {
                    taskMap.projectName = doc.getString("projectName")
                } else if (doc.containsKey("project")) {
                    def projectValue = doc.get("project")?.toString()
                    if (projectValue) {
                        // Intenta buscar el proyecto por ID
                        def foundProject = Project.get(projectValue)
                        taskMap.projectName = foundProject?.name ?: projectValue
                    }
                }
                
                // Asegurarse de que todas las fechas estén preformateadas para la vista
                // y eliminar propiedades que podrían causar problemas con g:formatDate
                
                // Fecha de inicio
                if (doc.containsKey("startDate")) {
                    def startDate = doc.get("startDate")
                    if (startDate instanceof Date) {
                        // Para la vista
                        taskMap.startDateFormatted = dateFormat.format(startDate)
                        // Para campos input (formato yyyy-MM-dd)
                        taskMap.startDateInput = new SimpleDateFormat("yyyy-MM-dd").format(startDate)
                    } else {
                        taskMap.startDateFormatted = startDate?.toString() ?: "Sin fecha"
                        taskMap.startDateInput = startDate?.toString() ?: ""
                    }
                } else {
                    taskMap.startDateFormatted = "Sin fecha"
                    taskMap.startDateInput = ""
                }
                
                // Fecha de fin
                if (doc.containsKey("endDate")) {
                    def endDate = doc.get("endDate")
                    if (endDate instanceof Date) {
                        // Para la vista
                        taskMap.endDateFormatted = dateFormat.format(endDate)
                        // Para campos input (formato yyyy-MM-dd)
                        taskMap.endDateInput = new SimpleDateFormat("yyyy-MM-dd").format(endDate)
                    } else {
                        taskMap.endDateFormatted = endDate?.toString() ?: "Sin fecha"
                        taskMap.endDateInput = endDate?.toString() ?: ""
                    }
                } else {
                    taskMap.endDateFormatted = "Sin fecha"
                    taskMap.endDateInput = ""
                }
                
                // Eliminar propiedades de fecha originales que podrían causar problemas
                // al intentar formatearlas con g:formatDate
                taskMap.remove("startDate")
                taskMap.remove("endDate")
                
                tasks.add(taskMap)
            }
            
            // Asegúrate de cerrar la conexión
            mongo.close()
            
        } catch (Exception e) {
            log.error("Error al obtener tareas del Planner: ${e.message}", e)
        }
        
        // Obtener la lista de proyectos para el selector
        def projects = []
        try {
            def currentUser = springSecurityService.currentUser
            if (currentUser) {
                projects = Project.list() ?: []
            }
        } catch (Exception e) {
            log.error("Error al obtener proyectos para selector: ${e.message}", e)
        }
        
        [tasks: tasks, project: project, projects: projects]
}
    
    def save() {
        try {
            def jsonData
            if (request.method == 'POST' && request.JSON) {
                jsonData = request.JSON
            } else {
                jsonData = params
            }
            
            log.info("Datos recibidos para guardar tarea: ${jsonData}")
            
            if (!jsonData.name?.trim()) {
                render(status: 400, [error: "El nombre de la tarea es requerido"] as JSON)
                return
            }

            def currentUser = springSecurityService.currentUser
            log.info("Usuario actual: ${currentUser?.username}, ID: ${currentUser?.id}")
            
            // Fechas
            def startDate = null
            def endDate = null
            
            if (jsonData.startDate) {
                try {
                    startDate = jsonData.startDate instanceof Date ? 
                        jsonData.startDate : 
                        new SimpleDateFormat("yyyy-MM-dd").parse(jsonData.startDate.toString())
                } catch (Exception e) {
                    log.error("Error al parsear fecha de inicio: ${e.message}", e)
                }
            }
            
            if (jsonData.endDate) {
                try {
                    endDate = jsonData.endDate instanceof Date ? 
                        jsonData.endDate : 
                        new SimpleDateFormat("yyyy-MM-dd").parse(jsonData.endDate.toString())
                } catch (Exception e) {
                    log.error("Error al parsear fecha de fin: ${e.message}", e)
                }
            }
            
            // Proyecto - Usando ProjectService
            String projectId = null
            String projectName = null
            
            if (jsonData.projectId) {
                try {
                    def project = projectService.get(jsonData.projectId)
                    if (project) {
                        projectId = project.id.toString()
                        projectName = project.name
                        log.info("Proyecto encontrado: ${projectName}, ID: ${projectId}")
                    } else {
                        log.warn("No se encontró el proyecto con ID: ${jsonData.projectId}")
                    }
                } catch (Exception e) {
                    log.error("Error al obtener proyecto: ${e.message}", e)
                }
            }
            
            // Guardar en MongoDB
            try {
                MongoDatabase db = getDatabase()
                MongoCollection<Document> taskCollection = db.getCollection("task")
                
                // Si es edición
                if (jsonData.id) {
                    log.info("Editando tarea existente con ID: ${jsonData.id}")
                    
                    try {
                        ObjectId taskId = new ObjectId(jsonData.id.toString())
                        
                        // NUEVA APROXIMACIÓN: Usar métodos nativos de MongoDB sin operadores como cadena
                        // Primero, buscar el documento existente
                        Document existingTask = taskCollection.find(Filters.eq("_id", taskId)).first()
                        
                        if (existingTask == null) {
                            render(status: 404, [error: "Tarea no encontrada"] as JSON)
                            return
                        }
                        
                        // Actualizar los campos del documento existente
                        existingTask.put("name", jsonData.name.trim())
                        existingTask.put("description", jsonData.description?.trim() ?: "")
                        existingTask.put("status", jsonData.status ?: "Pendiente")
                        existingTask.put("priority", jsonData.priority ?: "Media")
                        existingTask.put("lastUpdated", new Date())
                        
                        if (startDate != null) {
                            existingTask.put("startDate", startDate)
                        } else {
                            existingTask.remove("startDate")
                        }
                        
                        if (endDate != null) {
                            existingTask.put("endDate", endDate)
                        } else {
                            existingTask.remove("endDate")
                        }
                        
                        if (projectId != null) {
                            existingTask.put("projectId", projectId)
                            existingTask.put("projectName", projectName)
                        } else {
                            existingTask.remove("projectId")
                            existingTask.remove("projectName")
                        }
                        
                        // Mantener el id original
                        ObjectId originalId = existingTask.getObjectId("_id")
                        
                        // Reemplazar completamente el documento
                        taskCollection.replaceOne(Filters.eq("_id", taskId), existingTask)
                        
                        render([
                            success: true, 
                            id: taskId.toString(), 
                            message: "Tarea actualizada exitosamente"
                        ] as JSON)
                        
                    } catch (Exception e) {
                        log.error("Error al actualizar tarea: ${e.message}", e)
                        render(status: 500, [error: "Error al actualizar la tarea: ${e.message}"] as JSON)
                    }
                } 
                // Si es nueva tarea
                else {
                    log.info("Creando nueva tarea")
                    
                    // Crear documento para nueva tarea
                    Document taskDoc = new Document()
                        .append("name", jsonData.name.trim())
                        .append("description", jsonData.description?.trim() ?: "")
                        .append("status", jsonData.status ?: "Pendiente")
                        .append("priority", jsonData.priority ?: "Media")
                        .append("userId", currentUser.id.toString())
                        .append("username", currentUser.username)
                        .append("dateCreated", new Date())
                        .append("lastUpdated", new Date())
                
                    if (startDate != null) {
                        taskDoc.append("startDate", startDate)
                    }
                    
                    if (endDate != null) {
                        taskDoc.append("endDate", endDate)
                    }
                    
                    if (projectId != null) {
                        taskDoc.append("projectId", projectId)
                        taskDoc.append("projectName", projectName)
                    }
                
                    taskCollection.insertOne(taskDoc)
                    String insertedId = taskDoc.getObjectId("_id").toString()
                    
                    render([
                        success: true, 
                        id: insertedId, 
                        message: "Tarea creada exitosamente"
                    ] as JSON)
                }
                
            } catch (Exception e) {
                log.error("Error al guardar en MongoDB: ${e.message}", e)
                render(status: 500, [error: "Error al guardar la tarea: ${e.message}"] as JSON)
            }
            
        } catch (Exception e) {
            log.error("Error general: ${e.message}", e)
            render(status: 500, [error: "Error general: ${e.message}"] as JSON)
        }
    }
    
    def getTask() {
        log.info("Obteniendo tarea con ID: ${params.id}")
        
        if (!params.id) {
            render(status: 400, [error: "ID de tarea no especificado"] as JSON)
            return
        }
        
        try {
            MongoDatabase db = getDatabase()
            MongoCollection<Document> taskCollection = db.getCollection("task")
            
            ObjectId taskId = new ObjectId(params.id)
            Document taskDoc = taskCollection.find(Filters.eq("_id", taskId)).first()
            
            if (taskDoc == null) {
                log.warn("No se encontró la tarea con ID: ${params.id}")
                render(status: 404, [error: "Tarea no encontrada"] as JSON)
                return
            }
            
            // Convertir a un mapa más simple y amigable para JSON
            Map<String, Object> taskMap = new LinkedHashMap<>()
            
            // Campos principales
            taskMap.put("id", taskDoc.getObjectId("_id").toString())
            taskMap.put("name", taskDoc.getString("name"))
            taskMap.put("description", taskDoc.getString("description") ?: "")
            taskMap.put("status", taskDoc.getString("status") ?: "Pendiente")
            taskMap.put("priority", taskDoc.getString("priority") ?: "Media")
            
            // Fechas
            if (taskDoc.containsKey("startDate")) {
                Date startDate = taskDoc.getDate("startDate")
                taskMap.put("startDate", new SimpleDateFormat("yyyy-MM-dd").format(startDate))
            }
            
            if (taskDoc.containsKey("endDate")) {
                Date endDate = taskDoc.getDate("endDate")
                taskMap.put("endDate", new SimpleDateFormat("yyyy-MM-dd").format(endDate))
            }
            
            // Proyecto
            if (taskDoc.containsKey("projectId")) {
                taskMap.put("projectId", taskDoc.getString("projectId"))
            }
            
            log.info("Datos de tarea encontrados: ${taskMap}")
            render taskMap as JSON
            
        } catch (Exception e) {
            log.error("Error al obtener tarea: ${e.message}", e)
            render(status: 500, [error: "Error al obtener la tarea: ${e.message}"] as JSON)
        }
    }
    
    def delete() {
        log.info("Eliminando tarea con ID: ${params.id}")
        
        if (!params.id) {
            render(status: 400, [error: "ID de tarea no especificado"] as JSON)
            return
        }
        
        try {
            MongoDatabase db = getDatabase()
            MongoCollection<Document> taskCollection = db.getCollection("task")
            
            ObjectId taskId = new ObjectId(params.id)
            def result = taskCollection.deleteOne(Filters.eq("_id", taskId))
            
            if (result.getDeletedCount() > 0) {
                log.info("Tarea eliminada exitosamente: ${params.id}")
                render([
                    success: true,
                    message: "Tarea eliminada exitosamente"
                ] as JSON)
            } else {
                log.warn("No se encontró la tarea para eliminar: ${params.id}")
                render(status: 404, [error: "Tarea no encontrada o ya fue eliminada"] as JSON)
            }
            
        } catch (Exception e) {
            log.error("Error al eliminar tarea: ${e.message}", e)
            render(status: 500, [error: "Error al eliminar la tarea: ${e.message}"] as JSON)
        }
    }
    
    // Método para obtener proyectos para el dropdown
    def listProjects() {
        log.info("Listando proyectos para selector")
        
        def currentUser = springSecurityService.currentUser
        def projectsData = []
        
        try {
            // Usar projectService para obtener proyectos
            def projects = projectService.search(currentUser, [:])
            
            projects.each { project ->
                projectsData << [
                    id: project.id.toString(),
                    name: project.name
                ]
            }
            
            log.info("Proyectos encontrados: ${projectsData.size()}")
            render projectsData as JSON
        } catch (Exception e) {
            log.error("Error al listar proyectos: ${e.message}", e)
            render(status: 500, [error: "Error al listar proyectos: ${e.message}"] as JSON)
        }
    }
}