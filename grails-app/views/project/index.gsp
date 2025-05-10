<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Mis Proyectos - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
    <div class="project-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-project-diagram"></i> Mis Proyectos</h1>
            <g:link action="create" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nuevo Proyecto
            </g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-info alert-dismissible fade show">
                <i class="fas fa-info-circle"></i> ${flash.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </g:if>

        <div class="card mb-4">
            <div class="card-body">
                <g:form action="search" method="GET" class="search-form">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" name="name" class="form-control" placeholder="Buscar proyectos..." value="${params.name}">
                                <button type="submit" class="btn btn-outline-secondary">
                                    <i class="fas fa-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <select name="status" class="form-select">
                                <option value="">Todos los estados</option>
                                <option value="PLANIFICACION" ${params.status == 'PLANIFICACION' ? 'selected' : ''}>Planificación</option>
                                <option value="EN_PROGRESO" ${params.status == 'EN_PROGRESO' ? 'selected' : ''}>En Progreso</option>
                                <option value="COMPLETADO" ${params.status == 'COMPLETADO' ? 'selected' : ''}>Completado</option>
                                <option value="CANCELADO" ${params.status == 'CANCELADO' ? 'selected' : ''}>Cancelado</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mt-3">
                        <div class="col-md-3">
                            <input type="date" name="startDate" class="form-control" value="${params.startDate}" placeholder="Fecha de inicio">
                        </div>
                        <div class="col-md-3">
                            <input type="date" name="endDate" class="form-control" value="${params.endDate}" placeholder="Fecha de fin">
                        </div>
                        <div class="col-md-3">
                            <input type="number" name="minBudget" class="form-control" value="${params.minBudget}" placeholder="Presupuesto mínimo">
                        </div>
                        <div class="col-md-3">
                            <input type="number" name="maxBudget" class="form-control" value="${params.maxBudget}" placeholder="Presupuesto máximo">
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Aplicar Filtros
                            </button>
                            <g:link action="index" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Limpiar Filtros
                            </g:link>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>

        <div class="row">
            <g:each in="${projects}" var="project">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 project-card">
                        <g:if test="${project.imageUrl}">
                            <img src="${project.imageUrl}" class="card-img-top" alt="${project.name}">
                        </g:if>
                        <div class="card-body">
                            <h5 class="card-title">${project.name}</h5>
                            <p class="card-text">${project.description}</p>
                            <div class="mb-2">
                                <span class="badge bg-${project.status == 'PLANIFICACION' ? 'info' : project.status == 'EN_PROGRESO' ? 'warning' : project.status == 'COMPLETADO' ? 'success' : 'danger'}">
                                    ${project.status}
                                </span>
                                <g:if test="${project.budget}">
                                    <span class="badge bg-secondary">${project.budget}€</span>
                                </g:if>
                            </div>
                            <div class="progress mb-2">
                                <div class="progress-bar" role="progressbar" 
                                     style="width: ${projectService?.calculateProjectProgress(project) ?: 0}%" 
                                     aria-valuenow="${projectService?.calculateProjectProgress(project) ?: 0}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                    ${Math.round(projectService?.calculateProjectProgress(project) ?: 0)}%
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">
                                    <i class="fas fa-tasks"></i> ${project.tasks?.size() ?: 0} tareas
                                </small>
                                <small class="text-muted">
                                    <i class="fas fa-box"></i> ${project.materials?.size() ?: 0} materiales
                                </small>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="btn-group w-100">
                                <g:link action="show" id="${project.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye"></i> Ver
                                </g:link>
                                <g:link action="edit" id="${project.id}" class="btn btn-sm btn-outline-secondary">
                                    <i class="fas fa-edit"></i> Editar
                                </g:link>
                                <g:link action="delete" id="${project.id}" class="btn btn-sm btn-outline-danger" 
                                        onclick="return confirm('¿Estás seguro de que deseas eliminar este proyecto?');">
                                    <i class="fas fa-trash"></i> Eliminar
                                </g:link>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <asset:javascript src="project.js"/>
</body>
</html> 