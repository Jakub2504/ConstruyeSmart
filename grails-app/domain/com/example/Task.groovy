package com.example

class Task {
    String name
    String description
    Date startDate
    Date endDate
    String status
    String priority
    Date dateCreated
    Date lastUpdated

    static belongsTo = [project: Project] // Cada tarea puede pertenecer a un proyecto

    static constraints = {
        name blank: false, maxSize: 100
        description nullable: true, maxSize: 500
        startDate nullable: true
        endDate nullable: true, validator: { val, obj ->
            if (val && obj.startDate && val < obj.startDate) {
                return 'task.endDate.after.startDate'
            }
        }
        status inList: ['Pendiente', 'En Progreso', 'Completada', 'Cancelada']
        priority inList: ['Baja', 'Media', 'Alta']
        project nullable: true // Las tareas pueden o no estar asociadas a un proyecto
    }

    static mapping = {
        sort dateCreated: "desc"
    }
}