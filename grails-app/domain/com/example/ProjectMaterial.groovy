package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class ProjectMaterial {
    ObjectId id
    String name
    String description
    String unit // unidad de medida (kg, m, l, etc.)
    BigDecimal quantity
    BigDecimal unitPrice
    BigDecimal totalPrice
    String supplier
    String supplierUrl
    String status = 'PENDIENTE' // PENDIENTE, COMPRADO, ENTREGADO
    Date purchaseDate
    Date deliveryDate
    
    static belongsTo = [project: Project]
    
    static constraints = {
        name blank: false, maxSize: 100
        description nullable: true, maxSize: 500
        unit blank: false
        quantity min: 0.0
        unitPrice min: 0.0
        totalPrice min: 0.0
        supplier nullable: true
        supplierUrl nullable: true, url: true
        status inList: ['PENDIENTE', 'COMPRADO', 'ENTREGADO']
        purchaseDate nullable: true
        deliveryDate nullable: true
    }
    
    static mapping = {
        version false
    }
    
    def beforeInsert() {
        calculateTotalPrice()
    }
    
    def beforeUpdate() {
        calculateTotalPrice()
    }
    
    private void calculateTotalPrice() {
        totalPrice = quantity * unitPrice
    }
} 