<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>ConstruyeSmart - Tu Asistente Profesional de Construcción</title>
    <asset:stylesheet src="home.css"/>
</head>
<body>
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="display-4 text-white">ConstruyeSmart</h1>
                    <p class="lead text-white">Tu asistente profesional para proyectos de construcción y albañilería</p>
                    <div class="mt-4">
                        <g:if test="${!request.authenticated}">
                            <g:link controller="login" action="auth" class="btn btn-primary btn-lg me-3">Iniciar Sesión</g:link>
                            <g:link controller="login" action="register" class="btn btn-outline-light btn-lg">Registrarse</g:link>
                        </g:if>
                        <g:else>
                            <g:link controller="project" action="create" class="btn btn-success btn-lg">Nuevo Proyecto</g:link>
                        </g:else>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Herramientas Section -->
    <div class="container my-5">
        <h2 class="text-center mb-4">Herramientas Profesionales</h2>
        <div class="row">
            <g:each in="${tools}" var="tool">
                <div class="col-md-3 mb-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="${tool.icon} fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">${tool.name}</h5>
                            <p class="card-text">${tool.description}</p>
                            <g:link uri="${tool.link}" class="btn btn-outline-primary">Acceder</g:link>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <!-- Consejos Profesionales -->
    <div class="bg-light py-5">
        <div class="container">
            <h2 class="text-center mb-4">Consejos Profesionales</h2>
            <div class="row">
                <g:each in="${constructionTips}" var="tip">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <i class="${tip.icon} fa-2x mb-3 text-primary"></i>
                                <h5 class="card-title">${tip.title}</h5>
                                <p class="card-text">${tip.content}</p>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </div>

    <!-- Proyectos Destacados -->
    <div class="container my-5">
        <h2 class="text-center mb-4">Proyectos Destacados</h2>
        <div class="row">
            <g:each in="${featuredProjects}" var="project">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${project.name}</h5>
                            <p class="card-text">${project.description}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-${project.status == 'active' ? 'success' : 'secondary'}">${project.status}</span>
                                <g:link controller="project" action="show" id="${project.id}" class="btn btn-sm btn-outline-primary">Ver Detalles</g:link>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <!-- Estadísticas -->
    <div class="bg-primary text-white py-5">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-3">
                    <h3 class="display-4">${stats.projectCount}</h3>
                    <p>Proyectos Totales</p>
                </div>
                <div class="col-md-3">
                    <h3 class="display-4">${stats.activeProjects}</h3>
                    <p>Proyectos Activos</p>
                </div>
                <div class="col-md-3">
                    <h3 class="display-4">${stats.completedProjects}</h3>
                    <p>Proyectos Completados</p>
                </div>
                <div class="col-md-3">
                    <h3 class="display-4">${stats.totalBudget}</h3>
                    <p>Presupuesto Total</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>ConstruyeSmart</h5>
                    <p>Tu asistente profesional para proyectos de construcción</p>
                </div>
                <div class="col-md-4">
                    <h5>Enlaces Rápidos</h5>
                    <ul class="list-unstyled">
                        <li><g:link controller="project" action="index" class="text-white">Proyectos</g:link></li>
                        <li><g:link controller="tutorial" action="index" class="text-white">Tutoriales</g:link></li>
                        <li><g:link controller="tool" action="index" class="text-white">Herramientas</g:link></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Contacto</h5>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-envelope"></i> info@construyesmart.com</li>
                        <li><i class="fas fa-phone"></i> +34 900 123 456</li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
