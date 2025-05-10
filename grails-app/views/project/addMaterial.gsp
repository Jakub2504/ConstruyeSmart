<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Agregar Material - ${project.name} - ConstruyeSmart</title>
    <asset:stylesheet src="project.css"/>
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><g:link action="index">Mis Proyectos</g:link></li>
                <li class="breadcrumb-item"><g:link action="show" id="${project.id}">${project.name}</g:link></li>
                <li class="breadcrumb-item active" aria-current="page">Agregar Material</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Agregar Material a ${project.name}</h4>
                    </div>
                    <div class="card-body">
                        <g:form action="saveMaterial" method="POST" class="needs-validation" novalidate="novalidate">
                            <g:hiddenField name="projectId" value="${project.id}"/>

                            <div class="mb-3">
                                <label for="name" class="form-label">Nombre del Material</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                                <div class="invalid-feedback">
                                    Por favor ingresa un nombre para el material.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Descripción</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="unit" class="form-label">Unidad de Medida</label>
                                    <input type="text" class="form-control" id="unit" name="unit" required>
                                    <div class="invalid-feedback">
                                        Por favor ingresa la unidad de medida.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="quantity" class="form-label">Cantidad</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" min="0" step="0.01" required>
                                    <div class="invalid-feedback">
                                        Por favor ingresa una cantidad válida.
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="unitPrice" class="form-label">Precio Unitario (€)</label>
                                    <input type="number" class="form-control" id="unitPrice" name="unitPrice" min="0" step="0.01" required>
                                    <div class="invalid-feedback">
                                        Por favor ingresa un precio unitario válido.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="status" class="form-label">Estado</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="PENDIENTE">Pendiente</option>
                                        <option value="COMPRADO">Comprado</option>
                                        <option value="ENTREGADO">Entregado</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="supplier" class="form-label">Proveedor</label>
                                    <input type="text" class="form-control" id="supplier" name="supplier">
                                </div>
                                <div class="col-md-6">
                                    <label for="supplierUrl" class="form-label">URL del Proveedor</label>
                                    <input type="url" class="form-control" id="supplierUrl" name="supplierUrl">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="purchaseDate" class="form-label">Fecha de Compra</label>
                                    <input type="date" class="form-control" id="purchaseDate" name="purchaseDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="deliveryDate" class="form-label">Fecha de Entrega</label>
                                    <input type="date" class="form-control" id="deliveryDate" name="deliveryDate">
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <g:link action="show" id="${project.id}" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times"></i> Cancelar
                                </g:link>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Agregar Material
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