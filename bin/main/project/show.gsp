<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><g:link action="index">Mis Proyectos</g:link></li>
                <li class="breadcrumb-item active" aria-current="page">${project.name}</li>
            </ol>
        </nav>

        <g:if test="${flash.message}">
            <div class="alert alert-info">${flash.message}</div>
        </g:if>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <g:if test="${project.imageUrl}">
                        <img src="${project.imageUrl}" class="card-img-top" alt="${project.name}">
                    </g:if>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="card-title h3">${project.name}</h1>
                            <div>
                                <g:link action="edit" id="${project.id}" class="btn btn-outline-primary">
                                    <i class="fas fa-edit"></i> Editar
                                </g:link>
                                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                    <i class="fas fa-trash"></i> Eliminar
                                </button>
                            </div>
                        </div>
                        
                        <p class="card-text">${project.description}</p>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h5 class="mb-2">Información del Proyecto</h5>
                                <ul class="list-unstyled">
                                    <li><strong>Estado:</strong> 
                                        <span class="badge bg-${project.status == 'PLANIFICACION' ? 'info' : project.status == 'EN_PROGRESO' ? 'warning' : project.status == 'COMPLETADO' ? 'success' : 'danger'}">
                                            ${project.status}
                                        </span>
                                    </li>
                                    <li><strong>Ubicación:</strong> ${project.location ?: 'No especificada'}</li>
                                    <li><strong>Dirección:</strong> ${project.address ?: 'No especificada'}</li>
                                    <li><strong>Fecha de inicio:</strong> <g:formatDate date="${project.startDate}" format="dd/MM/yyyy"/></li>
                                    <li><strong>Fecha estimada de fin:</strong> <g:formatDate date="${project.estimatedEndDate}" format="dd/MM/yyyy"/></li>
                                    <g:if test="${project.actualEndDate}">
                                        <li><strong>Fecha real de fin:</strong> <g:formatDate date="${project.actualEndDate}" format="dd/MM/yyyy"/></li>
                                    </g:if>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h5 class="mb-2">Presupuesto y Costos</h5>
                                <ul class="list-unstyled">
                                    <li><strong>Presupuesto:</strong> ${project.budget ?: 'No especificado'}€</li>
                                    <li><strong>Costo actual:</strong> ${project.actualCost ?: 'No especificado'}€</li>
                                    <li><strong>Progreso:</strong>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" 
                                                 style="width: ${projectService.calculateProjectProgress(project)}%" 
                                                 aria-valuenow="${projectService.calculateProjectProgress(project)}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100">
                                                ${Math.round(projectService.calculateProjectProgress(project))}%
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Tareas</h5>
                    </div>
                    <div class="card-body">
                        <g:if test="${project.tasks}">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Estado</th>
                                            <th>Prioridad</th>
                                            <th>Asignado a</th>
                                            <th>Horas</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in="${project.tasks}" var="task">
                                            <tr>
                                                <td>${task.name}</td>
                                                <td>
                                                    <span class="badge bg-${task.status == 'COMPLETADA' ? 'success' : task.status == 'EN_PROGRESO' ? 'warning' : 'secondary'}">
                                                        ${task.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-${task.priority == 3 ? 'danger' : task.priority == 2 ? 'warning' : 'info'}">
                                                        ${task.priority == 3 ? 'Alta' : task.priority == 2 ? 'Media' : 'Baja'}
                                                    </span>
                                                </td>
                                                <td>${task.assignedTo ?: 'No asignado'}</td>
                                                <td>${task.actualHours ?: 0}/${task.estimatedHours ?: 0}</td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#taskModal${task.id}">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                        </g:if>
                        <g:else>
                            <p class="text-muted">No hay tareas registradas.</p>
                        </g:else>
                        <g:link action="addTask" id="${project.id}" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Agregar Tarea
                        </g:link>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Materiales</h5>
                    </div>
                    <div class="card-body">
                        <g:if test="${project.materials}">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Cantidad</th>
                                            <th>Precio Unitario</th>
                                            <th>Total</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in="${project.materials}" var="material">
                                            <tr>
                                                <td>${material.name}</td>
                                                <td>${material.quantity} ${material.unit}</td>
                                                <td>${material.unitPrice}€</td>
                                                <td>${material.totalPrice}€</td>
                                                <td>
                                                    <span class="badge bg-${material.status == 'ENTREGADO' ? 'success' : material.status == 'COMPRADO' ? 'warning' : 'secondary'}">
                                                        ${material.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#materialModal${material.id}">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                        </g:if>
                        <g:else>
                            <p class="text-muted">No hay materiales registrados.</p>
                        </g:else>
                        <g:link action="addMaterial" id="${project.id}" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Agregar Material
                        </g:link>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Notas</h5>
                    </div>
                    <div class="card-body">
                        <g:if test="${project.notes}">
                            <div class="list-group">
                                <g:each in="${project.notes}" var="note">
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h6 class="mb-1">${note.title}</h6>
                                            <span class="badge bg-${note.priority == 'ALTA' ? 'danger' : note.priority == 'MEDIA' ? 'warning' : 'info'}">
                                                ${note.priority}
                                            </span>
                                        </div>
                                        <p class="mb-1">${note.content}</p>
                                        <small class="text-muted">
                                            <g:formatDate date="${note.dateCreated}" format="dd/MM/yyyy HH:mm"/>
                                            <g:if test="${note.isImportant}">
                                                <i class="fas fa-star text-warning ms-2"></i>
                                            </g:if>
                                        </small>
                                    </div>
                                </g:each>
                            </div>
                        </g:if>
                        <g:else>
                            <p class="text-muted">No hay notas registradas.</p>
                        </g:else>
                        <g:link action="addNote" id="${project.id}" class="btn btn-primary mt-3">
                            <i class="fas fa-plus"></i> Agregar Nota
                        </g:link>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Línea de Tiempo</h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <g:each in="${projectService.getProjectTimeline(project)}" var="event">
                                <div class="timeline-item">
                                    <div class="timeline-marker bg-${event.type == 'start' ? 'primary' : event.type == 'end' ? 'success' : event.type == 'estimated' ? 'warning' : 'info'}"></div>
                                    <div class="timeline-content">
                                        <h6 class="mb-0">${event.event}</h6>
                                        <small class="text-muted">
                                            <g:formatDate date="${event.date}" format="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                </div>
                            </g:each>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Estadísticas</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Tareas</h6>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" 
                                     style="width: ${project.tasks?.count { it.status == 'COMPLETADA' } / (project.tasks?.size() ?: 1) * 100}%" 
                                     aria-valuenow="${project.tasks?.count { it.status == 'COMPLETADA' } / (project.tasks?.size() ?: 1) * 100}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    ${project.tasks?.count { it.status == 'COMPLETADA' } ?: 0}/${project.tasks?.size() ?: 0}
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <h6>Materiales</h6>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" 
                                     style="width: ${project.materials?.count { it.status == 'ENTREGADO' } / (project.materials?.size() ?: 1) * 100}%" 
                                     aria-valuenow="${project.materials?.count { it.status == 'ENTREGADO' } / (project.materials?.size() ?: 1) * 100}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    ${project.materials?.count { it.status == 'ENTREGADO' } ?: 0}/${project.materials?.size() ?: 0}
                                </div>
                            </div>
                        </div>
                        <div>
                            <h6>Presupuesto</h6>
                            <div class="progress">
                                <div class="progress-bar bg-${project.actualCost > project.budget ? 'danger' : 'success'}" role="progressbar" 
                                     style="width: ${project.actualCost / (project.budget ?: 1) * 100}%" 
                                     aria-valuenow="${project.actualCost / (project.budget ?: 1) * 100}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    ${project.actualCost ?: 0}€/${project.budget ?: 0}€
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de Eliminación -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Estás seguro de que deseas eliminar el proyecto "${project.name}"? Esta acción no se puede deshacer.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <g:link action="delete" id="${project.id}" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Eliminar
                    </g:link>
                </div>
            </div>
        </div>
    </div>

    <asset:javascript src="project.js"/>
</body>
</html> 