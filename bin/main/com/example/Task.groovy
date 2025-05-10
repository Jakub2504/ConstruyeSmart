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
    }

    static mapping = {
        sort dateCreated: "desc"
    }
} 