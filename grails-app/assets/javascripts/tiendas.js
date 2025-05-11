document.addEventListener("DOMContentLoaded", function () {
    const tiendas = window.tiendas || [];

    if (tiendas.length === 0) {
        console.warn("No se encontraron tiendas para mostrar en el mapa.");
    }



    const map = L.map('map').setView([40.4168, -3.7038], 6); // Centro en España

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    tiendas.forEach(tienda => {
        if (tienda && tienda.lat && tienda.lon && tienda.nombre) {
            L.marker([tienda.lat, tienda.lon])
                .addTo(map)
                .bindPopup(`<b>${tienda.nombre}</b><br>${tienda.direccion}`);
        }
    });
});
