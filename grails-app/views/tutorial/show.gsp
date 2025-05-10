<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${tutorial.title} - ConstruyeSmart</title>
    <asset:stylesheet src="tutorial.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>${tutorial.title}</h1>
            <div>
                <g:if test="${springSecurityService.currentUser}">
                    <g:link controller="favorite" action="toggle" id="${tutorial.id}" class="btn btn-outline-danger me-2">
                        <i class="fas fa-heart${Favorite.findByUserAndTutorial(springSecurityService.currentUser, tutorial) ? '' : '-o'}"></i>
                        Favorito
                    </g:link>
                </g:if>
                <g:if test="${tutorial.author == springSecurityService.currentUser}">
                    <g:link action="edit" id="${tutorial.id}" class="btn btn-primary me-2">Editar</g:link>
                </g:if>
                <g:link action="index" class="btn btn-secondary">Volver</g:link>
            </div>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <g:if test="${tutorial.imageUrl}">
                            <img src="${tutorial.imageUrl}" class="img-fluid rounded mb-3" alt="${tutorial.title}">
                        </g:if>
                        <p class="card-text">${tutorial.description}</p>
                        <div class="mb-3">
                            <span class="badge bg-info">${tutorial.difficultyLevel}</span>
                            <span class="badge bg-secondary">${tutorial.estimatedTime}</span>
                        </div>
                        <div class="tutorial-meta">
                            <span><i class="fas fa-user"></i> ${tutorial.author.username}</span>
                            <span><i class="fas fa-eye"></i> ${tutorial.views} vistas</span>
                            <span><i class="fas fa-calendar"></i> <g:formatDate date="${tutorial.dateCreated}" format="dd/MM/yyyy"/></span>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Materiales Necesarios</h5>
                        <div class="tutorial-materials">
                            <ul>
                                <g:each in="${tutorial.requiredMaterials}" var="material">
                                    <li>${material}</li>
                                </g:each>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Herramientas Necesarias</h5>
                        <div class="tutorial-tools">
                            <ul>
                                <g:each in="${tutorial.requiredTools}" var="tool">
                                    <li>${tool}</li>
                                </g:each>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Pasos a Seguir</h5>
                        <div class="tutorial-steps">
                            <g:each in="${tutorial.steps}" var="step">
                                <div class="tutorial-step">${step}</div>
                            </g:each>
                        </div>
                        <g:if test="${tutorial.author == springSecurityService.currentUser}">
                            <form id="addStepForm" data-tutorial-id="${tutorial.id}" class="mt-3">
                                <div class="input-group">
                                    <input type="text" name="step" class="form-control" placeholder="Añadir nuevo paso...">
                                    <button type="submit" class="btn btn-primary">Añadir Paso</button>
                                </div>
                            </form>
                        </g:if>
                    </div>
                </div>

                <g:if test="${tutorial.videoUrl}">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Video Tutorial</h5>
                            <div class="ratio ratio-16x9">
                                <iframe src="${tutorial.videoUrl}" allowfullscreen></iframe>
                            </div>
                        </div>
                    </div>
                </g:if>

                <g:if test="${tutorial.allowComments}">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Comentarios</h5>
                            <g:if test="${springSecurityService.currentUser}">
                                <g:form controller="comment" action="save" params="[tutorialId: tutorial.id]" class="mb-4">
                                    <div class="mb-3">
                                        <label for="content" class="form-label">Deja tu comentario</label>
                                        <g:textArea name="content" class="form-control" rows="3" required="true"/>
                                    </div>
                                    <g:submitButton name="submit" class="btn btn-primary" value="Publicar Comentario"/>
                                </g:form>
                            </g:if>
                            <g:else>
                                <div class="alert alert-info">
                                    <g:link controller="login" action="auth">Inicia sesión</g:link> para dejar un comentario
                                </div>
                            </g:else>

                            <div class="comments-section">
                                <g:each in="${tutorial.comments.sort { it.dateCreated }}" var="comment">
                                    <div class="comment mb-3">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <strong>${comment.author.username}</strong>
                                                <small class="text-muted ms-2">
                                                    <g:formatDate date="${comment.dateCreated}" format="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                            <g:if test="${comment.author == springSecurityService.currentUser || tutorial.author == springSecurityService.currentUser}">
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-link" type="button" data-bs-toggle="dropdown">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <g:if test="${comment.author == springSecurityService.currentUser}">
                                                            <li>
                                                                <g:link controller="comment" action="edit" id="${comment.id}" class="dropdown-item">
                                                                    <i class="fas fa-edit"></i> Editar
                                                                </g:link>
                                                            </li>
                                                        </g:if>
                                                        <li>
                                                            <g:link controller="comment" action="delete" id="${comment.id}" class="dropdown-item text-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar este comentario?')">
                                                                <i class="fas fa-trash"></i> Eliminar
                                                            </g:link>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </g:if>
                                        </div>
                                        <p class="mb-0">${comment.content}</p>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                    </div>
                </g:if>
            </div>

            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Valoración</h5>
                        <div class="rating-stars" data-tutorial-id="${tutorial.id}">
                            <g:each in="${1..5}" var="i">
                                <i class="fas fa-star${i <= tutorial.rating ? '' : '-o'}"></i>
                            </g:each>
                        </div>
                        <p class="text-muted mt-2">${tutorial.ratingCount} valoraciones</p>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Etiquetas</h5>
                        <div class="tutorial-tags">
                            <g:each in="${tutorial.tags}" var="tag">
                                <span class="badge bg-secondary">${tag}</span>
                            </g:each>
                        </div>
                    </div>
                </div>

                <g:if test="${relatedVideos}">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Videos Relacionados</h5>
                            <div class="related-videos">
                                <g:each in="${relatedVideos}" var="video">
                                    <div class="card related-video-card mb-3">
                                        <img src="${video.thumbnail}" class="card-img-top" alt="${video.title}">
                                        <div class="card-body">
                                            <h6 class="card-title">${video.title}</h6>
                                            <p class="card-text"><small class="text-muted">${video.channel}</small></p>
                                            <a href="${video.url}" target="_blank" class="btn btn-sm btn-primary">Ver Video</a>
                                        </div>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>
    </div>

    <asset:javascript src="tutorial.js"/>
</body>
</html> 