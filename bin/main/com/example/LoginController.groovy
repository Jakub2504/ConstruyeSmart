package com.example

import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.web.authentication.RememberMeServices
import org.springframework.security.web.savedrequest.HttpSessionRequestCache
import org.springframework.security.web.savedrequest.SavedRequest
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UsernameNotFoundException

@Secured(['permitAll'])
class LoginController {
    SpringSecurityService springSecurityService
    UserDetailsService userDetailsService
    AuthenticationManager authenticationManager
    RememberMeServices rememberMeServices

    def index() {
        if (springSecurityService.isLoggedIn()) {
            redirect(controller: 'home', action: 'index')
            return
        }
        redirect(action: 'auth')
    }

    def auth() {
        def config = springSecurityService.securityConfig

        if (springSecurityService.isLoggedIn()) {
            redirect(controller: 'home', action: 'index')
            return
        }

        String view = 'auth'
        String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"

        if (params.login_error) {
            def username = params.username
            log.debug("Error de autenticación para usuario: ${username}")
            
            def user = User.findByUsername(username)
            log.debug("Usuario encontrado en base de datos: ${user != null}")
            
            if (!user) {
                flash.error = "El usuario no existe"
                log.warn("Usuario no encontrado: ${username}")
            } else if (!user.enabled) {
                flash.error = "La cuenta está deshabilitada"
                log.warn("Cuenta deshabilitada: ${username}")
            } else {
                flash.error = "Usuario o contraseña incorrectos"
                log.warn("Credenciales incorrectas para usuario: ${username}")
            }
        }

        render view: view, model: [postUrl: postUrl,
                                 rememberMeParameter: config.rememberMe.parameter,
                                 usernameParameter: config.apf.usernameParameter,
                                 passwordParameter: config.apf.passwordParameter,
                                 gspLayout: 'main']
    }

    def authenticate() {
        String username = params.username
        String password = params.password
        
        log.info("=== INTENTO DE AUTENTICACIÓN ===")
        log.info("Usuario: ${username}")
        log.info("Contraseña ingresada: ${password}")
        
        try {
            def user = User.findByUsername(username)
            if (user) {
                log.info("Usuario encontrado en la base de datos")
                log.info("Contraseña almacenada: ${user.password}")
                log.info("Estado de la cuenta:")
                log.info("- Habilitada: ${user.enabled}")
                log.info("- No expirada: ${user.accountNonExpired}")
                log.info("- No bloqueada: ${user.accountNonLocked}")
                log.info("- Credenciales no expiradas: ${user.credentialsNonExpired}")
                
                if (!user.enabled) {
                    log.warn("Cuenta deshabilitada")
                    flash.error = "Tu cuenta está deshabilitada"
                    redirect(action: "auth")
                    return
                }
                
                try {
                    // Usar authenticationManager directamente
                    log.info("Intentando autenticar con authenticationManager")
                    def userDetails = userDetailsService.loadUserByUsername(username)
                    def authRequest = new UsernamePasswordAuthenticationToken(userDetails, password, userDetails.authorities)
                    def auth = authenticationManager.authenticate(authRequest)
                    log.info("Resultado de autenticación: ${auth}")
                    
                    if (auth && auth.authenticated) {
                        log.info("Autenticación exitosa")
                        
                        // Establecer el contexto de seguridad
                        SecurityContextHolder.context.authentication = auth
                        
                        // Actualizar el usuario
                        user.lastLogin = new Date()
                        user.loginCount = (user.loginCount ?: 0) + 1
                        user.save(flush: true)
                        
                        // Configurar la sesión
                        session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.context)
                        
                        // Obtener la URL guardada usando HttpSessionRequestCache
                        def requestCache = new HttpSessionRequestCache()
                        def savedRequest = requestCache.getRequest(request, response)
                        def targetUrl = savedRequest?.redirectUrl ?: "/home/index"
                        
                        log.info("Redirigiendo a: ${targetUrl}")
                        redirect(url: targetUrl)
                    } else {
                        log.warn("Autenticación fallida - No autenticado")
                        flash.error = "Credenciales incorrectas"
                        redirect(action: "auth")
                    }
                } catch (Exception e) {
                    log.error("Error durante la autenticación: ${e.message}", e)
                    flash.error = "Credenciales incorrectas"
                    redirect(action: "auth")
                }
            } else {
                log.warn("Usuario no encontrado")
                flash.error = "Usuario no encontrado"
                redirect(action: "auth")
            }
        } catch (Exception e) {
            log.error("Error general: ${e.message}", e)
            flash.error = "Error durante la autenticación"
            redirect(action: "auth")
        }
        log.info("=================================")
    }

    def denied() {
        if (springSecurityService.isLoggedIn() && request.isUserInRole('ROLE_ADMIN')) {
            redirect controller: 'home', action: 'index'
            return
        }
        render view: 'denied', model: [gspLayout: 'main']
    }

    def ajaxDenied() {
        render contentType: 'application/json', text: [error: 'access denied'] as JSON
    }

    def ajaxSuccess() {
        render contentType: 'application/json', text: [success: true, username: springSecurityService.authentication.name] as JSON
    }

    def register() {
        if (request.method == 'POST') {
            def username = params.username
            def password = params.password
            def email = params.email

            log.debug("Intento de registro para usuario: ${username}")
            log.debug("Password sin encriptar: ${password}")

            if (User.findByUsername(username)) {
                flash.error = "El nombre de usuario ya existe"
                [user: new User(username: username, email: email)]
                render(view: 'register')
                return
            }

            try {
                // Crear el usuario con la contraseña sin codificar
                def user = new User(
                    username: username,
                    password: password, // La contraseña será codificada por el UserPasswordEncoderListener
                    email: email,
                    enabled: true,
                    accountNonExpired: true,
                    accountNonLocked: true,
                    credentialsNonExpired: true
                )

                if (!user.save(flush: true)) {
                    log.error("Error al guardar usuario: ${user.errors}")
                    flash.error = "Error al registrar usuario"
                    [user: user]
                    render(view: 'register')
                    return
                }

                log.debug("Usuario guardado. Password encriptada: ${user.password}")

                def role = Role.findByAuthority('ROLE_USER')
                if (!role) {
                    role = new Role(authority: 'ROLE_USER').save(flush: true)
                }
                UserRole.create(user, role, true)

                // Autenticar al usuario después del registro exitoso
                try {
                    // Cargar los detalles del usuario
                    def userDetails = userDetailsService.loadUserByUsername(username)
                    
                    // Crear el token de autenticación
                    def authRequest = new UsernamePasswordAuthenticationToken(userDetails, password, userDetails.authorities)
                    
                    // Intentar autenticar
                    def auth = authenticationManager.authenticate(authRequest)
                    
                    if (auth && auth.authenticated) {
                        // Establecer el contexto de seguridad
                        SecurityContextHolder.context.authentication = auth
                        
                        // Actualizar el usuario
                        user.lastLogin = new Date()
                        user.loginCount = 1
                        user.save(flush: true)
                        
                        log.info("Registro y autenticación exitosos para usuario: ${username}")
                        flash.message = "¡Bienvenido! Tu cuenta ha sido creada exitosamente."
                        redirect(controller: 'home', action: 'index')
                        return
                    } else {
                        throw new Exception("La autenticación falló después del registro")
                    }
                } catch (Exception e) {
                    log.error "Error al autenticar después del registro: ${e.message}", e
                    flash.error = "Error al crear la cuenta. Por favor, intente nuevamente."
                    redirect(action: 'register')
                    return
                }
            } catch (Exception e) {
                log.error("Error general durante el registro: ${e.message}", e)
                flash.error = "Error al crear la cuenta. Por favor, intente nuevamente."
                redirect(action: 'register')
                return
            }
        } else {
            [user: new User()]
        }
    }
} 