<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Agregar Nota - ${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><g:link action="index">Mis Proyectos</g:link></li>
                <li class="breadcrumb-item"><g:link action="show" id="${project.id}">${project.name}</g:link></li>
                <li class="breadcrumb-item active" aria-current="page">Agregar Nota</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Agregar Nota a ${project.name}</h4>
                    </div>
                    <div class="card-body">
                        <g:form action="saveNote" method="POST" class="needs-validation" novalidate="novalidate">
                            <g:hiddenField name="projectId" value="${project.id}"/>

                            <div class="mb-3">
                                <label for="title" class="form-label">Título</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                                <div class="invalid-feedback">
                                    Por favor ingresa un título para la nota.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="content" class="form-label">Contenido</label>
                                <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
                                <div class="invalid-feedback">
                                    Por favor ingresa el contenido de la nota.
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="category" class="form-label">Categoría</label>
                                    <select class="form-select" id="category" name="category" required>
                                        <option value="GENERAL">General</option>
                                        <option value="PROBLEMA">Problema</option>
                                        <option value="SOLUCION">Solución</option>
                                        <option value="IDEA">Idea</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="priority" class="form-label">Prioridad</label>
                                    <select class="form-select" id="priority" name="priority">
                                        <option value="">Sin prioridad</option>
                                        <option value="BAJA">Baja</option>
                                        <option value="MEDIA">Media</option>
                                        <option value="ALTA">Alta</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isImportant" name="isImportant">
                                    <label class="form-check-label" for="isImportant">
                                        Marcar como importante
                                    </label>
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <g:link action="show" id="${project.id}" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times"></i> Cancelar
                                </g:link>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Agregar Nota
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