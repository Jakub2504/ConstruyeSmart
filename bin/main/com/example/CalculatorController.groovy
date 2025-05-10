package com.example

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class CalculatorController {

    def index() {
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
            def selectedMaterials = materials[projectType]
            if (selectedMaterials) {
                selectedMaterials.each { material ->
                    def quantity
                    if (projectType == 'wall') {
                        quantity = volume * material.factor * material.wasteFactor
                    } else {
                        quantity = area * material.factor * material.wasteFactor
                    }
                    result[material.name] = [
                        quantity: Math.ceil(quantity * 100) / 100,
                        unit: material.unit,
                        baseQuantity: Math.ceil((quantity / material.wasteFactor) * 100) / 100,
                        wasteQuantity: Math.ceil((quantity - (quantity / material.wasteFactor)) * 100) / 100
                    ]
                }
            }

            render(view: 'index', model: [
                result: result,
                materials: materials,
                projectType: projectType,
                length: length,
                width: width,
                height: height,
                area: Math.ceil(area * 100) / 100,
                volume: Math.ceil(volume * 100) / 100
            ])
        } else {
            render(view: 'index', model: [materials: materials])
        }
    }
} 