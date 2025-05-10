// Wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })

    // Update health metrics every minute
    setInterval(updateHealthMetrics, 60000)

    // Initialize charts
    initializeCharts()
})

// Function to update health metrics
function updateHealthMetrics() {
    fetch('/dashboard/getHealthMetrics')
        .then(response => response.json())
        .then(data => {
            updateMetricCards(data)
        })
        .catch(error => console.error('Error:', error))
}

// Function to update metric cards
function updateMetricCards(metrics) {
    const latestMetric = metrics[0]
    if (latestMetric) {
        document.querySelector('[data-metric="weight"]').textContent = `${latestMetric.weight} kg`
        document.querySelector('[data-metric="bmi"]').textContent = latestMetric.bmi.toFixed(1)
        document.querySelector('[data-metric="steps"]').textContent = latestMetric.steps
        document.querySelector('[data-metric="calories"]').textContent = 
            latestMetric.caloriesConsumed - latestMetric.caloriesBurned
    }
}

// Function to initialize charts
function initializeCharts() {
    // Weight chart
    const weightCtx = document.getElementById('weightChart')
    if (weightCtx) {
        new Chart(weightCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Weight (kg)',
                    data: [],
                    borderColor: '#2470dc',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: false
                    }
                }
            }
        })
    }

    // Steps chart
    const stepsCtx = document.getElementById('stepsChart')
    if (stepsCtx) {
        new Chart(stepsCtx, {
            type: 'bar',
            data: {
                labels: [],
                datasets: [{
                    label: 'Steps',
                    data: [],
                    backgroundColor: '#28a745'
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        })
    }
}

// Function to handle form submissions
function handleFormSubmit(formId, successCallback) {
    const form = document.getElementById(formId)
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault()
            const formData = new FormData(form)
            
            fetch(form.action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (successCallback) {
                    successCallback(data)
                }
            })
            .catch(error => console.error('Error:', error))
        })
    }
}

// Function to show notifications
function showNotification(message, type = 'success') {
    const notification = document.createElement('div')
    notification.className = `alert alert-${type} alert-dismissible fade show`
    notification.role = 'alert'
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `
    
    const container = document.querySelector('.notification-container')
    if (container) {
        container.appendChild(notification)
        setTimeout(() => {
            notification.remove()
        }, 5000)
    }
} 