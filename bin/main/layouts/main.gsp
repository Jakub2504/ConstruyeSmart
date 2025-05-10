<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><g:layoutTitle default="ConstruyeSmart"/></title>
    
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'images', file: 'favicon.ico')}">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <g:layoutHead/>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${createLink(uri: '/')}">
                ConstruyeSmart
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <g:if test="${!request.authenticated}">
                        <li class="nav-item">
                            <g:link class="nav-link" controller="login" action="auth">Iniciar Sesión</g:link>
                        </li>
                        <li class="nav-item">
                            <g:link class="nav-link" controller="login" action="register">Registrarse</g:link>
                        </li>
                    </g:if>
                    <g:else>
                        <li class="nav-item">
                            <g:link class="nav-link" controller="project" action="index">Mis Proyectos</g:link>
                        </li>
                        <li class="nav-item">
                            <g:link class="nav-link" controller="logout">Cerrar Sesión</g:link>
                        </li>
                    </g:else>
                </ul>
            </div>
        </div>
    </nav>

    <g:layoutBody/>

    <footer class="footer mt-auto py-3 bg-light">
        <div class="container text-center">
            <span class="text-muted">© 2024 ConstruyeSmart - Todos los derechos reservados</span>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>