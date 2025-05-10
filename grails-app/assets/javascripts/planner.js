// Variables globales
let taskIdToDelete = null;

// Función para mostrar el modal de nueva tarea
function newTask() {
    document.getElementById('taskForm').reset();
    document.getElementById('taskId').value = '';
    document.getElementById('taskModalLabel').textContent = 'Nueva Tarea';
    
    // Mostrar el modal
    const modal = new bootstrap.Modal(document.getElementById('taskModal'));
    modal.show();
}

// Función para editar una tarea existente
function editTask(taskId) {
    // Realiza una petición AJAX para obtener los datos de la tarea
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/planner/getTask?id=' + taskId, true);
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                const task = JSON.parse(xhr.responseText);
                
                // Llenar el formulario con los datos de la tarea
                document.getElementById('taskId').value = task.id;
                document.getElementById('taskName').value = task.name || '';
                document.getElementById('taskDescription').value = task.description || '';
                
                // Establecer estado
                const statusSelect = document.getElementById('taskStatus');
                for (let i = 0; i < statusSelect.options.length; i++) {
                    if (statusSelect.options[i].value === task.status) {
                        statusSelect.selectedIndex = i;
                        break;
                    }
                }
                
                // Establecer prioridad
                const prioritySelect = document.getElementById('taskPriority');
                for (let i = 0; i < prioritySelect.options.length; i++) {
                    if (prioritySelect.options[i].value === task.priority) {
                        prioritySelect.selectedIndex = i;
                        break;
                    }
                }
                
                // Establecer proyecto
                if (task.projectId) {
                    const projectSelect = document.getElementById('projectId');
                    for (let i = 0; i < projectSelect.options.length; i++) {
                        if (projectSelect.options[i].value === task.projectId.toString()) {
                            projectSelect.selectedIndex = i;
                            break;
                        }
                    }
                }
                
                // Establecer fechas
                if (task.startDate) {
                    document.getElementById('taskStartDate').value = task.startDate;
                }
                
                if (task.endDate) {
                    document.getElementById('taskEndDate').value = task.endDate;
                }
                
                // Mostrar el modal
                const modal = new bootstrap.Modal(document.getElementById('taskModal'));
                modal.show();
                
            } catch (e) {
                console.error("Error al procesar datos:", e);
                showToast('Error', 'Error al procesar los datos de la tarea', 'error');
            }
        } else {
            showToast('Error', 'No se pudo obtener la información de la tarea', 'error');
        }
    };
    
    xhr.onerror = function() {
        showToast('Error', 'Error de comunicación con el servidor', 'error');
    };
    
    xhr.send();
}

// Función para guardar una tarea (crear o actualizar)
function saveTask() {
    // Obtener el formulario
    const form = document.getElementById('taskForm');
    const formData = new FormData(form);
    
    // Validación básica
    if (!formData.get('name')?.trim()) {
        showToast('Error', 'El nombre de la tarea es obligatorio', 'error');
        return;
    }
    
    // Determinar si es actualización o creación
    const taskId = formData.get('id');
    
    // Enviar petición AJAX - siempre al mismo endpoint
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/planner/save');
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                const response = JSON.parse(xhr.responseText);
                if (response.success) {
                    // Cerrar modal
                    bootstrap.Modal.getInstance(document.getElementById('taskModal')).hide();
                    
                    // Mostrar mensaje de éxito
                    showToast('Éxito', response.message || 'Tarea guardada correctamente', 'success');
                    
                    // Recargar la página después de un breve retraso
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showToast('Error', response.message || 'Hubo un problema al guardar la tarea', 'error');
                }
            } catch (e) {
                console.error("Error en respuesta:", e, xhr.responseText);
                showToast('Error', 'Error en la respuesta del servidor', 'error');
            }
        } else {
            console.error("Error HTTP:", xhr.status, xhr.statusText);
            showToast('Error', 'Error de comunicación con el servidor', 'error');
        }
    };
    
    xhr.onerror = function() {
        console.error("Error de conexión");
        showToast('Error', 'No se pudo conectar con el servidor', 'error');
    };
    
    xhr.send(formData);
}

// Función para confirmar eliminación
function confirmDelete(taskId) {
    taskIdToDelete = taskId;
    const modal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
    modal.show();
}

// Función para eliminar tarea
function deleteTask() {
    if (!taskIdToDelete) return;
    
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/planner/delete');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onload = function() {
        // Cerrar modal de confirmación
        bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal')).hide();
        
        if (xhr.status === 200) {
            try {
                const response = JSON.parse(xhr.responseText);
                
                if (response.success) {
                    // Mostrar mensaje de éxito
                    showToast('Éxito', response.message || 'Tarea eliminada correctamente', 'success');
                    
                    // Recargar la página después de un breve retraso
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showToast('Error', response.message || 'Hubo un problema al eliminar la tarea', 'error');
                }
            } catch (e) {
                console.error("Error en respuesta:", e, xhr.responseText);
                showToast('Error', 'Error en la respuesta del servidor', 'error');
            }
        } else {
            console.error("Error HTTP:", xhr.status, xhr.statusText);
            showToast('Error', 'Error de comunicación con el servidor', 'error');
        }
        
        // Limpiar referencia
        taskIdToDelete = null;
    };
    
    xhr.onerror = function() {
        bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal')).hide();
        console.error("Error de conexión");
        showToast('Error', 'No se pudo conectar con el servidor', 'error');
        taskIdToDelete = null;
    };
    
    xhr.send(`id=${taskIdToDelete}`);
}

// Función para mostrar notificaciones toast
function showToast(title, message, type) {
    const toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) return;
    
    const toastId = 'toast-' + Date.now();
    const toastHTML = `
        <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header ${type === 'error' ? 'bg-danger text-white' : type === 'success' ? 'bg-success text-white' : ''}">
                <strong class="me-auto">${title}</strong>
                <button type="button" class="btn-close ${type === 'error' || type === 'success' ? 'btn-close-white' : ''}" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHTML);
    
    const toastElement = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastElement, { delay: 5000 });
    toast.show();
    
    // Auto-eliminar después de ocultarse
    toastElement.addEventListener('hidden.bs.toast', () => {
        toastElement.remove();
    });
}