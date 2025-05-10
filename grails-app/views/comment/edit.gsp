<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Editar Comentario - ConstruyeSmart</title>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Editar Comentario</h1>
            <g:link controller="tutorial" action="show" id="${comment.tutorial.id}" class="btn btn-secondary">Volver</g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <g:form controller="comment" action="update" id="${comment.id}" method="PUT">
            <div class="card">
                <div class="card-body">
                    <div class="mb-3">
                        <label for="content" class="form-label">Comentario</label>
                        <g:textArea name="content" class="form-control" rows="3" value="${comment.content}" required="true"/>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex justify-content-end">
                        <g:link controller="tutorial" action="show" id="${comment.tutorial.id}" class="btn btn-secondary me-2">Cancelar</g:link>
                        <g:submitButton name="update" class="btn btn-primary" value="Guardar Cambios"/>
                    </div>
                </div>
            </div>
        </g:form>
    </div>
</body>
</html> 