<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
<!-- Font Awesome 5 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- O Font Awesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="container mt-4">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><g:link action="index">Mis Proyectos</g:link></li>
            <li class="breadcrumb-item active" aria-current="page">${project.name}</li>
        </ol>
    </nav>

<!-- Flash Message -->
    <g:if test="${flash.message}">
        <div class="alert alert-info">${flash.message}</div>
    </g:if>

    <div class="row">
        <!-- Column Left: Project Details -->
        <div class="col-md-8">
            <div class="card mb-4">
            <!-- Project Image -->
                <g:if test="${project.imageUrl}">
                    <img src="${project.imageUrl}" class="card-img-top" alt="${project.name}">
                </g:if>
                <div class="card-body">
                    <!-- Project Title and Actions -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h1 class="card-title h3">${project.name}</h1>
                        <div>
                            <g:link action="edit" id="${project.id}" class="btn btn-outline-primary">
                                <i class="fas fa-pencil-alt"></i> Editar
                            </g:link>
                            <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                <i class="far fa-trash-alt"></i> Eliminar
                            </button>
                        </div>
                    </div>

                    <!-- Project Description -->
                    <p class="card-text">${project.description}</p>

                    <!-- Project Info and Costs -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5>Información del Proyecto</h5>
                            <ul class="list-unstyled">
                                <li><strong>Estado:</strong>
                                    <span class="badge bg-${project.status == 'PLANIFICACION' ? 'info' : project.status == 'EN_PROGRESO' ? 'warning' : 'success'}">
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
                            <h5>Presupuesto y Costos</h5>
                            <ul class="list-unstyled">
                                <li><strong>Presupuesto:</strong> ${project.budget ?: 'No especificado'}€</li>
                                <li><strong>Costo actual:</strong> ${project.actualCost ?: 'No especificado'}€</li>
                                <li><strong>Progreso:</strong>
                                    <div class="progress">
                                        <div class="progress-bar bg-${project.actualCost > project.budget ? 'danger' : 'success'}"
                                             role="progressbar"
                                             style="width: ${((project.actualCost ?: 0) / (project.budget ?: 1)) * 100}%">
                                            ${((project.actualCost ?: 0) / (project.budget ?: 1)) * 100}%
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de Tareas del Proyecto -->
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>Tareas del Proyecto</h5>
                    <div>
                        <g:link controller="planner" action="index" params="[projectId: project.id]" class="btn btn-primary btn-sm me-2">
                            <i class="fas fa-chart-line"></i> Ver en Planner
                        </g:link>
                        <button type="button" class="btn btn-primary btn-sm" onclick="newTask()">
                            <i class="fas fa-plus"></i> Nueva Tarea
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <g:if test="${plannerTasks && !plannerTasks.isEmpty()}">
                        <div class="table-responsive">
                            <table class="table table-sm table-hover w-100">
                                <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Estado</th>
                                    <th>Prioridad</th>
                                    <th>Fechas</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:each var="task" in="${plannerTasks}">
                                    <tr>
                                        <td>
                                            <div>${task.name}</div>
                                            <g:if test="${task.description}">
                                                <small class="text-muted">${task.description}</small>
                                            </g:if>
                                        </td>
                                        <td>
                                            <span class="badge bg-${task.status == 'Completada' ? 'success' : 
                                                  task.status == 'En Progreso' ? 'primary' : 
                                                  task.status == 'Cancelada' ? 'danger' : 'warning'}">
                                                ${task.status}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-${task.priority == 'Alta' ? 'danger' : 
                                                  task.priority == 'Media' ? 'warning' : 
                                                  task.priority == 'Urgente' ? 'dark' : 'info'}">
                                                ${task.priority}
                                            </span>
                                        </td>
                                        <td>
                                            <small>
                                                <g:if test="${task.startDateFormatted}">
                                                    <div><i class="far fa-calendar-alt me-1"></i> ${task.startDateFormatted}</div>
                                                </g:if>
                                                <g:if test="${task.endDateFormatted}">
                                                    <div><i class="far fa-calendar-check me-1"></i> ${task.endDateFormatted}</div>
                                                </g:if>
                                                <g:if test="${!task.startDateFormatted && !task.endDateFormatted}">
                                                    <span class="text-muted">Sin fechas</span>
                                                </g:if>
                                            </small>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-sm btn-info" onclick="editTask('${task.id}')" title="Editar">
                                                    <i class="fas fa-pencil-alt"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete('${task.id}')" title="Eliminar">
                                                    <i class="far fa-trash-alt"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Modal de confirmación para eliminar tarea -->
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
                        
                        <!-- El resto del código permanece igual -->

                        <!-- Modal para crear/editar tareas -->
                        <div class="modal fade" id="taskModal" tabindex="-1" aria-labelledby="taskModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="taskModalLabel">Nueva Tarea</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- El contenido del formulario permanece igual -->
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
                                                    <option value="Pendiente">Pendiente</option>
                                                    <option value="En Progreso">En Progreso</option>
                                                    <option value="Completada">Completada</option>
                                                    <option value="Cancelada">Cancelada</option>
                                                </select>
                                            </div>
                                            
                                            <!-- Prioridad -->
                                            <div class="mb-3">
                                                <label for="taskPriority" class="form-label">Prioridad</label>
                                                <select class="form-select" id="taskPriority" name="priority">
                                                    <option value="Baja">Baja</option>
                                                    <option value="Media">Media</option>
                                                    <option value="Alta">Alta</option>
                                                    <option value="Urgente">Urgente</option>
                                                </select>
                                            </div>
                                            
                                            <!-- Proyecto (oculto, ya que estamos en vista de proyecto) -->
                                            <input type="hidden" id="taskProject" name="projectId" value="${project.id}">
                                            
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
                        
                        <script>
                            // El código JavaScript permanece igual que en mi respuesta anterior
                            let taskIdToDelete;
                            
                            function editTask(taskId) {
                                document.getElementById('taskId').value = taskId;
                                
                                fetch('${createLink(controller: "planner", action: "getTask")}?id=' + taskId)
                                    .then(response => response.json())
                                    .then(data => {
                                        document.getElementById('taskName').value = data.name;
                                        document.getElementById('taskDescription').value = data.description || '';
                                        document.getElementById('taskStatus').value = data.status;
                                        document.getElementById('taskPriority').value = data.priority;
                                        
                                        if (data.startDate) {
                                            document.getElementById('taskStartDate').value = data.startDate;
                                        } else {
                                            document.getElementById('taskStartDate').value = '';
                                        }
                                        if (data.endDate) {
                                            document.getElementById('taskEndDate').value = data.endDate;
                                        } else {
                                            document.getElementById('taskEndDate').value = '';
                                        }
                                        
                                        document.getElementById('taskModalLabel').textContent = 'Editar Tarea';
                                        
                                        const taskModal = new bootstrap.Modal(document.getElementById('taskModal'));
                                        taskModal.show();
                                    })
                                    .catch(error => {
                                        console.error('Error al obtener los datos de la tarea:', error);
                                        alert('Error al cargar los datos de la tarea.');
                                    });
                            }
                            
                            function confirmDelete(taskId) {
                                taskIdToDelete = taskId;
                                
                                const confirmModal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
                                confirmModal.show();
                            }
                            
                            function deleteTask() {
                                if (taskIdToDelete) {
                                    fetch('${createLink(controller: "planner", action: "delete")}', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                            'X-Requested-With': 'XMLHttpRequest'
                                        },
                                        body: 'id=' + taskIdToDelete
                                    })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            const confirmModal = bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal'));
                                            confirmModal.hide();
                                            
                                            window.location.reload();
                                        } else {
                                            console.error('Error al eliminar la tarea:', data.error);
                                            alert('Error al eliminar la tarea: ' + (data.error || 'Error desconocido'));
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error al eliminar la tarea:', error);
                                        alert('Error al eliminar la tarea.');
                                    });
                                }
                            }
                            
                            function saveTask() {
                                const form = document.getElementById('taskForm');
                                
                                if (form.checkValidity()) {
                                    const formData = new FormData(form);
                                    
                                    const params = new URLSearchParams();
                                    for (const pair of formData.entries()) {
                                        params.append(pair[0], pair[1]);
                                    }
                                    
                                    fetch('${createLink(controller: "planner", action: "save")}', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                            'X-Requested-With': 'XMLHttpRequest'
                                        },
                                        body: params
                                    })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            const taskModal = bootstrap.Modal.getInstance(document.getElementById('taskModal'));
                                            taskModal.hide();
                                            
                                            window.location.reload();
                                        } else {
                                            console.error('Error al guardar la tarea:', data.error);
                                            alert('Error al guardar la tarea: ' + (data.error || 'Error desconocido'));
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error al guardar la tarea:', error);
                                        alert('Error al guardar la tarea.');
                                    });
                                } else {
                                    form.reportValidity();
                                }
                            }
                            
                            function newTask() {
                                document.getElementById('taskForm').reset();
                                document.getElementById('taskId').value = '';
                                
                                document.getElementById('taskProject').value = '${project.id}';
                                
                                document.getElementById('taskModalLabel').textContent = 'Nueva Tarea';
                                
                                const taskModal = new bootstrap.Modal(document.getElementById('taskModal'));
                                taskModal.show();
                            }
                        </script>
                    </g:if>
                    <g:else>
                        <div class="alert alert-info">
                            No hay tareas asociadas a este proyecto.
                            <button type="button" class="alert-link" onclick="newTask()" style="border:none;background:none;padding:0">
                                Crear una tarea
                            </button>
                        </div>
                        
                        <!-- La parte restante del código para cuando no hay tareas permanece igual -->
                    </g:else>
                </div>
            </div>

            <!-- Resto del contenido de la vista del proyecto -->
        </div>

        <!-- Column Right: Statistics -->
        <div class="col-md-4">
            <h5>Estadísticas</h5>
            <div class="progress">
                <div class="progress-bar" style="width: 70%;">70%</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>