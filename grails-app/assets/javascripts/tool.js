document.addEventListener('DOMContentLoaded', function() {
    const mapElement = document.getElementById('rental-locations-map');
    if (mapElement) {
        initMap();
    }
});

function initMap() {
    const map = new google.maps.Map(document.getElementById('rental-locations-map'), {
        zoom: 12,
        center: { lat: 40.4168, lng: -3.7038 } // Madrid por defecto
    });

    const rentalLocations = document.querySelectorAll('.rental-location');
    rentalLocations.forEach(location => {
        const name = location.querySelector('h6').textContent;
        const address = location.querySelector('p').textContent;
        const rating = location.querySelector('.rating').textContent;

        // Geocodificar la dirección
        const geocoder = new google.maps.Geocoder();
        geocoder.geocode({ address: address }, function(results, status) {
            if (status === 'OK' && results[0]) {
                const marker = new google.maps.Marker({
                    map: map,
                    position: results[0].geometry.location,
                    title: name
                });

                const infoWindow = new google.maps.InfoWindow({
                    content: `
                        <div class="map-info-window">
                            <h6>${name}</h6>
                            <p>${address}</p>
                            <p>${rating}</p>
                        </div>
                    `
                });

                marker.addListener('click', function() {
                    infoWindow.open(map, marker);
                });
            }
        });
    });
} 