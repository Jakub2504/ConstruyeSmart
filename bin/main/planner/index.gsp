<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Planificador de Obra</title>
    <asset:javascript src="planner.js"/>
    <asset:stylesheet src="planner.css"/>
    <g:set var="dateFormat" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1><i class="fas fa-tasks"></i> Planificador de Obra</h1>
                </div>
                
                <!-- Filtros y Ordenamiento -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-filter"></i> Filtros y Ordenamiento</h5>
                    </div>
                    <div class="card-body">
                        <form id="filterForm" class="row g-3">
                            <div class="col-md-3">
                                <label for="status" class="form-label">Estado</label>
                                <select name="status" id="status" class="form-select">
                                    <option value="">Todos</option>
                                    <g:each in="${statuses}" var="status">
                                        <option value="${status}" ${currentStatus == status ? 'selected' : ''}>${status}</option>
                                    </g:each>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="priority" class="form-label">Prioridad</label>
                                <select name="priority" id="priority" class="form-select">
                                    <option value="">Todas</option>
                                    <g:each in="${priorities}" var="priority">
                                        <option value="${priority}" ${currentPriority == priority ? 'selected' : ''}>${priority}</option>
                                    </g:each>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="sort" class="form-label">Ordenar por</label>
                                <select name="sort" id="sort" class="form-select">
                                    <option value="dateCreated" ${currentSort == 'dateCreated' ? 'selected' : ''}>Fecha de creación</option>
                                    <option value="startDate" ${currentSort == 'startDate' ? 'selected' : ''}>Fecha de inicio</option>
                                    <option value="endDate" ${currentSort == 'endDate' ? 'selected' : ''}>Fecha de fin</option>
                                    <option value="priority" ${currentSort == 'priority' ? 'selected' : ''}>Prioridad</option>
                                    <option value="status" ${currentSort == 'status' ? 'selected' : ''}>Estado</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="order" class="form-label">Orden</label>
                                <select name="order" id="order" class="form-select">
                                    <option value="asc" ${currentOrder == 'asc' ? 'selected' : ''}>Ascendente</option>
                                    <option value="desc" ${currentOrder == 'desc' ? 'selected' : ''}>Descendente</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Filtrar
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                                    <i class="fas fa-undo"></i> Limpiar filtros
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Lista de tareas -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-tasks me-2"></i>Tareas
                            </h5>
                            <div class="d-flex align-items-center">
                                <button class="btn btn-danger me-2" id="deleteSelectedBtn" style="display: none;">
                                    <i class="fas fa-trash-alt me-1"></i>
                                    <span id="deleteSelectedText">Eliminar seleccionadas</span>
                                </button>
                                <button class="btn btn-primary" onclick="showCreateTaskModal()">
                                    <i class="fas fa-plus me-1"></i>Nueva Tarea
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 40px;">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="selectAll" name="selectAll">
                                            </div>
                                        </th>
                                        <th>Nombre</th>
                                        <th>Descripción</th>
                                        <th>Estado</th>
                                        <th>Prioridad</th>
                                        <th>Fecha Inicio</th>
                                        <th>Fecha Fin</th>
                                        <th style="width: 100px;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${tasks}" var="task">
                                        <tr class="task-row" data-task-id="${task.id}">
                                            <td>
                                                <div class="form-check">
                                                    <input class="form-check-input task-checkbox" type="checkbox" name="taskCheckbox" data-task-id="${task.id}">
                                                </div>
                                            </td>
                                            <td>${task.name}</td>
                                            <td>${task.description}</td>
                                            <td>
                                                <select class="form-select form-select-sm status-select" onchange="quickUpdate(${task.id}, 'status', this.value)">
                                                    <g:each in="${statuses}" var="status">
                                                        <option value="${status}" ${task.status == status ? 'selected' : ''}>${status}</option>
                                                    </g:each>
                                                </select>
                                            </td>
                                            <td>
                                                <select class="form-select form-select-sm priority-select" onchange="quickUpdate(${task.id}, 'priority', this.value)">
                                                    <g:each in="${priorities}" var="priority">
                                                        <option value="${priority}" ${task.priority == priority ? 'selected' : ''}>${priority}</option>
                                                    </g:each>
                                                </select>
                                            </td>
                                            <td>${task.startDate ? dateFormat.format(task.startDate) : '-'}</td>
                                            <td>${task.endDate ? dateFormat.format(task.endDate) : '-'}</td>
                                            <td>
                                                <button class="btn btn-sm btn-danger" onclick="confirmDelete(${task.id})" data-bs-toggle="tooltip" title="Eliminar">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para crear/editar tarea -->
    <div class="modal fade" id="taskModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Nueva Tarea</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="taskForm">
                        <input type="hidden" id="taskId">
                        <div class="mb-3">
                            <label for="taskName" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="taskName" required>
                        </div>
                        <div class="mb-3">
                            <label for="taskDescription" class="form-label">Descripción</label>
                            <textarea class="form-control" id="taskDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="taskStatus" class="form-label">Estado</label>
                            <select class="form-select" id="taskStatus">
                                <g:each in="${statuses}" var="status">
                                    <option value="${status}">${status}</option>
                                </g:each>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="taskPriority" class="form-label">Prioridad</label>
                            <select class="form-select" id="taskPriority">
                                <g:each in="${priorities}" var="priority">
                                    <option value="${priority}">${priority}</option>
                                </g:each>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="taskStartDate" class="form-label">Fecha de inicio</label>
                            <input type="date" class="form-control" id="taskStartDate">
                        </div>
                        <div class="mb-3">
                            <label for="taskEndDate" class="form-label">Fecha de fin</label>
                            <input type="date" class="form-control" id="taskEndDate">
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
</body>
</html> 