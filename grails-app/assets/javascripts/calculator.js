$(document).ready(function() {
    // Variables globales para manejar los precios
    var materialPrices = {};
    var selectedPrices = {};
    var currentMaterial = '';

    // Función para actualizar los campos según el tipo de proyecto
    function updateFields() {
        var projectType = $('#projectType').val();
        var heightColumn = $('#heightColumn');
        var heightInput = $('#height');
        
        // Limpiar mensajes de error
        $('.alert-danger').remove();
        
        // Actualizar campos según el tipo de proyecto
        if (projectType === 'floor' || projectType === 'ceiling' || projectType === 'roof') {
            heightColumn.hide();
            heightInput.prop('required', false);
            heightInput.val('');
        } else {
            heightColumn.show();
            heightInput.prop('required', true);
        }
    }

    // Manejar cambios en el tipo de proyecto
    $('#projectType').on('change', function() {
        updateFields();
    });

    // Validación de campos numéricos
    $('input[type="number"]').on('input', function() {
        var value = $(this).val();
        if (value < 0) {
            $(this).val(0);
        }
    });

    // Validación del formulario
    $('form').on('submit', function(e) {
        var projectType = $('#projectType').val();
        var length = parseFloat($('#length').val());
        var width = parseFloat($('#width').val());
        var height = parseFloat($('#height').val() || 0);
        var isValid = true;
        var errorMessage = '';

        // Validar tipo de proyecto
        if (!projectType) {
            errorMessage = 'Por favor seleccione un tipo de proyecto';
            isValid = false;
        }
        // Validar dimensiones
        else if (length <= 0 || width <= 0) {
            errorMessage = 'Las dimensiones deben ser mayores que 0';
            isValid = false;
        }
        // Validar altura para paredes
        else if (projectType === 'wall' && height <= 0) {
            errorMessage = 'La altura debe ser mayor que 0 para paredes';
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            // Mostrar mensaje de error
            $('<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
                errorMessage +
                '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>').insertAfter('.card-header');
            return false;
        }

        // Mostrar indicador de carga
        $('<div class="text-center mt-3">' +
            '<div class="spinner-border text-primary" role="status">' +
            '<span class="sr-only">Calculando...</span>' +
            '</div>' +
            '</div>').insertAfter('form');
    });
    
    // Función para cargar precios de materiales
    $('.load-prices').on('click', function() {
        var $container = $(this).closest('.price-container');
        var material = $container.data('material');
        var $resultsContainer = $container.find('.price-results');
        
        // Mostrar spinner de carga
        $container.find('button').hide();
        $resultsContainer.show();
        
        // Verificar si ya tenemos los precios en caché
        if (materialPrices[material] && materialPrices[material].length > 0) {
            displayPriceResults($container, material, materialPrices[material]);
            return;
        }
        
        // Cargar precios desde el servidor
        $.ajax({
            url: contextPath + '/calculator/getPrices',
            method: 'GET',
            data: { materialName: material },
            dataType: 'json',
            success: function(response) {
                if (response.success && response.data && response.data.length > 0) {
                    // Guardar en caché
                    materialPrices[material] = response.data;
                    
                    // Mostrar resultados
                    displayPriceResults($container, material, response.data);
                } else {
                    $resultsContainer.html(
                        '<div class="alert alert-warning">' +
                        '<i class="fas fa-exclamation-triangle"></i> ' +
                        'No se encontraron precios para este material.' +
                        '</div>'
                    );
                }
            },
            error: function(xhr, status, error) {
                $resultsContainer.html(
                    '<div class="alert alert-danger">' +
                    '<i class="fas fa-exclamation-circle"></i> ' +
                    'Error al cargar precios: ' + error +
                    '</div>'
                );
            }
        });
    });
    
    // Función para mostrar los resultados de precios
    function displayPriceResults($container, material, prices) {
        var $resultsContainer = $container.find('.price-results');
        
        // Si solo hay un precio, mostrarlo directamente
        if (prices.length === 1) {
            var price = prices[0];
            $resultsContainer.html(
                '<div class="price-card">' +
                '<div class="price-value">' + formatCurrency(price.price) + '</div>' +
                '<div class="price-store">' + (price.store || 'Tienda no especificada') + '</div>' +
                '</div>'
            );
            
            // Almacenar el precio seleccionado
            selectedPrices[material] = price;
            updateTotalCost();
            
            return;
        }
        
        // Si hay múltiples precios, mostrar resumen y botón para ver más
        var minPrice = prices.reduce(function(min, p) {
            return (p.price < min.price) ? p : min;
        }, prices[0]);
        
        var maxPrice = prices.reduce(function(max, p) {
            return (p.price > max.price) ? p : max;
        }, prices[0]);
        
        $resultsContainer.html(
            '<div class="price-summary">' +
            '<div><strong>Rango:</strong> ' + formatCurrency(minPrice.price) + ' - ' + formatCurrency(maxPrice.price) + '</div>' +
            '<button class="btn btn-sm btn-info mt-2 view-price-details" data-material="' + material + '">' +
            '<i class="fas fa-search-dollar"></i> Ver detalles' +
            '</button>' +
            '</div>'
        );
        
        // Seleccionar el precio más económico por defecto
        selectedPrices[material] = minPrice;
        updateTotalCost();
    }
    
    // Ver detalles de precios
    $(document).on('click', '.view-price-details', function() {
        var material = $(this).data('material');
        var prices = materialPrices[material] || [];
        
        currentMaterial = material;
        
        // Construir contenido del modal
        var content = '<h5>' + material + '</h5>';
        content += '<div class="table-responsive"><table class="table table-bordered table-hover">';
        content += '<thead><tr><th>Producto</th><th>Precio</th><th>Tienda</th><th>Disponibilidad</th><th>Seleccionar</th></tr></thead>';
        content += '<tbody>';
        
        prices.forEach(function(price, index) {
            var isSelected = selectedPrices[material] && selectedPrices[material].name === price.name;
            content += '<tr' + (isSelected ? ' class="table-primary"' : '') + '>';
            content += '<td>' + (price.name || 'Producto sin nombre') + '</td>';
            content += '<td>' + formatCurrency(price.price) + '</td>';
            content += '<td>' + (price.store || 'No especificada') + '</td>';
            content += '<td>' + (price.availability || 'No especificada') + '</td>';
            content += '<td><input type="radio" name="priceOption" value="' + index + '"' + (isSelected ? ' checked' : '') + '></td>';
            content += '</tr>';
        });
        
        content += '</tbody></table></div>';
        
        $('#priceDetailContent').html(content);
        $('#priceDetailModalLabel').text('Precios para ' + material);
        $('#priceDetailModal').modal('show');
    });
    
    // Seleccionar precio para el cálculo
    $('#btnUsePriceForCalculation').on('click', function() {
        var selectedIndex = $('input[name="priceOption"]:checked').val();
        if (selectedIndex !== undefined && currentMaterial) {
            selectedPrices[currentMaterial] = materialPrices[currentMaterial][selectedIndex];
            updateTotalCost();
            $('#priceDetailModal').modal('hide');
            
            // Actualizar el resumen visible
            var $container = $('[data-material="' + currentMaterial + '"]');
            var $resultsContainer = $container.find('.price-results');
            
            $resultsContainer.html(
                '<div class="price-card selected">' +
                '<div class="price-value">' + formatCurrency(selectedPrices[currentMaterial].price) + '</div>' +
                '<div class="price-store">' + (selectedPrices[currentMaterial].store || 'Tienda no especificada') + '</div>' +
                '<div class="badge badge-success">Seleccionado</div>' +
                '</div>'
            );
        }
    });
    
    // Actualizar el costo total
    function updateTotalCost() {
        var totalCost = 0;
        var allMaterialsHavePrices = true;
        
        // Recorrer los materiales que tienen resultados
        $('.price-container').each(function() {
            var material = $(this).data('material');
            var quantity = parseFloat($('[data-material="' + material + '"]').closest('tr').find('td:nth-child(4)').text().trim());
            
            if (selectedPrices[material]) {
                totalCost += quantity * selectedPrices[material].price;
            } else {
                allMaterialsHavePrices = false;
            }
        });
        
        // Mostrar el costo total si todos los materiales tienen precios
        if (allMaterialsHavePrices) {
            $('#totalCost').text(formatCurrency(totalCost));
            $('#totalCostContainer').slideDown();
        }
    }
    
    // Función para formatear moneda
    function formatCurrency(amount) {
        return '$' + parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    }

    // Inicializar tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // Manejar cierre de alertas
    $(document).on('click', '.alert .close', function() {
        $(this).closest('.alert').remove();
    });

    // Inicializar el estado de los campos al cargar la página
    updateFields();
    
    // Definir la variable contextPath para las llamadas AJAX
    // Esta línea se debe ajustar según tu configuración
    var contextPath = '';
});