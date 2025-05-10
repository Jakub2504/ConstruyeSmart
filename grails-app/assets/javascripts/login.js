$(document).ready(function() {
    // Inicializar tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Cerrar alertas automáticamente después de 5 segundos
    setTimeout(function() {
        var alertList = document.querySelectorAll('.alert')
        alertList.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert)
            bsAlert.close()
        });
    }, 5000);

    // Validación del formulario
    var form = document.querySelector('form')
    form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
        }
        form.classList.add('was-validated')
    }, false)

    // Validación en tiempo real
    var username = document.getElementById('username')
    var password = document.getElementById('password')

    username.addEventListener('input', function() {
        if (this.value.trim() === '') {
            this.setCustomValidity('Por favor, ingrese su usuario')
        } else {
            this.setCustomValidity('')
        }
    })

    password.addEventListener('input', function() {
        if (this.value.trim() === '') {
            this.setCustomValidity('Por favor, ingrese su contraseña')
        } else {
            this.setCustomValidity('')
        }
    })

    // Mostrar/ocultar contraseña
    var togglePassword = document.createElement('button')
    togglePassword.type = 'button'
    togglePassword.className = 'btn btn-outline-secondary'
    togglePassword.innerHTML = '<i class="fas fa-eye"></i>'
    togglePassword.style.position = 'absolute'
    togglePassword.style.right = '0'
    togglePassword.style.top = '0'
    togglePassword.style.zIndex = '10'

    var passwordContainer = password.parentElement
    passwordContainer.style.position = 'relative'
    passwordContainer.appendChild(togglePassword)

    togglePassword.addEventListener('click', function() {
        var type = password.getAttribute('type') === 'password' ? 'text' : 'password'
        password.setAttribute('type', type)
        this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>'
    })
}); 