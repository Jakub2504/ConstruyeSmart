<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Editar ${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
<div class="container mt-4">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><g:link action="index"><i class="fas fa-home"></i> Mis Proyectos</g:link></li>
            <li class="breadcrumb-item"><g:link action="show" id="${project.id}">${project.name}</g:link></li>
            <li class="breadcrumb-item active" aria-current="page">Editar Proyecto</li>
        </ol>
    </nav>

<!-- Mensaje Flash -->
    <g:if test="${flash.message}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> ${flash.message}
        </div>
    </g:if>

<!-- Formulario de Edición -->
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h4><i class="fas fa-edit"></i> Editar ${project.name}</h4>
                </div>
                <div class="card-body">
                    <g:form action="update" method="POST" class="needs-validation" novalidate="novalidate">
                        <!-- Campo Oculto para el ID -->
                        <g:hiddenField name="id" value="${project.id}"/>

                        <!-- Información Básica -->
                        <div class="mb-3">
                            <label for="name" class="form-label required-field">Nombre del Proyecto</label>
                            <input type="text" class="form-control" id="name" name="name" value="${project.name}" required>
                            <div class="invalid-feedback">Por favor ingresa un nombre para el proyecto.</div>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Descripción</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${project.description}</textarea>
                        </div>

                        <!-- Detalles del Proyecto -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="status" class="form-label required-field">Estado</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="PLANIFICACION" ${project.status == 'PLANIFICACION' ? 'selected' : ''}>
                                        Planificación
                                    </option>
                                    <option value="EN_PROGRESO" ${project.status == 'EN_PROGRESO' ? 'selected' : ''}>
                                        En Progreso
                                    </option>
                                    <option value="COMPLETADO" ${project.status == 'COMPLETADO' ? 'selected' : ''}>
                                        Completado
                                    </option>
                                    <option value="CANCELADO" ${project.status == 'CANCELADO' ? 'selected' : ''}>
                                        Cancelado
                                    </option>
                                </select>
                                <div class="invalid-feedback">Por favor selecciona un estado.</div>
                            </div>
                            <div class="col-md-6">
                                <label for="budget" class="form-label">Presupuesto (€)</label>
                                <input type="number" class="form-control" id="budget" name="budget"
                                       value="${project.budget}" min="0" step="0.01">
                            </div>
                        </div>

                        <!-- Fechas -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startDate" class="form-label">Fecha de Inicio</label>
                                <input type="date" class="form-control" id="startDate" name="startDate"
                                       value="${project.startDate ? new SimpleDateFormat('yyyy-MM-dd').format(project.startDate) : ''}">
                            </div>
                            <div class="col-md-6">
                                <label for="estimatedEndDate" class="form-label">Fecha Estimada de Fin</label>
                                <input type="date" class="form-control" id="estimatedEndDate" name="estimatedEndDate"
                                       value="${project.estimatedEndDate ? new SimpleDateFormat('yyyy-MM-dd').format(project.estimatedEndDate) : ''}">
                            </div>
                        </div>

                        <!-- Ubicación -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="location" class="form-label">Ubicación</label>
                                <input type="text" class="form-control" id="location" name="location" value="${project.location}">
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Dirección</label>
                                <input type="text" class="form-control" id="address" name="address" value="${project.address}">
                            </div>
                        </div>

                        <!-- Coordenadas -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="latitude" class="form-label">Latitud</label>
                                <input type="number" class="form-control" id="latitude" name="latitude" value="${project.latitude}" step="any">
                            </div>
                            <div class="col-md-6">
                                <label for="longitude" class="form-label">Longitud</label>
                                <input type="number" class="form-control" id="longitude" name="longitude" value="${project.longitude}" step="any">
                            </div>
                        </div>

                        <!-- Imagen -->
                        <div class="mb-3">
                            <label for="imageUrl" class="form-label">URL de la Imagen</label>
                            <input type="url" class="form-control" id="imageUrl" name="imageUrl" value="${project.imageUrl}">
                        </div>

                        <!-- Botones -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <g:link action="show" id="${project.id}" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancelar
                            </g:link>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                        </div>
                    </g:form>
                </div>
            </div>
        </div>
    </div>
</div>

<asset:javascript src="project.js"/>
</body>
</html>