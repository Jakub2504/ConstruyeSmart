<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Planificador de Tareas</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="container mt-4">
        <!-- Título principal -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="display-5">
                    <i class="bi bi-calendar-check text-primary me-2"></i>
                    Planificador de Tareas
                </h1>
                <p class="lead">Organiza tus tareas y proyectos de forma eficiente</p>
            </div>
        </div>

        <!-- Panel de Búsqueda y Filtros -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="bi bi-funnel me-1"></i> Filtrar Tareas
            </div>
            <div class="card-body">
                <form action="${createLink(action:'index')}" method="get" class="row g-3">
                    <!-- Buscador -->
                    <div class="col-md-12 mb-3">
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="searchText" value="${currentSearchText}" class="form-control" placeholder="Buscar por nombre o descripción"/>
                        </div>
                    </div>

                    <!-- Filtros principales -->
                    <div class="col-md-3">
                        <label for="status" class="form-label">Estado</label>
                        <select name="status" class="form-select">
                            <option value="Todos" ${currentStatus == 'Todos' ? 'selected' : ''}>Todos</option>
                            <g:if test="${statuses}">
                                <g:each in="${statuses}" var="status">
                                    <option value="${status}" ${currentStatus == status ? 'selected' : ''}>${status}</option>
                                </g:each>
                            </g:if>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="priority" class="form-label">Prioridad</label>
                        <select name="priority" class="form-select">
                            <option value="Todas" ${currentPriority == 'Todas' ? 'selected' : ''}>Todas</option>
                            <g:if test="${priorities}">
                                <g:each in="${priorities}" var="priority">
                                    <option value="${priority}" ${currentPriority == priority ? 'selected' : ''}>${priority}</option>
                                </g:each>
                            </g:if>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="projectId" class="form-label">Proyecto</label>
                        <select name="projectId" class="form-select">
                            <option value="Todos" ${currentProjectId == 'Todos' || !currentProjectId ? 'selected' : ''}>Todos los Proyectos</option>
                            <g:if test="${projects}">
                                <g:each in="${projects}" var="proj">
                                    <option value="${proj.id}" ${currentProjectId == proj.id.toString() ? 'selected' : ''}>
                                        ${proj.name?.encodeAsHTML()}
                                    </option>
                                </g:each>
                            </g:if>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="sortBy" class="form-label">Ordenar por</label>
                        <div class="input-group">
                            <select name="sortBy" class="form-select">
                                <option value="dateCreated" ${currentSort == 'dateCreated' ? 'selected' : ''}>Fecha Creación</option>
                                <option value="name" ${currentSort == 'name' ? 'selected' : ''}>Nombre</option>
                                <option value="status" ${currentSort == 'status' ? 'selected' : ''}>Estado</option>
                                <option value="priority" ${currentSort == 'priority' ? 'selected' : ''}>Prioridad</option>
                                <option value="startDate" ${currentSort == 'startDate' ? 'selected' : ''}>Fecha Inicio</option>
                            </select>
                            <select name="order" class="form-select">
                                <option value="asc" ${currentOrder == 'asc' ? 'selected' : ''}>Ascendente</option>
                                <option value="desc" ${currentOrder == 'desc' ? 'selected' : ''}>Descendente</option>
                            </select>
                        </div>
                    </div>

                    <!-- Filtros avanzados -->
                    <div class="col-12">
                        <a class="btn btn-link p-0 mb-2" data-bs-toggle="collapse" href="#advancedFilters" role="button">
                            <i class="bi bi-chevron-down"></i> Filtros avanzados
                        </a>
                        <div class="collapse" id="advancedFilters">
                            <div class="row g-3 mt-1">
                                <div class="col-md-6">
                                    <label for="startDateFilter" class="form-label">Fecha inicio desde</label>
                                    <input type="date" name="startDateFilter" value="${currentStartDate}" class="form-control"/>
                                </div>
                                <div class="col-md-6">
                                    <label for="endDateFilter" class="form-label">Fecha fin hasta</label>
                                    <input type="date" name="endDateFilter" value="${currentEndDate}" class="form-control"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de acción -->
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-funnel-fill me-1"></i> Aplicar Filtros
                        </button>
                        <a href="${createLink(action:'index')}" class="btn btn-outline-secondary ms-2">
                            <i class="bi bi-x-circle me-1"></i> Limpiar Filtros
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Panel de Estadísticas -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="bi bi-bar-chart me-1"></i> Resumen de Tareas
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Total</h5>
                                <p class="card-text fs-2">${tasks?.size() ?: 0}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-dark mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Pendientes</h5>
                                <p class="card-text fs-2">${tasks?.count { it.status == 'Pendiente' } ?: 0}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-dark mb-3">
                            <div class="card-body">
                                <h5 class="card-title">En Progreso</h5>
                                <p class="card-text fs-2">${tasks?.count { it.status == 'En Progreso' } ?: 0}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Completadas</h5>
                                <p class="card-text fs-2">${tasks?.count { it.status == 'Completada' } ?: 0}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de Tareas -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                    <i class="bi bi-list-task me-1"></i> Mis Tareas
                    <span class="badge bg-primary ms-2">${tasks?.size() ?: 0}</span>
                </div>
                <button type="button" class="btn btn-primary" onclick="newTask()">
                    <i class="bi bi-plus-circle me-1"></i> Nueva Tarea
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="taskTable">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Proyecto</th>
                                <th>Estado</th>
                                <th>Prioridad</th>
                                <th>Fechas</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${tasks && !tasks.isEmpty()}">
                                <g:each in="${tasks}" var="task">
                                    <tr data-task-id="${task.id}">
                                        <td>
                                            <div class="fw-bold">${task.name?.encodeAsHTML()}</div>
                                            <g:if test="${task.description}">
                                                <div class="small text-muted">${task.description?.length() > 50 ? task.description?.substring(0, 50) + '...' : task.description}</div>
                                            </g:if>
                                        </td>
                                        <td>${task.projectName ?: 'Sin proyecto'}</td>
                                        <td>
                                            <span class="badge ${task.status == 'Completada' ? 'bg-success' :
                                                            task.status == 'En Progreso' ? 'bg-primary' :
                                                            task.status == 'Cancelada' ? 'bg-danger' : 'bg-warning'}">
                                                ${task.status}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${task.priority == 'Alta' ? 'bg-danger' :
                                                            task.priority == 'Media' ? 'bg-warning' :
                                                            task.priority == 'Urgente' ? 'bg-dark' : 'bg-info'}">
                                                ${task.priority}
                                            </span>
                                        </td>
                                        <td>
                                            <!-- Reemplazar la línea problemática (alrededor de la línea 222) -->
                                            <!-- Versión original que causa el error: -->
                                            <!-- <g:formatDate date="${task.startDate}" format="dd/MM/yyyy" /> -->

                                            <!-- Versión corregida que verifica si el valor es una fecha o un string: -->
                                            <g:if test="${task.startDateFormatted}">
                                                ${task.startDateFormatted}
                                            </g:if>
                                            <g:elseif test="${task.startDate instanceof Date}">
                                                <g:formatDate date="${task.startDate}" format="dd/MM/yyyy" />
                                            </g:elseif>
                                            <g:elseif test="${task.startDate}">
                                                ${task.startDate}
                                            </g:elseif>
                                            <g:else>
                                                Sin fecha
                                            </g:else>
                                            <g:if test="${task.endDate}">
                                                <div>
                                                    <i class="bi bi-calendar-check me-1"></i>
                                                    <!-- Reemplazar cualquier otra g:formatDate similar para endDate -->
                                                    <g:if test="${task.endDateFormatted}">
                                                        ${task.endDateFormatted}
                                                    </g:if>
                                                    <g:elseif test="${task.endDate instanceof Date}">
                                                        <g:formatDate date="${task.endDate}" format="dd/MM/yyyy" />
                                                    </g:elseif>
                                                    <g:elseif test="${task.endDate}">
                                                        ${task.endDate}
                                                    </g:elseif>
                                                    <g:else>
                                                        Sin fecha
                                                    </g:else>
                                                </div>
                                            </g:if>
                                            <g:if test="${!task.startDate && !task.endDate}">
                                                <span class="text-muted">Sin fechas</span>
                                            </g:if>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-sm btn-info" onclick="editTask('${task.id}')" title="Editar">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete('${task.id}')" title="Eliminar">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:if>
                            <g:else>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <div class="alert alert-info mb-0">
                                            <i class="bi bi-info-circle me-2"></i> No hay tareas que coincidan con los criterios de búsqueda.
                                            <g:if test="${params.searchText || params.status || params.priority || params.projectId || params.startDateFilter || params.endDateFilter}">
                                                <div class="mt-2">
                                                    <a href="${createLink(action:'index')}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-x-circle me-1"></i> Limpiar Filtros
                                                    </a>
                                                </div>
                                            </g:if>
                                            <g:else>
                                                <div class="mt-2">
                                                    Empiece creando una nueva tarea con el botón "Nueva Tarea".
                                                </div>
                                            </g:else>
                                        </div>
                                    </td>
                                </tr>
                            </g:else>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Paginación (añadir después de la tabla) -->
        <g:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                    Mostrando ${(currentPage - 1) * perPage + 1} - ${Math.min(currentPage * perPage, totalTasks)} de ${totalTasks} tareas
                </div>
                <nav aria-label="Paginación de tareas">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a href="${createLink(action:'index', params:params + [page: 1])}" class="page-link">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a href="${createLink(action:'index', params:params + [page: Math.max(1, currentPage - 1)])}" class="page-link">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>

                        <g:if test="${totalPages <= 5}">
                            <g:each in="${1..totalPages}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a href="${createLink(action:'index', params:params + [page: p])}" class="page-link">${p}</a>
                                </li>
                            </g:each>
                        </g:if>
                        <g:else>
                            <!-- Mostrar primeras páginas, página actual y últimas páginas -->
                            <g:if test="${currentPage > 3}">
                                <li class="page-item">
                                    <a href="${createLink(action:'index', params:params + [page: 1])}" class="page-link">1</a>
                                </li>
                                <g:if test="${currentPage > 4}">
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                </g:if>
                            </g:if>

                            <g:each in="${Math.max(1, currentPage - 1)..Math.min(totalPages, currentPage + 1)}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a href="${createLink(action:'index', params:params + [page: p])}" class="page-link">${p}</a>
                                </li>
                            </g:each>

                            <g:if test="${currentPage < totalPages - 2}">
                                <g:if test="${currentPage < totalPages - 3}">
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                </g:if>
                                <li class="page-item">
                                    <a href="${createLink(action:'index', params:params + [page: totalPages])}" class="page-link">${totalPages}</a>
                                </li>
                            </g:if>
                        </g:else>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a href="${createLink(action:'index', params:params + [page: Math.min(totalPages, currentPage + 1)])}" class="page-link">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a href="${createLink(action:'index', params:params + [page: totalPages])}" class="page-link">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="d-flex align-items-center">
                    <label for="perPageSelect" class="me-2">Por página:</label>
                    <select id="perPageSelect" class="form-select form-select-sm" style="width: auto;" onchange="changePerPage(this.value)">
                        <option value="10" ${perPage == 10 ? 'selected' : ''}>10</option>
                        <option value="25" ${perPage == 25 ? 'selected' : ''}>25</option>
                        <option value="50" ${perPage == 50 ? 'selected' : ''}>50</option>
                        <option value="100" ${perPage == 100 ? 'selected' : ''}>100</option>
                    </select>
                </div>
            </div>
        </g:if>

        <script>
        // Función para cambiar elementos por página
        function changePerPage(value) {
            const url = new URL(window.location.href);
            url.searchParams.set('perPage', value);
            url.searchParams.set('page', 1); // Volver a la primera página
            window.location.href = url.toString();
        }
        </script>

        <!-- Próximas tareas -->
        <g:if test="${tasks && !tasks.isEmpty()}">
            <div class="mt-4">
                <h3>Próximas tareas</h3>
                <div class="row">
                    <g:each in="${tasks.findAll { it.status != 'Completada' && it.status != 'Cancelada' }.take(3)}" var="task">
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 ${task.priority == 'Alta' || task.priority == 'Urgente' ? 'border-danger' : ''}">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">${task.name}</h5>
                                    <span class="badge ${task.status == 'En Progreso' ? 'bg-primary' : 'bg-warning'}">${task.status}</span>
                                </div>
                                <div class="card-body">
                                    <p class="card-text">${task.description ?: 'Sin descripción'}</p>
                                    <p class="mb-0"><strong>Prioridad:</strong> ${task.priority}</p>
                                    <p class="mb-0"><strong>Proyecto:</strong> ${task.projectName ?: 'Sin proyecto'}</p>
                                </div>
                                <div class="card-footer text-muted">
                                    <g:if test="${task.startDateFormatted}">
                                        ${task.startDateFormatted}
                                        <g:if test="${task.endDateFormatted}"> - ${task.endDateFormatted}</g:if>
                                    </g:if>
                                    <g:else>
                                        Sin fechas
                                    </g:else>
                                </div>
                            </div>
                        </div>
                    </g:each>
                </div>
            </div>
        </g:if>
    </div>

    <!-- Modal para crear/editar tareas -->
    <div class="modal fade" id="taskModal" tabindex="-1" aria-labelledby="taskModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="taskModalLabel">Nueva Tarea</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="taskForm">
                        <!-- Campo oculto para ID de tarea (edición) -->
                        <input type="hidden" id="taskId" name="id">

                        <!-- Nombre de la tarea -->
                        <div class="mb-3">
                            <label for="taskName" class="form-label">Nombre de la Tarea</label>
                            <input type="text" class="form-control" id="taskName" name="name" required>
                        </div>

                        <!-- Descripción -->
                        <div class="mb-3">
                            <label for="taskDescription" class="form-label">Descripción</label>
                            <textarea class="form-control" id="taskDescription" name="description" rows="3"></textarea>
                        </div>

                        <!-- Estado -->
                        <div class="mb-3">
                            <label for="taskStatus" class="form-label">Estado</label>
                            <select class="form-select" id="taskStatus" name="status">
                                <g:if test="${statuses}">
                                    <g:each in="${statuses}" var="status">
                                        <option value="${status}">${status}</option>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <option value="Pendiente">Pendiente</option>
                                    <option value="En Progreso">En Progreso</option>
                                    <option value="Completada">Completada</option>
                                    <option value="Cancelada">Cancelada</option>
                                </g:else>
                            </select>
                        </div>

                        <!-- Prioridad -->
                        <div class="mb-3">
                            <label for="taskPriority" class="form-label">Prioridad</label>
                            <select class="form-select" id="taskPriority" name="priority">
                                <g:if test="${priorities}">
                                    <g:each in="${priorities}" var="priority">
                                        <option value="${priority}">${priority}</option>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <option value="Baja">Baja</option>
                                    <option value="Media">Media</option>
                                    <option value="Alta">Alta</option>
                                    <option value="Urgente">Urgente</option>
                                </g:else>
                            </select>
                        </div>

                        <!-- Proyecto -->
                        <div class="mb-3">
                            <label for="projectId" class="form-label">Proyecto</label>
                            <select class="form-select" id="projectId" name="projectId">
                                <option value="">-- Seleccionar Proyecto --</option>
                                <g:if test="${projects}">
                                    <g:each in="${projects}" var="proj">
                                        <option value="${proj.id}" ${project?.id == proj.id ? 'selected' : ''}>
                                            ${proj.name?.encodeAsHTML()}
                                        </option>
                                    </g:each>
                                </g:if>
                            </select>
                        </div>

                        <!-- Fechas -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="taskStartDate" class="form-label">Fecha de Inicio</label>
                                <input type="date" class="form-control" id="taskStartDate" name="startDate">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="taskEndDate" class="form-label">Fecha de Fin</label>
                                <input type="date" class="form-control" id="taskEndDate" name="endDate">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" onclick="saveTask()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Contenedor para toasts/notificaciones -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3"></div>

    <!-- Incluir el JavaScript para manejar el formulario de tareas -->
    <asset:javascript src="planner.js"/>

    <!-- Modal de Confirmación para Eliminar -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>¿Está seguro de que desea eliminar esta tarea? Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteButton" onclick="deleteTask()">Eliminar</button>
                </div>
            </div>
        </div>
    </div>

<!-- Modales para crear/editar tareas (mantener estos sin cambios) -->
</body>
</html>