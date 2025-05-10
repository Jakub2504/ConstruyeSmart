<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Editar ${tutorial.title} - ConstruyeSmart</title>
    <asset:stylesheet src="tutorial.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Editar ${tutorial.title}</h1>
            <g:link action="show" id="${tutorial.id}" class="btn btn-secondary">Volver</g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <g:form action="update" id="${tutorial.id}" method="PUT">
            <div class="row">
                <div class="col-md-8">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Información Básica</h5>
                            <div class="mb-3">
                                <label for="title" class="form-label">Título</label>
                                <g:textField name="title" class="form-control" value="${tutorial.title}" required="true"/>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Descripción</label>
                                <g:textArea name="description" class="form-control" rows="3" value="${tutorial.description}" required="true"/>
                            </div>
                            <div class="mb-3">
                                <label for="difficultyLevel" class="form-label">Nivel de Dificultad</label>
                                <g:select name="difficultyLevel" class="form-select" from="['Principiante', 'Intermedio', 'Avanzado']" value="${tutorial.difficultyLevel}" required="true"/>
                            </div>
                            <div class="mb-3">
                                <label for="estimatedTime" class="form-label">Tiempo Estimado</label>
                                <g:textField name="estimatedTime" class="form-control" value="${tutorial.estimatedTime}" required="true"/>
                            </div>
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">URL de la Imagen</label>
                                <g:textField name="imageUrl" class="form-control" value="${tutorial.imageUrl}"/>
                            </div>
                            <div class="mb-3">
                                <label for="videoUrl" class="form-label">URL del Video (opcional)</label>
                                <g:textField name="videoUrl" class="form-control" value="${tutorial.videoUrl}"/>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Materiales y Herramientas</h5>
                            <div class="mb-3">
                                <label for="requiredMaterials" class="form-label">Materiales Necesarios</label>
                                <g:textArea name="requiredMaterials" class="form-control" rows="3" value="${tutorial.requiredMaterials?.join('\n')}"/>
                            </div>
                            <div class="mb-3">
                                <label for="requiredTools" class="form-label">Herramientas Necesarias</label>
                                <g:textArea name="requiredTools" class="form-control" rows="3" value="${tutorial.requiredTools?.join('\n')}"/>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Pasos del Tutorial</h5>
                            <div class="mb-3">
                                <label for="steps" class="form-label">Pasos a Seguir</label>
                                <g:textArea name="steps" class="form-control" rows="5" value="${tutorial.steps?.join('\n')}" required="true"/>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Etiquetas</h5>
                            <div class="mb-3">
                                <label for="tags" class="form-label">Etiquetas (separadas por comas)</label>
                                <g:textField name="tags" class="form-control" value="${tutorial.tags?.join(', ')}"/>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Configuración</h5>
                            <div class="mb-3">
                                <div class="form-check">
                                    <g:checkBox name="isPublic" class="form-check-input" value="${tutorial.isPublic}"/>
                                    <label class="form-check-label" for="isPublic">Tutorial Público</label>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="form-check">
                                    <g:checkBox name="allowComments" class="form-check-input" value="${tutorial.allowComments}"/>
                                    <label class="form-check-label" for="allowComments">Permitir Comentarios</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <g:link action="show" id="${tutorial.id}" class="btn btn-secondary me-2">Cancelar</g:link>
                <g:submitButton name="update" class="btn btn-primary" value="Guardar Cambios"/>
            </div>
        </g:form>
    </div>
</body>
</html> 