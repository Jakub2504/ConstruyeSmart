<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${tool.name} - ConstruyeSmart</title>
    <asset:javascript src="https://maps.googleapis.com/maps/api/js?key=${grailsApplication.config.api.google.maps.key}"/>
    <asset:stylesheet src="tool.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>${tool.name}</h1>
            <div>
                <g:link action="edit" id="${tool.id}" class="btn btn-primary">Editar</g:link>
                <g:link action="index" class="btn btn-secondary">Volver</g:link>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <g:if test="${tool.imageUrl}">
                            <img src="${tool.imageUrl}" class="img-fluid rounded mb-3" alt="${tool.name}">
                        </g:if>
                        <h5 class="card-title">Descripción</h5>
                        <p class="card-text">${tool.description}</p>
                        <div class="mb-3">
                            <span class="badge bg-info">${tool.category}</span>
                            <g:if test="${tool.availableForRent}">
                                <span class="badge bg-success">Disponible para alquiler</span>
                            </g:if>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Instrucciones de Uso</h5>
                        <p class="card-text">${tool.usageInstructions}</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Instrucciones de Seguridad</h5>
                        <p class="card-text">${tool.safetyInstructions}</p>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Información de Alquiler</h5>
                        <g:if test="${tool.availableForRent}">
                            <div class="mb-3">
                                <p class="mb-1"><strong>Precio por día:</strong></p>
                                <p class="h4 text-primary">${tool.rentalPricePerDay} €</p>
                            </div>
                            <div class="mb-3">
                                <p class="mb-1"><strong>Tienda:</strong></p>
                                <p>${tool.rentalStore}</p>
                            </div>
                            <div class="mb-3">
                                <p class="mb-1"><strong>Ubicación:</strong></p>
                                <p>${tool.rentalLocation}</p>
                            </div>
                            <g:link action="toggleRentalStatus" id="${tool.id}" class="btn btn-warning">
                                <i class="fas fa-exchange-alt"></i> Cambiar Estado de Alquiler
                            </g:link>
                        </g:if>
                        <g:else>
                            <div class="alert alert-info">
                                Esta herramienta no está disponible para alquiler.
                            </div>
                            <g:link action="toggleRentalStatus" id="${tool.id}" class="btn btn-success">
                                <i class="fas fa-check"></i> Activar Alquiler
                            </g:link>
                        </g:else>
                    </div>
                </div>

                <g:if test="${tool.availableForRent}">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Ubicaciones de Alquiler Cercanas</h5>
                            <div id="rental-locations-map" style="height: 300px;"></div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Otras Opciones de Alquiler</h5>
                            <div id="rental-locations">
                                <g:each in="${rentalLocations}" var="location">
                                    <div class="rental-location mb-3">
                                        <h6>${location.name}</h6>
                                        <p class="mb-1">${location.address}</p>
                                        <div class="rating">${location.rating} ⭐</div>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>
    </div>

    <asset:javascript src="tool.js"/>
</body>
</html> 