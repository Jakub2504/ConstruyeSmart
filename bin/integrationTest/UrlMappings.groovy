class UrlMappings {

    static mappings = {
        // Página principal (prioridad más alta)
        "/"(controller: 'home', action: 'index')

        // Mapeo por defecto para controladores
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        // Rutas para proyectos
        "/proyectos"(controller: 'project', action: 'index')
        "/proyectos/nuevo"(controller: 'project', action: 'create')
        "/proyectos/$id"(controller: 'project', action: 'show')
        "/proyectos/$id/editar"(controller: 'project', action: 'edit')

        // Rutas para herramientas
        "/calculadora"(controller: 'calculator', action: 'index')
        "/planificador"(controller: 'planner', action: 'index')
        "/presupuesto"(controller: 'budget', action: 'index')
        "/calendario"(controller: 'calendar', action: 'index')

        // Rutas de autenticación
        "/login"(controller: 'login', action: 'auth')
        "/logout"(controller: 'logout', action: 'index')
        "/registro"(controller: 'register', action: 'index')

        // Páginas de error
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
} 