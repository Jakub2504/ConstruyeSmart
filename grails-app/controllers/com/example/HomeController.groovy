package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON

class HomeController {

    def projectService
    def springSecurityService

    def index() {
        def currentUser = springSecurityService.currentUser // Usuario autenticado (puede ser null)

        // Inicializar valores
        def projects = []
        def stats = [:]
        def featuredProjects = []

        if (currentUser) {
            // Si hay un usuario autenticado, cargar proyectos y estadísticas solo para ese usuario
            projects = Project.findAllByUser(currentUser)

            // Estadísticas de los proyectos del usuario autenticado
            stats = [
                    projectCount: projects?.size() ?: 0, // Total de proyectos del usuario
                    activeProjects: projects?.count { it.status in ['PLANIFICACION', 'EN_PROGRESO'] } ?: 0, // Proyectos activos
                    completedProjects: projects?.count { it.status == 'COMPLETADO' } ?: 0, // Proyectos completados
                    totalBudget: projects?.sum { it.budget ?: 0 } ?: 0 // Suma del presupuesto del usuario
            ]

            // Proyectos destacados (los más recientes del usuario)
            featuredProjects = Project.createCriteria().list {
                eq('user', currentUser) // Filtrar proyectos del usuario
                order('dateCreated', 'desc')
                maxResults(3)
            }
        }

        // Herramientas disponibles
        def tools = [
                [
                        name: 'Calculadora de Materiales',
                        description: 'Calcula la cantidad exacta de materiales necesarios para tu proyecto de construcción',
                        icon: 'fas fa-calculator',
                        link: '/calculator'
                ],
                [
                        name: 'Planificador de Obra',
                        description: 'Organiza y gestiona las tareas de tu obra de manera eficiente',
                        icon: 'fas fa-tasks',
                        link: '/planner'
                ],
                [
                        name: 'Gestor de Presupuesto',
                        description: 'Controla y optimiza los costos de tu obra',
                        icon: 'fas fa-euro-sign',
                        link: '/budget'
                ],
                [
                        name: 'Calendario de Obra',
                        description: 'Planifica y visualiza el cronograma de tu proyecto de construcción',
                        icon: 'fas fa-calendar-alt',
                        link: '/calendar'
                ]
        ]

        // Consejos profesionales para albañiles
        def constructionTips = [
                [
                        title: 'Técnicas de Albañilería',
                        content: '"Domina la colocación precisa de ladrillos y bloques para asegurar estructuras sólidas y duraderas."',
                        icon: 'fas fa-hard-hat'
                ],
                [
                        title: 'Gestión de Materiales',
                        content: '"Controla los costos y evita desperdicios mediante una planificación detallada y seguimiento del uso de materiales."',
                        icon: 'fas fa-boxes'
                ],
                [
                        title: 'Seguridad en la Obra',
                        content: '"Realiza inspecciones previas para identificar riesgos y utiliza siempre el equipo de protección adecuado."',
                        icon: 'fas fa-shield-alt'
                ]
        ]

        // Proyectos recientes (visibles para todos, pero sin usuarios)
        def recentProjects = Project.createCriteria().list {
            order('dateCreated', 'desc')
            maxResults(4)
        }

        // Renderizar la vista con datos condicionales (vacíos si no está autenticado)
        render(view: 'index', model: [
                user: currentUser,              // Usuario autenticado (o null si no lo está)
                stats: stats,                   // Estadísticas del usuario autenticado
                featuredProjects: featuredProjects, // Proyectos destacados del usuario
                tools: tools,                   // Herramientas disponibles para todos
                constructionTips: constructionTips, // Consejos visibles para todos
                recentProjects: recentProjects  // Proyectos recientes visibles para todos
        ])
    }
}