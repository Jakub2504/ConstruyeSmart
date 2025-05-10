
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="simple"/>
    <title>Presupuesto de Materiales</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 10px;
            color: #333;
            font-size: 10pt;
        }
        .header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 5px;
            border-bottom: 2px solid #2c3e50;
        }
        .header h1 {
            color: #2c3e50;
            margin-bottom: 5px;
            font-size: 18pt;
        }
        .header p {
            color: #7f8c8d;
            font-size: 9pt;
            margin-top: 0;
        }
        .summary {
            background-color: #f8f9fa;
            padding: 8px;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .summary-title {
            color: #2980b9;
            margin-top: 0;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
            font-size: 12pt;
        }
        .summary-row {
            margin-bottom: 3px;
        }
        .summary-label {
            font-weight: bold;
            min-width: 100px;
            display: inline-block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
            page-break-inside: auto;
            font-size: 8pt;
            table-layout: fixed; /* Para controlar mejor el ancho de columnas */
        }
        /* Define el ancho específico para cada columna */
        table th:nth-child(1), table td:nth-child(1) { width: 18%; } /* Material */
        table th:nth-child(2), table td:nth-child(2) { width: 12%; } /* Cantidad Base */
        table th:nth-child(3), table td:nth-child(3) { width: 12%; } /* Desperdicio */
        table th:nth-child(4), table td:nth-child(4) { width: 12%; } /* Cantidad Total */
        table th:nth-child(5), table td:nth-child(5) { width: 10%; } /* Unidad */
        table th:nth-child(6), table td:nth-child(6) { width: 16%; } /* Precio Unitario */
        table th:nth-child(7), table td:nth-child(7) { width: 14%; } /* Costo Total */
        
        /* Asegura que las filas no se rompan entre páginas */
        tr {
            page-break-inside: avoid;
            page-break-after: auto;
        }
        /* Asegura que el encabezado se repita en cada página */
        thead {
            display: table-header-group;
        }
        tfoot {
            display: table-footer-group;
        }
        th {
            background-color: #2c3e50;
            color: white;
            text-align: left;
            padding: 4px;
            font-size: 8pt;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        td {
            padding: 4px;
            border-bottom: 1px solid #ddd;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .total-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .cost {
            color: #27ae60;
            font-weight: bold;
        }
        .footer {
            font-size: 8pt;
            color: #7f8c8d;
            text-align: center;
            margin-top: 15px;
            padding-top: 5px;
            border-top: 1px solid #ddd;
        }
        .buttons {
            text-align: center;
            margin: 10px 0;
        }
        .btn {
            display: inline-block;
            padding: 8px 12px;
            background-color: #2c3e50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin: 0 10px;
            cursor: pointer;
            font-size: 10pt;
        }
        .btn-print {
            background-color: #27ae60;
        }
        .btn-close {
            background-color: #e74c3c;
        }
        
        /* Reglas específicas para impresión */
        @media print {
            @page {
                size: landscape; /* Orientación horizontal para imprimir */
                margin: 0.3cm; /* Márgenes muy reducidos */
            }
            body {
                margin: 0;
                padding: 0.3cm;
                font-size: 9pt;
            }
            .buttons {
                display: none;
            }
            h3 {
                font-size: 11pt;
                margin-top: 8px;
                margin-bottom: 6px;
            }
            /* Reducir espacios para optimizar impresión */
            .summary {
                padding: 5px;
                margin-bottom: 8px;
            }
            /* Asegurar que cada sección importante comience en una nueva página si es necesario */
            .page-break-before {
                page-break-before: always;
            }
            /* Asegurar que no hay saltos de página dentro de elementos importantes */
            .no-break {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    <div class="buttons">
        <a href="#" class="btn btn-print" onclick="window.print(); return false;">Imprimir Ahora</a>
        <a href="#" class="btn btn-close" onclick="window.close(); return false;">Cerrar</a>
    </div>

    <div class="header no-break">
        <h1>Presupuesto de Materiales</h1>
        <p>Generado el: ${date.format('dd/MM/yyyy HH:mm')}</p>
    </div>
    
    <div class="summary no-break">
        <h3 class="summary-title">Resumen del Proyecto</h3>
        <div class="summary-row">
            <span class="summary-label">Tipo:</span>
            <span>
                <g:if test="${projectType == 'wall'}">Pared</g:if>
                <g:elseif test="${projectType == 'floor'}">Piso</g:elseif>
                <g:elseif test="${projectType == 'ceiling'}">Techo</g:elseif>
                <g:elseif test="${projectType == 'roof'}">Tejado</g:elseif>
            </span>
        </div>
        <div class="summary-row">
            <span class="summary-label">Dimensiones:</span>
            <span>${length} m × ${width} m<g:if test="${projectType == 'wall'}"> × ${height} m</g:if></span>
        </div>
        <div class="summary-row">
            <span class="summary-label">Área:</span>
            <span>${area} m²</span>
        </div>
        <g:if test="${projectType == 'wall'}">
            <div class="summary-row">
                <span class="summary-label">Volumen:</span>
                <span>${volume} m³</span>
            </div>
        </g:if>
    </div>
    
    <h3>Materiales Necesarios</h3>
    <table>
        <thead>
            <tr>
                <th>Material</th>
                <th>Cantidad Base</th>
                <th>Desperdicio</th>
                <th>Cantidad Total</th>
                <th>Unidad</th>
                <th>Precio Unit.</th>
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
                <td colspan="6" style="text-align: right;">COSTO TOTAL:</td>
                <td class="cost">$${totalCost}</td>
            </tr>
        </tbody>
    </table>
    
    <div class="no-break">
        <h3>Notas importantes:</h3>
        <ul>
            <li>Las cantidades base son las necesarias para el proyecto sin considerar desperdicios.</li>
            <li>El desperdicio se calcula según el tipo de material (5-10% adicional).</li>
            <li>Los precios son estimados y pueden variar según la ubicación y el proveedor.</li>
            <li>No se incluyen costos de mano de obra o herramientas.</li>
        </ul>
    </div>
    
    <div class="footer">
        <p>Calculadora de Materiales - ©${new Date().format('yyyy')} - Este presupuesto es solamente una estimación</p>
    </div>
</body>
</html>