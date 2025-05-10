package com.example

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class CalculatorController {
    
    def apiIntegrationService
    def pdfService

    def index() {
        // Precios estimados por material (precio por unidad)
        def materialPrices = [
            'Ladrillos': apiIntegrationService.getMaterialPrices("Brick"),             // por unidad
            'Cemento': 12.00,              // por bolsa
            'Arena': 30.00,                // por m³
            'Piedra': 35.00,               // por m³
            'Agua': 0.05,                  // por litro
            'Alambre': 2.50,               // por kg
            'Yeso': 8.00,                  // por bolsa
            'Malla electrosoldada': 5.00,  // por m²
            'Aditivo': 10.00,              // por litro
            'Viguetas': 15.00,             // por unidad
            'Bovedillas': 2.00,            // por unidad
            'Tejas': 1.20,                 // por unidad
            'Membrana impermeabilizante': 8.00, // por m²
            'Madera estructural': 6.00,    // por m
            'Clavos': 3.00                 // por kg
        ]

        def materials = [
            wall: [
                [name: 'Ladrillos', unit: 'unidades', factor: 60, wasteFactor: 1.1],
                [name: 'Cemento', unit: 'bolsas', factor: 0.3, wasteFactor: 1.05],
                [name: 'Arena', unit: 'm³', factor: 0.1, wasteFactor: 1.1],
                [name: 'Piedra', unit: 'm³', factor: 0.05, wasteFactor: 1.1],
                [name: 'Agua', unit: 'litros', factor: 20, wasteFactor: 1.0],
                [name: 'Alambre', unit: 'kg', factor: 0.5, wasteFactor: 1.05],
                [name: 'Yeso', unit: 'bolsas', factor: 0.2, wasteFactor: 1.1]
            ],
            floor: [
                [name: 'Cemento', unit: 'bolsas', factor: 0.4, wasteFactor: 1.05],
                [name: 'Arena', unit: 'm³', factor: 0.2, wasteFactor: 1.1],
                [name: 'Piedra', unit: 'm³', factor: 0.1, wasteFactor: 1.1],
                [name: 'Agua', unit: 'litros', factor: 30, wasteFactor: 1.0],
                [name: 'Malla electrosoldada', unit: 'm²', factor: 1.1, wasteFactor: 1.05],
                [name: 'Aditivo', unit: 'litros', factor: 2, wasteFactor: 1.0]
            ],
            ceiling: [
                [name: 'Viguetas', unit: 'unidades', factor: 1.2, wasteFactor: 1.05],
                [name: 'Bovedillas', unit: 'unidades', factor: 10, wasteFactor: 1.1],
                [name: 'Cemento', unit: 'bolsas', factor: 0.2, wasteFactor: 1.05],
                [name: 'Arena', unit: 'm³', factor: 0.1, wasteFactor: 1.1],
                [name: 'Agua', unit: 'litros', factor: 15, wasteFactor: 1.0],
                [name: 'Alambre', unit: 'kg', factor: 0.3, wasteFactor: 1.05],
                [name: 'Yeso', unit: 'bolsas', factor: 0.15, wasteFactor: 1.1]
            ],
            roof: [
                [name: 'Tejas', unit: 'unidades', factor: 25, wasteFactor: 1.1],
                [name: 'Cemento', unit: 'bolsas', factor: 0.25, wasteFactor: 1.05],
                [name: 'Arena', unit: 'm³', factor: 0.1, wasteFactor: 1.1],
                [name: 'Membrana impermeabilizante', unit: 'm²', factor: 1.15, wasteFactor: 1.05],
                [name: 'Madera estructural', unit: 'm', factor: 2.5, wasteFactor: 1.1],
                [name: 'Clavos', unit: 'kg', factor: 0.5, wasteFactor: 1.05]
            ]
        ]

        if (request.method == 'POST') {
            if (!params.projectType || !params.length || !params.width) {
                flash.error = "Por favor complete todos los campos requeridos"
                render(view: 'index', model: [materials: materials])
                return
            }

            def projectType = params.projectType
            def length = params.double('length')
            def width = params.double('width')
            def height = params.double('height')

            // Validación específica para paredes
            if (projectType == 'wall') {
                if (height == null || height <= 0) {
                    flash.error = "La altura debe ser mayor que 0 para paredes"
                    render(view: 'index', model: [
                        materials: materials,
                        projectType: projectType,
                        length: length,
                        width: width
                    ])
                    return
                }
            }

            def area = length * width
            def volume = projectType == 'wall' ? area * height : 0

            def result = [:]
            def totalCost = 0
            def selectedMaterials = materials[projectType]
            if (selectedMaterials) {
                selectedMaterials.each { material ->
                    def quantity
                    if (projectType == 'wall') {
                        quantity = volume * material.factor * material.wasteFactor
                    } else {
                        quantity = area * material.factor * material.wasteFactor
                    }
                    
                    // Calcular el costo basado en el precio estimado por unidad
                    def unitPrice = materialPrices[material.name] ?: 0
                    def cost = quantity * unitPrice
                    totalCost += cost
                    
                    result[material.name] = [
                        quantity: Math.ceil(quantity * 100) / 100,
                        unit: material.unit,
                        baseQuantity: Math.ceil((quantity / material.wasteFactor) * 100) / 100,
                        wasteQuantity: Math.ceil((quantity - (quantity / material.wasteFactor)) * 100) / 100,
                        unitPrice: unitPrice,
                        cost: Math.ceil(cost * 100) / 100
                    ]
                }
            }
            
            // Guardar datos en sesión para PDF
            session.lastCalculation = [
                result: result,
                projectType: projectType,
                length: length,
                width: width,
                height: height,
                area: Math.ceil(area * 100) / 100,
                volume: Math.ceil(volume * 100) / 100,
                totalCost: Math.ceil(totalCost * 100) / 100,
                date: new Date()
            ]

            render(view: 'index', model: [
                result: result,
                materials: materials,
                projectType: projectType,
                length: length,
                width: width,
                height: height,
                area: Math.ceil(area * 100) / 100,
                volume: Math.ceil(volume * 100) / 100,
                totalCost: Math.ceil(totalCost * 100) / 100
            ])
        } else {
            render(view: 'index', model: [materials: materials])
        }
    }
    
    def simplePdf() {
        def calculationData = session.lastCalculation
        
        if (!calculationData) {
            flash.error = "No hay cálculos disponibles para exportar"
            redirect(action: 'index')
            return
        }
        
        // Renderizar la vista directamente sin servicios adicionales
        render(view: 'pdfView', model: calculationData)
    }
}