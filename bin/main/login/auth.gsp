<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Iniciar Sesión</title>
    <asset:stylesheet src="login.css"/>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="text-center mb-4">
                <h2 class="login-title">Iniciar Sesión</h2>
                <p class="text-muted">Ingrese sus credenciales para continuar</p>
            </div>

            <g:if test="${flash.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <div>${flash.error}</div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </g:if>

            <g:if test="${flash.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-2"></i>
                        <div>${flash.message}</div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </g:if>

            <g:form controller="login" action="authenticate" method="POST" id="loginForm" autocomplete="off">
                <div class="form-group mb-3">
                    <label for="username" class="form-label">Usuario <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>
                        <input type="text" class="form-control" id="username" name="username" 
                               value="${params.username}" required autofocus
                               placeholder="Ingrese su usuario">
                        <div class="invalid-feedback">
                            Por favor, ingrese su usuario
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label for="password" class="form-label">Contraseña <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" class="form-control" id="password" name="password" 
                               required placeholder="Ingrese su contraseña">
                        <div class="invalid-feedback">
                            Por favor, ingrese su contraseña
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">Recordarme</label>
                    </div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
                    </button>
                </div>

                <div class="text-center mt-3">
                    <p class="mb-0">¿No tienes una cuenta? 
                        <g:link controller="login" action="register" class="text-primary">
                            Regístrate aquí
                        </g:link>
                    </p>
                </div>
            </g:form>
        </div>
    </div>

    <asset:javascript src="login.js"/>
</body>
</html>
