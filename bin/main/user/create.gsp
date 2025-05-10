<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Registro</title>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">Registro de Usuario</h3>
                    </div>
                    <div class="card-body">
                        <g:if test="${flash.error}">
                            <div class="alert alert-danger">
                                ${flash.error}
                            </div>
                        </g:if>

                        <g:hasErrors bean="${user}">
                            <div class="alert alert-danger">
                                <ul>
                                    <g:eachError bean="${user}" var="error">
                                        <li><g:message error="${error}"/></li>
                                    </g:eachError>
                                </ul>
                            </div>
                        </g:hasErrors>

                        <g:form controller="user" action="save" method="POST">
                            <div class="form-group">
                                <label for="username">Usuario:</label>
                                <g:textField name="username" value="${user?.username}" class="form-control" required="true"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="password">Contraseña:</label>
                                <g:passwordField name="password" class="form-control" required="true"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="password2">Confirmar Contraseña:</label>
                                <g:passwordField name="password2" class="form-control" required="true"/>
                            </div>
                            
                            <div class="form-group text-center mt-4">
                                <button type="submit" class="btn btn-primary">Registrarse</button>
                            </div>
                        </g:form>

                        <div class="text-center mt-3">
                            <p>¿Ya tienes una cuenta? <g:link controller="login" action="auth">Inicia sesión aquí</g:link></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>