document.addEventListener('DOMContentLoaded', function() {
    // Inicializar el sistema de valoración
    initRatingSystem();
    
    // Inicializar el filtro de dificultad
    initDifficultyFilter();
    
    // Inicializar el sistema de pasos
    initStepsSystem();
    initSearchForm();
});

function initRatingSystem() {
    const ratingStars = document.querySelectorAll('.rating-stars .fa-star-o');
    if (ratingStars.length > 0) {
        ratingStars.forEach((star, index) => {
            star.addEventListener('click', function() {
                const rating = index + 1;
                const tutorialId = this.closest('.rating-stars').dataset.tutorialId;
                rateTutorial(tutorialId, rating);
            });
        });
    }
}

function rateTutorial(tutorialId, rating) {
    fetch(`/tutorial/rate/${tutorialId}?rating=${rating}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            updateRatingDisplay(rating);
            showNotification('Gracias por tu valoración', 'success');
        } else {
            showNotification('Error al guardar la valoración', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Error al guardar la valoración', 'error');
    });
}

function updateRatingDisplay(rating) {
    const stars = document.querySelectorAll('.rating-stars .fa');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.remove('fa-star-o');
            star.classList.add('fa-star');
        } else {
            star.classList.remove('fa-star');
            star.classList.add('fa-star-o');
        }
    });
}

function initDifficultyFilter() {
    const difficultyFilter = document.getElementById('difficultyFilter');
    if (difficultyFilter) {
        difficultyFilter.addEventListener('change', function() {
            const selectedDifficulty = this.value;
            const tutorialCards = document.querySelectorAll('.tutorial-card');
            
            tutorialCards.forEach(card => {
                const cardDifficulty = card.querySelector('.badge').textContent;
                if (selectedDifficulty === '' || cardDifficulty === selectedDifficulty) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }
}

function initStepsSystem() {
    const addStepForm = document.getElementById('addStepForm');
    if (addStepForm) {
        addStepForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const stepInput = this.querySelector('input[name="step"]');
            const step = stepInput.value.trim();
            
            if (step) {
                const tutorialId = this.dataset.tutorialId;
                addStep(tutorialId, step);
                stepInput.value = '';
            }
        });
    }
}

function addStep(tutorialId, step) {
    fetch(`/tutorial/addStep/${tutorialId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `step=${encodeURIComponent(step)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            appendStepToList(step);
            showNotification('Paso añadido exitosamente', 'success');
        } else {
            showNotification('Error al añadir el paso', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Error al añadir el paso', 'error');
    });
}

function appendStepToList(step) {
    const stepsList = document.querySelector('.tutorial-steps');
    if (stepsList) {
        const stepElement = document.createElement('div');
        stepElement.className = 'tutorial-step';
        stepElement.textContent = step;
        stepsList.appendChild(stepElement);
    }
}

function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} alert-dismissible fade show`;
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    const container = document.querySelector('.container');
    container.insertBefore(notification, container.firstChild);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

function initSearchForm() {
    const searchForm = document.querySelector('.search-form');
    if (!searchForm) return;

    // Inicializar el select múltiple de tags
    const tagsSelect = searchForm.querySelector('select[name="tags"]');
    if (tagsSelect) {
        new Choices(tagsSelect, {
            removeItemButton: true,
            searchEnabled: true,
            placeholder: true,
            placeholderValue: 'Seleccionar tags...',
            searchPlaceholderValue: 'Buscar tags...'
        });
    }

    // Manejar el botón de limpiar filtros
    const clearFiltersBtn = searchForm.querySelector('.btn-secondary');
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = this.href;
        });
    }

    // Validar el formulario antes de enviar
    searchForm.addEventListener('submit', function(e) {
        const query = this.querySelector('input[name="query"]').value.trim();
        const author = this.querySelector('input[name="author"]').value.trim();
        const tags = Array.from(this.querySelector('select[name="tags"]').selectedOptions)
            .map(option => option.value);

        if (!query && !author && tags.length === 0) {
            e.preventDefault();
            showNotification('Por favor, ingrese al menos un criterio de búsqueda', 'warning');
        }
    });
} 