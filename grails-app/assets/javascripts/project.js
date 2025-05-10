$(document).ready(function() {
    // Inicializar el mapa de Google
    initMap();
    
    // Cargar el pronóstico del tiempo
    loadWeatherForecast();
    
    // Cargar videos tutoriales para cada paso
    $('.tutorial-videos').each(function() {
        loadTutorialVideos($(this));
    });
    
    // Cargar ubicaciones de alquiler para cada herramienta
    $('.tool-rental').each(function() {
        loadToolRentalLocations($(this));
    });
    
    // Cargar precios de materiales
    $('.material-prices').each(function() {
        loadMaterialPrices($(this));
    });
});

function initMap() {
    const map = new google.maps.Map(document.getElementById('hardware-stores-map'), {
        zoom: 12,
        center: { lat: 40.4168, lng: -3.7038 } // Madrid por defecto
    });
    
    // Obtener la ubicación del usuario
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const userLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            
            map.setCenter(userLocation);
            loadHardwareStores(map, userLocation);
        });
    }
}

function loadHardwareStores(map, location) {
    const locationStr = `${location.lat},${location.lng}`;
    
    $.get('/apiIntegration/getNearbyHardwareStores', { location: locationStr })
        .done(function(stores) {
            stores.forEach(function(store) {
                new google.maps.Marker({
                    position: { lat: store.location[0], lng: store.location[1] },
                    map: map,
                    title: store.name
                });
            });
        });
}

function loadWeatherForecast() {
    const location = 'Madrid'; // Por defecto
    
    $.get('/apiIntegration/getWeatherForecast', { location: location })
        .done(function(forecast) {
            const container = $('#weather-forecast');
            container.empty();
            
            forecast.forEach(function(day) {
                container.append(`
                    <div class="weather-day">
                        <div class="date">${formatDate(day.date)}</div>
                        <div class="temperature">${day.temperature}°C</div>
                        <div class="description">${day.description}</div>
                        <img src="http://openweathermap.org/img/wn/${day.icon}.png" alt="Weather icon">
                    </div>
                `);
            });
        });
}

function loadTutorialVideos(container) {
    const query = container.data('query');
    
    $.get('/apiIntegration/searchTutorialVideos', { query: query })
        .done(function(videos) {
            container.empty();
            
            videos.forEach(function(video) {
                container.append(`
                    <div class="video-item">
                        <img src="${video.thumbnail}" alt="${video.title}">
                        <div class="video-info">
                            <h6>${video.title}</h6>
                            <a href="https://www.youtube.com/watch?v=${video.videoId}" target="_blank">
                                Ver video
                            </a>
                        </div>
                    </div>
                `);
            });
        });
}

function loadToolRentalLocations(container) {
    const toolName = container.data('tool');
    const location = 'Madrid'; // Por defecto
    
    $.get('/apiIntegration/getToolRentalLocations', { 
        toolName: toolName,
        location: location
    })
    .done(function(locations) {
        container.empty();
        
        locations.forEach(function(location) {
            container.append(`
                <div class="rental-location">
                    <h6>${location.name}</h6>
                    <p>${location.address}</p>
                    <div class="rating">${location.rating} ⭐</div>
                </div>
            `);
        });
    });
}

function loadMaterialPrices(container) {
    const materialName = container.data('material');
    
    $.get('/apiIntegration/getMaterialPrices', { materialName: materialName })
        .done(function(prices) {
            container.empty();
            
            prices.forEach(function(price) {
                container.append(`
                    <div class="material-price">
                        <h6>${price.name}</h6>
                        <p>Precio: ${price.price} €</p>
                        <p>Disponibilidad: ${price.availability}</p>
                    </div>
                `);
            });
        });
}

function formatDate(date) {
    return new Date(date).toLocaleDateString('es-ES', {
        weekday: 'short',
        day: 'numeric',
        month: 'short'
    });
}

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar el formulario de búsqueda
    initSearchForm();
    
    // Inicializar los tooltips
    initTooltips();

    // Validación del formulario
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })

    // Validación del formulario
    var forms = document.querySelectorAll('.needs-validation')
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
            }
            form.classList.add('was-validated')
        }, false)
    })

    // Validación de fechas
    var startDate = document.getElementById('startDate')
    var estimatedEndDate = document.getElementById('estimatedEndDate')

    if (startDate && estimatedEndDate) {
        startDate.addEventListener('change', function() {
            if (estimatedEndDate.value && startDate.value > estimatedEndDate.value) {
                estimatedEndDate.setCustomValidity('La fecha de fin debe ser posterior a la fecha de inicio')
            } else {
                estimatedEndDate.setCustomValidity('')
            }
        })

        estimatedEndDate.addEventListener('change', function() {
            if (startDate.value && startDate.value > estimatedEndDate.value) {
                estimatedEndDate.setCustomValidity('La fecha de fin debe ser posterior a la fecha de inicio')
            } else {
                estimatedEndDate.setCustomValidity('')
            }
        })
    }

    // Validación de presupuesto
    var budget = document.getElementById('budget')
    if (budget) {
        budget.addEventListener('input', function() {
            if (this.value < 0) {
                this.setCustomValidity('El presupuesto no puede ser negativo')
            } else {
                this.setCustomValidity('')
            }
        })
    }

    // Validación de coordenadas
    var latitude = document.getElementById('latitude')
    var longitude = document.getElementById('longitude')

    if (latitude && longitude) {
        latitude.addEventListener('input', function() {
            if (this.value < -90 || this.value > 90) {
                this.setCustomValidity('La latitud debe estar entre -90 y 90')
            } else {
                this.setCustomValidity('')
            }
        })

        longitude.addEventListener('input', function() {
            if (this.value < -180 || this.value > 180) {
                this.setCustomValidity('La longitud debe estar entre -180 y 180')
            } else {
                this.setCustomValidity('')
            }
        })
    }

    // Validación de URL de imagen
    var imageUrl = document.getElementById('imageUrl')
    if (imageUrl) {
        imageUrl.addEventListener('input', function() {
            if (this.value && !isValidImageUrl(this.value)) {
                this.setCustomValidity('Por favor ingrese una URL de imagen válida')
            } else {
                this.setCustomValidity('')
            }
        })
    }
});

function initSearchForm() {
    const searchForm = document.querySelector('.search-form');
    if (!searchForm) return;
    
    // Validar fechas
    const startDateInput = searchForm.querySelector('input[name="startDate"]');
    const endDateInput = searchForm.querySelector('input[name="endDate"]');
    
    if (startDateInput && endDateInput) {
        startDateInput.addEventListener('change', function() {
            if (this.value && endDateInput.value && this.value > endDateInput.value) {
                endDateInput.value = this.value;
            }
        });
        
        endDateInput.addEventListener('change', function() {
            if (this.value && startDateInput.value && this.value < startDateInput.value) {
                startDateInput.value = this.value;
            }
        });
    }
    
    // Validar presupuestos
    const minBudgetInput = searchForm.querySelector('input[name="minBudget"]');
    const maxBudgetInput = searchForm.querySelector('input[name="maxBudget"]');
    
    if (minBudgetInput && maxBudgetInput) {
        minBudgetInput.addEventListener('change', function() {
            if (this.value && maxBudgetInput.value && parseFloat(this.value) > parseFloat(maxBudgetInput.value)) {
                maxBudgetInput.value = this.value;
            }
        });
        
        maxBudgetInput.addEventListener('change', function() {
            if (this.value && minBudgetInput.value && parseFloat(this.value) < parseFloat(minBudgetInput.value)) {
                minBudgetInput.value = this.value;
            }
        });
    }
}

function initTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Función para mostrar notificaciones
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
    notification.style.zIndex = '9999';
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 5000);
}

// Función para actualizar el progreso de un proyecto
function updateProjectProgress(projectId, progress) {
    const progressBar = document.querySelector(`#project-${projectId} .progress-bar`);
    if (progressBar) {
        progressBar.style.width = `${progress}%`;
        progressBar.setAttribute('aria-valuenow', progress);
        progressBar.textContent = `${Math.round(progress)}%`;
    }
}

// Función para actualizar el estado de un proyecto
function updateProjectStatus(projectId, status) {
    const statusBadge = document.querySelector(`#project-${projectId} .status-badge`);
    if (statusBadge) {
        statusBadge.className = `badge bg-${getStatusColor(status)}`;
        statusBadge.textContent = status;
    }
}

// Función auxiliar para obtener el color según el estado
function getStatusColor(status) {
    switch (status) {
        case 'PLANIFICACION':
            return 'info';
        case 'EN_PROGRESO':
            return 'warning';
        case 'COMPLETADO':
            return 'success';
        case 'CANCELADO':
            return 'danger';
        default:
            return 'secondary';
    }
}

// Función para validar URLs de imágenes
function isValidImageUrl(url) {
    return /^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$/i.test(url)
}

// Función para mostrar mensajes de error
function showError(message) {
    var alertDiv = document.createElement('div')
    alertDiv.className = 'alert alert-danger alert-dismissible fade show'
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-circle"></i> ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `
    document.querySelector('.card-body').insertBefore(alertDiv, document.querySelector('form'))
}

// Función para mostrar mensajes de éxito
function showSuccess(message) {
    var alertDiv = document.createElement('div')
    alertDiv.className = 'alert alert-success alert-dismissible fade show'
    alertDiv.innerHTML = `
        <i class="fas fa-check-circle"></i> ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `
    document.querySelector('.card-body').insertBefore(alertDiv, document.querySelector('form'))
}

// Función para limpiar el formulario
function resetForm() {
    var form = document.querySelector('form')
    form.reset()
    form.classList.remove('was-validated')
    var alerts = document.querySelectorAll('.alert')
    alerts.forEach(function(alert) {
        alert.remove()
    })
}

// Función para validar el formulario antes de enviar
function validateForm() {
    var form = document.querySelector('form')
    if (!form.checkValidity()) {
        event.preventDefault()
        event.stopPropagation()
        form.classList.add('was-validated')
        return false
    }
    return true
} 