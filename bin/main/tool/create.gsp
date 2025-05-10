<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Nueva Herramienta - ConstruyeSmart</title>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Nueva Herramienta</h1>
            <g:link action="index" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Volver
            </g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-danger">${flash.message}</div>
        </g:if>

        <g:form action="save" class="mt-4">
            <div class="row">
                <div class="col-md-6">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Información Básica</h5>
                            <div class="mb-3">
                                <label for="name" class="form-label">Nombre</label>
                                <g:textField name="name" class="form-control" required="true"/>
                            </div>

                            <div class="mb-3">
                                <label for="category" class="form-label">Categoría</label>
                                <g:select name="category" from="['Electricidad', 'Fontanería', 'Carpintería', 'Albañilería', 'Pintura', 'Jardinería']" 
                                    class="form-select" required="true"/>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Descripción</label>
                                <g:textArea name="description" class="form-control" rows="3"/>
                            </div>

                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">URL de la Imagen</label>
                                <g:textField name="imageUrl" class="form-control"/>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Información de Alquiler</h5>
                            <div class="mb-3">
                                <div class="form-check form-switch">
                                    <g:checkBox name="availableForRent" class="form-check-input"/>
                                    <label class="form-check-label" for="availableForRent">Disponible para alquiler</label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="rentalPricePerDay" class="form-label">Precio de Alquiler por Día (€)</label>
                                <g:field type="number" name="rentalPricePerDay" class="form-control" step="0.01" min="0"/>
                            </div>

                            <div class="mb-3">
                                <label for="rentalStore" class="form-label">Tienda de Alquiler</label>
                                <g:textField name="rentalStore" class="form-control"/>
                            </div>

                            <div class="mb-3">
                                <label for="rentalLocation" class="form-label">Ubicación</label>
                                <g:textField name="rentalLocation" class="form-control"/>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Instrucciones</h5>
                            <div class="mb-3">
                                <label for="usageInstructions" class="form-label">Instrucciones de Uso</label>
                                <g:textArea name="usageInstructions" class="form-control" rows="3"/>
                            </div>

                            <div class="mb-3">
                                <label for="safetyInstructions" class="form-label">Instrucciones de Seguridad</label>
                                <g:textArea name="safetyInstructions" class="form-control" rows="3"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <g:link action="index" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancelar
                </g:link>
                <g:submitButton name="create" class="btn btn-primary" value="Crear Herramienta">
                    <i class="fas fa-save"></i>
                </g:submitButton>
            </div>
        </g:form>
    </div>
</body>
</html> 