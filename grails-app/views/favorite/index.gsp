<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Mis Favoritos - ConstruyeSmart</title>
    <asset:stylesheet src="tutorial.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Mis Tutoriales Favoritos</h1>
            <g:link controller="tutorial" action="index" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver a Tutoriales
            </g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <g:if test="${favorites}">
            <div class="row">
                <g:each in="${favorites}" var="favorite">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100">
                            <g:if test="${favorite.tutorial.imageUrl}">
                                <img src="${favorite.tutorial.imageUrl}" class="card-img-top" alt="${favorite.tutorial.title}">
                            </g:if>
                            <div class="card-body">
                                <h5 class="card-title">${favorite.tutorial.title}</h5>
                                <p class="card-text">${favorite.tutorial.description}</p>
                                <div class="mb-2">
                                    <span class="badge bg-info">${favorite.tutorial.difficultyLevel}</span>
                                    <span class="badge bg-secondary">${favorite.tutorial.estimatedTime}</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="rating">
                                        <g:if test="${favorite.tutorial.rating}">
                                            <span class="text-warning">
                                                <g:each in="${1..5}" var="i">
                                                    <i class="fas fa-star${i <= favorite.tutorial.rating ? '' : '-o'}"></i>
                                                </g:each>
                                            </span>
                                            <small class="text-muted">(${favorite.tutorial.ratingCount} valoraciones)</small>
                                        </g:if>
                                        <g:else>
                                            <small class="text-muted">Sin valoraciones</small>
                                        </g:else>
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-eye"></i> ${favorite.tutorial.views ?: 0} vistas
                                    </small>
                                </div>
                            </div>
                            <div class="card-footer">
                                <g:link controller="tutorial" action="show" id="${favorite.tutorial.id}" class="btn btn-sm btn-outline-primary">
                                    Ver Tutorial
                                </g:link>
                                <g:link controller="favorite" action="toggle" id="${favorite.tutorial.id}" class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-heart"></i> Quitar de Favoritos
                                </g:link>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </g:if>
        <g:else>
            <div class="alert alert-info">
                No tienes tutoriales favoritos. <g:link controller="tutorial" action="index">Explora los tutoriales</g:link> para encontrar contenido interesante.
            </div>
        </g:else>
    </div>
</body>
</html> 