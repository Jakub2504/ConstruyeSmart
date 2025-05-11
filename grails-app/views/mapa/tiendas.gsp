<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/> <!-- Usa el layout principal del sitio -->
    <title>Mapa de Tiendas</title>

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
    #map {
        height: 600px;
        width: 100%;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        margin-top: 20px;
    }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2 class="text-primary text-end">Mapa de Tiendas</h2>

    <div id="map" style="height: 600px; width: 100%; border-radius: 8px;"></div>

</div>

<script type="text/javascript">
    window.tiendas = JSON.parse("${tiendasJson.encodeAsJavaScript()}");
</script>



<asset:javascript src="tiendas.js"/>
</body>
</html>
