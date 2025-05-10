<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Inicio - ConstruyeSmart | Plataforma Inteligente para la Construcción</title>
    <asset:stylesheet src="home.css"/>
</head>
<body>
    <!-- Hero Section with Video Background -->
    <div class="hero-section">
        <div class="video-background">
            <video autoplay muted loop>
                <source src="${assetPath(src: 'construction-video.mp4')}" type="video/mp4">
            </video>
            <div class="overlay"></div>
        </div>
        <div class="container">
            <div class="row align-items-center min-vh-100">
                <div class="col-md-6">
                    <h1 class="display-4 fw-bold mb-4">ConstruyeSmart</h1>
                    <p class="lead mb-4">La plataforma inteligente que transforma la forma de gestionar proyectos de construcción</p>
                    <div class="d-flex gap-3">
                        <g:link action="index" controller="project" class="btn btn-primary btn-lg">
                            <i class="fas fa-rocket"></i> Comenzar Ahora
                        </g:link>
                        <a href="#features" class="btn btn-outline-light btn-lg">
                            <i class="fas fa-info-circle"></i> Ver Demo
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Projects Section -->
    <section class="featured-projects py-5">
        <div class="container">
            <h2 class="text-center mb-5">Proyectos Destacados</h2>
            <div class="row g-4">
                <g:each in="${featuredProjects}" var="project">
                    <div class="col-md-4">
                        <div class="project-card">
                            <div class="project-image">
                                <img src="${project.imageUrl ?: assetPath(src: 'default-project.jpg')}" alt="${project.name}">
                                <div class="project-overlay">
                                    <div class="project-info">
                                        <h3>${project.name}</h3>
                                        <p>${project.description}</p>
                                        <div class="project-stats">
                                            <span><i class="fas fa-tasks"></i> ${project.tasks?.size() ?: 0} tareas</span>
                                            <span><i class="fas fa-box"></i> ${project.materials?.size() ?: 0} materiales</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </section>

    <!-- Tools Section -->
    <section id="tools" class="tools-section py-5">
        <div class="container">
            <h2 class="text-center mb-5">Herramientas Inteligentes</h2>
            <div class="row g-4">
                <g:each in="${tools}" var="tool">
                    <div class="col-md-3">
                        <div class="tool-card">
                            <div class="tool-icon">
                                <i class="${tool.icon}"></i>
                            </div>
                            <h3>${tool.name}</h3>
                            <p>${tool.description}</p>
                            <a href="${tool.link}" class="btn btn-outline-primary">Usar Herramienta</a>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </section>

    <!-- Construction Tips -->
    <section class="tips-section py-5">
        <div class="container">
            <h2 class="text-center mb-5">Consejos Profesionales</h2>
            <div class="row g-4">
                <g:each in="${constructionTips}" var="tip">
                    <div class="col-md-4">
                        <div class="tip-card">
                            <div class="tip-icon">
                                <i class="${tip.icon}"></i>
                            </div>
                            <h3>${tip.title}</h3>
                            <p>${tip.content}</p>
                            <a href="#" class="btn btn-outline-primary">Leer más</a>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </section>

    <!-- Recent Projects -->
    <section class="recent-projects py-5">
        <div class="container">
            <h2 class="text-center mb-5">Proyectos Recientes</h2>
            <div class="row g-4">
                <g:each in="${recentProjects}" var="project">
                    <div class="col-md-3">
                        <div class="recent-project-card">
                            <div class="project-image">
                                <img src="${project.imageUrl ?: assetPath(src: 'default-project.jpg')}" alt="${project.name}">
                            </div>
                            <div class="project-content">
                                <h4>${project.name}</h4>
                                <div class="project-meta">
                                    <span><i class="fas fa-calendar"></i> ${project.startDate?.format('dd/MM/yyyy')}</span>
                                    <span><i class="fas fa-euro-sign"></i> ${project.budget}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section py-5">
        <div class="container text-center">
            <h2 class="mb-4">¿Listo para transformar tu forma de trabajar?</h2>
            <p class="lead mb-4">Únete a los profesionales que ya están usando ConstruyeSmart</p>
            <g:link action="index" controller="project" class="btn btn-primary btn-lg">
                <i class="fas fa-rocket"></i> Comenzar Ahora
            </g:link>
        </div>
    </section>

    <asset:javascript src="home.js"/>
</body>
</html> 