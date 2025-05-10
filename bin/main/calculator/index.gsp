<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Calculadora de Materiales</title>
    <asset:stylesheet src="calculator.css"/>
</head>
<body>
    <div class="calculator-section">
        <div class="container">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="text-center mb-0">Calculadora de Materiales</h3>
                        </div>
                        <div class="card-body">
                            <g:if test="${flash.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${flash.error}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </g:if>

                            <g:form controller="calculator" action="index" method="POST">
                                <div class="form-group">
                                    <label for="projectType">Tipo de Proyecto:</label>
                                    <select class="form-control" id="projectType" name="projectType" required>
                                        <option value="">Seleccione un tipo de proyecto</option>
                                        <option value="wall" ${projectType == 'wall' ? 'selected' : ''}>Pared</option>
                                        <option value="floor" ${projectType == 'floor' ? 'selected' : ''}>Piso</option>
                                        <option value="ceiling" ${projectType == 'ceiling' ? 'selected' : ''}>Techo</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="dimensions">Dimensiones (metros):</label>
                                    <div class="row" id="dimensionsContainer">
                                        <div class="col">
                                            <input type="number" class="form-control" id="length" name="length" 
                                                   placeholder="Largo" step="0.01" min="0.01" required value="${length}"
                                                   data-toggle="tooltip" title="Ingrese el largo en metros">
                                        </div>
                                        <div class="col">
                                            <input type="number" class="form-control" id="width" name="width" 
                                                   placeholder="Ancho" step="0.01" min="0.01" required value="${width}"
                                                   data-toggle="tooltip" title="Ingrese el ancho en metros">
                                        </div>
                                        <div class="col" id="heightColumn">
                                            <input type="number" class="form-control" id="height" name="height" 
                                                   placeholder="Alto" step="0.01" min="0.01" value="${height}"
                                                   data-toggle="tooltip" title="Ingrese la altura en metros">
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group text-center mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-calculator"></i> Calcular
                                    </button>
                                </div>
                            </g:form>

                            <g:if test="${result}">
                                <div class="mt-5">
                                    <div class="card mb-4">
                                        <div class="card-header bg-info text-white">
                                            <h4 class="mb-0">Resumen del Proyecto</h4>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong>Área:</strong> ${area} m²</p>
                                                    <g:if test="${projectType == 'wall'}">
                                                        <p><strong>Volumen:</strong> ${volume} m³</p>
                                                    </g:if>
                                                </div>
                                                <div class="col-md-6">
                                                    <p><strong>Tipo de Proyecto:</strong> 
                                                        <g:if test="${projectType == 'wall'}">Pared</g:if>
                                                        <g:elseif test="${projectType == 'floor'}">Piso</g:elseif>
                                                        <g:elseif test="${projectType == 'ceiling'}">Techo</g:elseif>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <h4 class="text-center mb-4">Materiales Necesarios</h4>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>Material</th>
                                                    <th>Cantidad Base</th>
                                                    <th>Desperdicio</th>
                                                    <th>Cantidad Total</th>
                                                    <th>Unidad</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <g:each in="${result}" var="item">
                                                    <tr>
                                                        <td>${item.key}</td>
                                                        <td>${item.value.baseQuantity}</td>
                                                        <td>${item.value.wasteQuantity}</td>
                                                        <td><strong>${item.value.quantity}</strong></td>
                                                        <td>${item.value.unit}</td>
                                                    </tr>
                                                </g:each>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="alert alert-info mt-4">
                                        <h5><i class="fas fa-info-circle"></i> Notas importantes:</h5>
                                        <ul class="mb-0">
                                            <li>Las cantidades base son las necesarias para el proyecto sin considerar desperdicios.</li>
                                            <li>El desperdicio se calcula según el tipo de material (5-10% adicional).</li>
                                            <li>La cantidad total incluye el desperdicio calculado.</li>
                                            <li>Se recomienda comprar un poco más de material para imprevistos.</li>
                                            <li>Consulte con un profesional para proyectos de gran envergadura.</li>
                                        </ul>
                                    </div>
                                </div>
                            </g:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asset:javascript src="calculator.js"/>
</body>
</html> 