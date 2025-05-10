<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Calculadora de Materiales de Construcción</title>
    <asset:stylesheet src="calculator.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1 class="text-center my-4">Calculadora de Materiales de Construcción</h1>
                
                <g:if test="${flash.error}">
                    <div class="alert alert-danger">${flash.error}</div>
                </g:if>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Dimensiones del Proyecto</h3>
                    </div>
                    <div class="card-body">
                        <g:form action="index" method="POST">
                            <div class="form-group">
                                <label for="projectType">Tipo de Proyecto:</label>
                                <g:select name="projectType" 
                                    from="[wall: 'Pared', floor: 'Piso', ceiling: 'Techo', roof: 'Tejado']" 
                                    optionKey="key" 
                                    optionValue="value" 
                                    value="${projectType}" 
                                    class="form-control" 
                                    noSelection="['': 'Seleccione un tipo de proyecto']"
                                    onchange="showHideHeight()"/>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="length">Largo (metros):</label>
                                        <input type="number" name="length" id="length" value="${length}" 
                                            min="0.1" step="0.01" class="form-control" required />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="width">Ancho (metros):</label>
                                        <input type="number" name="width" id="width" value="${width}" 
                                            min="0.1" step="0.01" class="form-control" required />
                                    </div>
                                </div>
                                <div class="col-md-4" id="heightGroup" style="display: none;">
                                    <div class="form-group">
                                        <label for="height">Altura (metros):</label>
                                        <input type="number" name="height" id="height" value="${height}" 
                                            min="0.1" step="0.01" class="form-control" />
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-calculator"></i> Calcular Materiales
                                </button>
                            </div>
                        </g:form>
                    </div>
                </div>
                
                <g:if test="${result}">
                    <div class="card mt-4">
                        <div class="card-header bg-success text-white">
                            <h3 class="mb-0">Resultados del Cálculo</h3>
                        </div>
                        <div class="card-body">
                            <div class="summary-box mb-4">
                                <h4>Resumen del Proyecto</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Tipo de Proyecto:</strong> 
                                            <g:if test="${projectType == 'wall'}">Pared</g:if>
                                            <g:elseif test="${projectType == 'floor'}">Piso</g:elseif>
                                            <g:elseif test="${projectType == 'ceiling'}">Techo</g:elseif>
                                            <g:elseif test="${projectType == 'roof'}">Tejado</g:elseif>
                                        </p>
                                        <p><strong>Dimensiones:</strong> ${length} m × ${width} m<g:if test="${projectType == 'wall'}"> × ${height} m</g:if></p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Área:</strong> ${area} m²</p>
                                        <g:if test="${projectType == 'wall'}">
                                            <p><strong>Volumen:</strong> ${volume} m³</p>
                                        </g:if>
                                    </div>
                                </div>
                            </div>
                            
                            <h4>Materiales Necesarios</h4>
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered">
                                    <thead class="bg-primary text-white">
                                        <tr>
                                            <th>Material</th>
                                            <th>Cantidad Base</th>
                                            <th>Desperdicio</th>
                                            <th>Cantidad Total</th>
                                            <th>Unidad</th>
                                            <th>Precio Unitario</th>
                                            <th>Costo Total</th>
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
                                                <td>$${item.value.unitPrice}</td>
                                                <td class="cost">$${item.value.cost}</td>
                                            </tr>
                                        </g:each>
                                        <tr class="total-row">
                                            <td colspan="6" class="text-right"><strong>COSTO TOTAL:</strong></td>
                                            <td class="cost"><strong>$${totalCost}</strong></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="notes mt-3">
                                <h5>Notas importantes:</h5>
                                <ul>
                                    <li>Las cantidades base son las necesarias para el proyecto sin considerar desperdicios.</li>
                                    <li>El desperdicio se calcula según el tipo de material (5-10% adicional).</li>
                                    <li>La cantidad total incluye el desperdicio calculado.</li>
                                    <li>Los precios son estimados y pueden variar según la ubicación y el proveedor.</li>
                                    <li>Se recomienda consultar precios actualizados en tiendas locales.</li>
                                    <li>No se incluyen costos de mano de obra o herramientas.</li>
                                </ul>
                            </div>
                            
                            <div class="text-center mt-4">
                                <button onclick="window.print();" class="btn btn-success mr-2">
                                    <i class="fas fa-print"></i> Imprimir presupuesto
                                </button>
                                <g:link controller="calculator" action="simplePdf" target="_blank" class="btn btn-primary">
                                    <i class="fas fa-file-pdf"></i> Ver presupuesto para impresión
                                </g:link>
                            </div>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>
    </div>

    <script>
        // Función para mostrar/ocultar el campo de altura
        function showHideHeight() {
            var projectType = document.getElementById('projectType').value;
            var heightGroup = document.getElementById('heightGroup');
            
            if (projectType === 'wall') {
                heightGroup.style.display = 'block';
                document.getElementById('height').setAttribute('required', 'required');
            } else {
                heightGroup.style.display = 'none';
                document.getElementById('height').removeAttribute('required');
            }
        }
        
        // Ejecutar al cargar la página para establecer el estado inicial
        document.addEventListener('DOMContentLoaded', function() {
            showHideHeight();
        });
    </script>
</body>
</html>