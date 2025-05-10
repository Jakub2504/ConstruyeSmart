<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Editar ${tool.name} - ConstruyeSmart</title>
    <asset:stylesheet src="tool.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Editar ${tool.name}</h1>
            <g:link action="show" id="${tool.id}" class="btn btn-secondary">Volver</g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <g:form action="update" id="${tool.id}" method="PUT">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Información Básica</h5>
                    <div class="mb-3">
                        <label for="name" class="form-label">Nombre</label>
                        <g:textField name="name" class="form-control" value="${tool.name}" required="true"/>
                    </div>
                    <div class="mb-3">
                        <label for="category" class="form-label">Categoría</label>
                        <g:select name="category" class="form-select" from="['Electricidad', 'Fontanería', 'Carpintería', 'Albañilería', 'Pintura', 'Jardinería', 'Otros']" value="${tool.category}" required="true"/>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Descripción</label>
                        <g:textArea name="description" class="form-control" rows="3" value="${tool.description}" required="true"/>
                    </div>
                    <div class="mb-3">
                        <label for="imageUrl" class="form-label">URL de la Imagen</label>
                        <g:textField name="imageUrl" class="form-control" value="${tool.imageUrl}"/>
                    </div>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Información de Alquiler</h5>
                    <div class="mb-3">
                        <div class="form-check">
                            <g:checkBox name="availableForRent" class="form-check-input" value="${tool.availableForRent}"/>
                            <label class="form-check-label" for="availableForRent">Disponible para alquiler</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="rentalPricePerDay" class="form-label">Precio por día (€)</label>
                        <g:textField name="rentalPricePerDay" class="form-control" value="${tool.rentalPricePerDay}" type="number" step="0.01"/>
                    </div>
                    <div class="mb-3">
                        <label for="rentalStore" class="form-label">Tienda de Alquiler</label>
                        <g:textField name="rentalStore" class="form-control" value="${tool.rentalStore}"/>
                    </div>
                    <div class="mb-3">
                        <label for="rentalLocation" class="form-label">Ubicación</label>
                        <g:textField name="rentalLocation" class="form-control" value="${tool.rentalLocation}"/>
                    </div>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Instrucciones</h5>
                    <div class="mb-3">
                        <label for="usageInstructions" class="form-label">Instrucciones de Uso</label>
                        <g:textArea name="usageInstructions" class="form-control" rows="4" value="${tool.usageInstructions}"/>
                    </div>
                    <div class="mb-3">
                        <label for="safetyInstructions" class="form-label">Instrucciones de Seguridad</label>
                        <g:textArea name="safetyInstructions" class="form-control" rows="4" value="${tool.safetyInstructions}"/>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end">
                <g:link action="show" id="${tool.id}" class="btn btn-secondary me-2">Cancelar</g:link>
                <g:submitButton name="update" class="btn btn-primary" value="Guardar Cambios"/>
            </div>
        </g:form>
    </div>
</body>
</html> 