<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Herramientas - ConstruyeSmart</title>
    <asset:stylesheet src="tool.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Herramientas</h1>
            <g:link action="create" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nueva Herramienta
            </g:link>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-info">${flash.message}</div>
        </g:if>

        <div class="card mb-4">
            <div class="card-body">
                <g:form action="search" method="GET" class="row g-3">
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" name="query" class="form-control" placeholder="Buscar herramientas..." value="${query}">
                            <button type="submit" class="btn btn-outline-secondary">
                                <i class="fas fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" id="categoryFilter">
                            <option value="">Todas las categorías</option>
                            <option value="Electricidad">Electricidad</option>
                            <option value="Fontanería">Fontanería</option>
                            <option value="Carpintería">Carpintería</option>
                            <option value="Albañilería">Albañilería</option>
                            <option value="Pintura">Pintura</option>
                            <option value="Jardinería">Jardinería</option>
                        </select>
                    </div>
                </g:form>
            </div>
        </div>

        <div class="row">
            <g:each in="${tools}" var="tool">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <g:if test="${tool.imageUrl}">
                            <img src="${tool.imageUrl}" class="card-img-top" alt="${tool.name}">
                        </g:if>
                        <div class="card-body">
                            <h5 class="card-title">${tool.name}</h5>
                            <p class="card-text">${tool.description}</p>
                            <div class="mb-2">
                                <span class="badge bg-info">${tool.category}</span>
                                <g:if test="${tool.availableForRent}">
                                    <span class="badge bg-success">Disponible para alquiler</span>
                                </g:if>
                            </div>
                            <g:if test="${tool.rentalPricePerDay}">
                                <p class="card-text">
                                    <small class="text-muted">
                                        <i class="fas fa-euro-sign"></i> ${tool.rentalPricePerDay} / día
                                    </small>
                                </p>
                            </g:if>
                        </div>
                        <div class="card-footer">
                            <g:link action="show" id="${tool.id}" class="btn btn-sm btn-outline-primary">
                                Ver Detalles
                            </g:link>
                            <g:link action="edit" id="${tool.id}" class="btn btn-sm btn-outline-secondary">
                                Editar
                            </g:link>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <asset:javascript src="tool.js"/>
</body>
</html> 