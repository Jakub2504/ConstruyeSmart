package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON

class HomeController {

    def projectService
    def springSecurityService

    def index() {
        def user = springSecurityService.currentUser
        def projects = Project.list()
        
        // Estadísticas generales
        def stats = [
            projectCount: projects.size(),
            activeProjects: projects.count { it.status == 'active' },
            completedProjects: projects.count { it.status == 'completed' },
            totalBudget: projects.sum { it.budget ?: 0 }
        ]
        
        // Proyectos destacados
        def featuredProjects = Project.createCriteria().list {
            order('dateCreated', 'desc')
            maxResults(3)
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
                content: 'Aprende las mejores técnicas y prácticas para trabajos de albañilería profesional',
                icon: 'fas fa-hard-hat'
            ],
            [
                title: 'Gestión de Materiales',
                content: 'Optimiza el uso de materiales y reduce el desperdicio en tus obras',
                icon: 'fas fa-boxes'
            ],
            [
                title: 'Seguridad en la Obra',
                content: 'Implementa las mejores prácticas de seguridad en tus proyectos de construcción',
                icon: 'fas fa-shield-alt'
            ]
        ]
        
        // Proyectos recientes
        def recentProjects = Project.createCriteria().list {
            order('dateCreated', 'desc')
            maxResults(4)
        }
        
        render(view: 'index', model: [
            stats: stats,
            featuredProjects: featuredProjects,
            tools: tools,
            constructionTips: constructionTips,
            recentProjects: recentProjects,
            user: user
        ])
    }
}
