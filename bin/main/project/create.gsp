<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Nuevo Proyecto - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
    <asset:javascript src="project.js"/>
</head>
<body>
    <div class="project-container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><g:link action="index"><i class="fas fa-home"></i> Mis Proyectos</g:link></li>
                <li class="breadcrumb-item active" aria-current="page">Nuevo Proyecto</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="project-card">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-plus-circle"></i> Crear Nuevo Proyecto</h4>
                    </div>
                    <div class="card-body">
                        <g:if test="${flash.message}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i> ${flash.message}
                            </div>
                        </g:if>

                        <g:form action="save" method="POST" class="needs-validation" novalidate="novalidate">
                            <!-- Información Básica -->
                            <div class="field-group">
                                <h5 class="field-group-title"><i class="fas fa-info-circle"></i> Información Básica</h5>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="name" class="form-label required-field">Nombre del Proyecto</label>
                                        <input type="text" class="form-control" id="name" name="name" required
                                               placeholder="Ingrese el nombre del proyecto">
                                        <div class="invalid-feedback">
                                            Por favor ingresa un nombre para el proyecto.
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="description" class="form-label">Descripción</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"
                                                  placeholder="Describe brevemente el proyecto"></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Detalles del Proyecto -->
                            <div class="field-group">
                                <h5 class="field-group-title"><i class="fas fa-tasks"></i> Detalles del Proyecto</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="status" class="form-label required-field">Estado</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="PLANIFICACION">Planificación</option>
                                            <option value="EN_PROGRESO">En Progreso</option>
                                            <option value="COMPLETADO">Completado</option>
                                            <option value="CANCELADO">Cancelado</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="budget" class="form-label">Presupuesto (€)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">€</span>
                                            <input type="number" class="form-control" id="budget" name="budget" 
                                                   min="0" step="0.01" placeholder="0.00">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="startDate" class="form-label">Fecha de Inicio</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="estimatedEndDate" class="form-label">Fecha Estimada de Fin</label>
                                        <input type="date" class="form-control" id="estimatedEndDate" name="estimatedEndDate">
                                    </div>
                                </div>
                            </div>

                            <!-- Ubicación -->
                            <div class="field-group">
                                <h5 class="field-group-title"><i class="fas fa-map-marker-alt"></i> Ubicación</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="location" class="form-label">Ubicación</label>
                                        <input type="text" class="form-control" id="location" name="location"
                                               placeholder="Ciudad, Provincia, etc.">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="address" class="form-label">Dirección</label>
                                        <input type="text" class="form-control" id="address" name="address"
                                               placeholder="Dirección completa">
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="latitude" class="form-label">Latitud</label>
                                        <input type="number" class="form-control" id="latitude" name="latitude" 
                                               step="any" placeholder="0.000000">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="longitude" class="form-label">Longitud</label>
                                        <input type="number" class="form-control" id="longitude" name="longitude" 
                                               step="any" placeholder="0.000000">
                                    </div>
                                </div>
                            </div>

                            <!-- Recursos -->
                            <div class="field-group">
                                <h5 class="field-group-title"><i class="fas fa-tools"></i> Recursos</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="requiredTools" class="form-label">Herramientas Necesarias</label>
                                        <textarea class="form-control" id="requiredTools" name="requiredTools" 
                                                  rows="2" placeholder="Separar por comas"></textarea>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="requiredMaterials" class="form-label">Materiales Necesarios</label>
                                        <textarea class="form-control" id="requiredMaterials" name="requiredMaterials" 
                                                  rows="2" placeholder="Separar por comas"></textarea>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="steps" class="form-label">Pasos del Proyecto</label>
                                    <textarea class="form-control" id="steps" name="steps" rows="5" 
                                              placeholder="Un paso por línea"></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="imageUrl" class="form-label">URL de la Imagen</label>
                                    <input type="url" class="form-control" id="imageUrl" name="imageUrl"
                                           placeholder="https://ejemplo.com/imagen.jpg">
                                </div>
                            </div>

                            <!-- Botones de Acción -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                <g:link action="index" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times"></i> Cancelar
                                </g:link>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Crear Proyecto
                                </button>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        })

        // Validación del formulario
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html> 