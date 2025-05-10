<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Tutoriales - ConstruyeSmart</title>
    <asset:stylesheet src="tutorial.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Tutoriales</h1>
            <g:link action="create" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nuevo Tutorial
            </g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-info">${flash.message}</div>
        </g:if>

        <div class="card mb-4">
            <div class="card-body">
                <g:form action="search" method="GET" class="search-form">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" name="query" class="form-control" placeholder="Buscar tutoriales..." value="${query}">
                                <button type="submit" class="btn btn-outline-secondary">
                                    <i class="fas fa-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <input type="text" name="author" class="form-control" placeholder="Buscar por autor..." value="${author}">
                        </div>
                    </div>

                    <div class="row g-3 mt-3">
                        <div class="col-md-3">
                            <select name="difficulty" class="form-select">
                                <option value="">Todas las dificultades</option>
                                <option value="Principiante" ${difficulty == 'Principiante' ? 'selected' : ''}>Principiante</option>
                                <option value="Intermedio" ${difficulty == 'Intermedio' ? 'selected' : ''}>Intermedio</option>
                                <option value="Avanzado" ${difficulty == 'Avanzado' ? 'selected' : ''}>Avanzado</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="minRating" class="form-select">
                                <option value="">Cualquier valoración</option>
                                <option value="4" ${minRating == 4 ? 'selected' : ''}>4+ estrellas</option>
                                <option value="3" ${minRating == 3 ? 'selected' : ''}>3+ estrellas</option>
                                <option value="2" ${minRating == 2 ? 'selected' : ''}>2+ estrellas</option>
                                <option value="1" ${minRating == 1 ? 'selected' : ''}>1+ estrellas</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="maxTime" class="form-select">
                                <option value="">Cualquier duración</option>
                                <option value="30" ${maxTime == 30 ? 'selected' : ''}>Menos de 30 min</option>
                                <option value="60" ${maxTime == 60 ? 'selected' : ''}>Menos de 1 hora</option>
                                <option value="120" ${maxTime == 120 ? 'selected' : ''}>Menos de 2 horas</option>
                                <option value="180" ${maxTime == 180 ? 'selected' : ''}>Menos de 3 horas</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="tags" class="form-select" multiple>
                                <option value="bricolaje" ${tags?.contains('bricolaje') ? 'selected' : ''}>Bricolaje</option>
                                <option value="carpinteria" ${tags?.contains('carpinteria') ? 'selected' : ''}>Carpintería</option>
                                <option value="electricidad" ${tags?.contains('electricidad') ? 'selected' : ''}>Electricidad</option>
                                <option value="fontaneria" ${tags?.contains('fontaneria') ? 'selected' : ''}>Fontanería</option>
                                <option value="pintura" ${tags?.contains('pintura') ? 'selected' : ''}>Pintura</option>
                                <option value="jardineria" ${tags?.contains('jardineria') ? 'selected' : ''}>Jardinería</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Aplicar Filtros
                            </button>
                            <g:link action="index" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Limpiar Filtros
                            </g:link>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>

        <div class="row">
            <g:each in="${tutorials}" var="tutorial">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <g:if test="${tutorial.imageUrl}">
                            <img src="${tutorial.imageUrl}" class="card-img-top" alt="${tutorial.title}">
                        </g:if>
                        <div class="card-body">
                            <h5 class="card-title">${tutorial.title}</h5>
                            <p class="card-text">${tutorial.description}</p>
                            <div class="mb-2">
                                <span class="badge bg-info">${tutorial.difficultyLevel}</span>
                                <span class="badge bg-secondary">${tutorial.estimatedTime}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="rating">
                                    <g:if test="${tutorial.rating}">
                                        <span class="text-warning">
                                            <g:each in="${1..5}" var="i">
                                                <i class="fas fa-star${i <= tutorial.rating ? '' : '-o'}"></i>
                                            </g:each>
                                        </span>
                                        <small class="text-muted">(${tutorial.ratingCount} valoraciones)</small>
                                    </g:if>
                                    <g:else>
                                        <small class="text-muted">Sin valoraciones</small>
                                    </g:else>
                                </div>
                                <small class="text-muted">
                                    <i class="fas fa-eye"></i> ${tutorial.views ?: 0} vistas
                                </small>
                            </div>
                        </div>
                        <div class="card-footer">
                            <g:link action="show" id="${tutorial.id}" class="btn btn-sm btn-outline-primary">
                                Ver Tutorial
                            </g:link>
                            <g:if test="${tutorial.author == springSecurityService.currentUser}">
                                <g:link action="edit" id="${tutorial.id}" class="btn btn-sm btn-outline-secondary">
                                    Editar
                                </g:link>
                            </g:if>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <asset:javascript src="tutorial.js"/>
</body>
</html> 