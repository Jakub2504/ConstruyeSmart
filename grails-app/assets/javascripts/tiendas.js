document.addEventListener("DOMContentLoaded", function () {
    const tiendas = window.tiendas || [];

    const map = L.map('map').setView([40.4168, -3.7038], 6); // Centrado en España

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    tiendas.forEach(tienda => {
        if (tienda && tienda.lat && tienda.lon && tienda.nombre) {
            const marker = L.marker([
                parseFloat(tienda.lat),
                parseFloat(tienda.lon)
            ]).addTo(map);

            marker.bindPopup(`<b>${tienda.nombre}</b><br>${tienda.direccion || ''}`);
        } else {
            console.warn("Tienda no válida:", tienda);
        }
    });
});
