<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Agregar Tarea - ${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><g:link action="index">Mis Proyectos</g:link></li>
                <li class="breadcrumb-item"><g:link action="show" id="${project.id}">${project.name}</g:link></li>
                <li class="breadcrumb-item active" aria-current="page">Agregar Tarea</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Agregar Tarea a ${project.name}</h4>
                    </div>
                    <div class="card-body">
                        <g:form action="saveTask" method="POST" class="needs-validation" novalidate="novalidate">
                            <g:hiddenField name="projectId" value="${project.id}"/>

                            <div class="mb-3">
                                <label for="name" class="form-label">Nombre de la Tarea</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                                <div class="invalid-feedback">
                                    Por favor ingresa un nombre para la tarea.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Descripción</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="status" class="form-label">Estado</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="PENDIENTE">Pendiente</option>
                                        <option value="EN_PROGRESO">En Progreso</option>
                                        <option value="COMPLETADA">Completada</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="priority" class="form-label">Prioridad</label>
                                    <select class="form-select" id="priority" name="priority" required>
                                        <option value="1">Baja</option>
                                        <option value="2">Media</option>
                                        <option value="3">Alta</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Fecha de Inicio</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="estimatedEndDate" class="form-label">Fecha Estimada de Fin</label>
                                    <input type="date" class="form-control" id="estimatedEndDate" name="estimatedEndDate">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="estimatedHours" class="form-label">Horas Estimadas</label>
                                    <input type="number" class="form-control" id="estimatedHours" name="estimatedHours" min="0" required>
                                    <div class="invalid-feedback">
                                        Por favor ingresa un número válido de horas estimadas.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="assignedTo" class="form-label">Asignado a</label>
                                    <input type="text" class="form-control" id="assignedTo" name="assignedTo">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="notes" class="form-label">Notas</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <g:link action="show" id="${project.id}" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times"></i> Cancelar
                                </g:link>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Agregar Tarea
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