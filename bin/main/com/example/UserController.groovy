package com.example

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import com.example.User
import com.example.Role
import com.example.UserRole
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken

import static org.springframework.http.HttpStatus.*

class UserController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def springSecurityService
    def mailService
    def authenticationManager

    def create() {
        respond new User(params)
    }

    def save(User user) {
        if (user == null) {
            notFound()
            return
        }

        if(params['password'] != params['password2']) {
            flash.error = "Las contraseñas no coinciden"
            respond user, view: 'create'
            return
        }

        if(User.findByUsername(user.username)) {
            flash.error = "El usuario ya existe"
            respond user, view: 'create'
            return
        }

        try {
            // Codificar la contraseña
            user.password = springSecurityService.encodePassword(params.password)
            user.enabled = true
            user.accountNonExpired = true
            user.accountNonLocked = true
            user.credentialsNonExpired = true
            
            // Crear el rol ROLE_USER si no existe
            def role = Role.findByAuthority('ROLE_USER')
            if (!role) {
                role = new Role(authority: 'ROLE_USER').save(flush: true)
            }
            
            // Guardar el usuario
            user.save(flush: true)
            
            // Asignar el rol al usuario
            UserRole.create(user, role, true)

            flash.message = "Usuario registrado exitosamente"
            redirect controller: "login", action: "auth"
        } catch (ValidationException e) {
            respond user.errors, view:'create'
            return
        }
    }

    @Secured(['permitAll'])
    def createAdmin() {
        try {
            // Crear el rol ROLE_ADMIN si no existe
            def adminRole = Role.findByAuthority('ROLE_ADMIN')
            if (!adminRole) {
                adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
                log.info("Rol ROLE_ADMIN creado")
            }

            // Verificar si el usuario admin ya existe
            def adminUser = User.findByUsername('admin')
            if (!adminUser) {
                // Crear el usuario admin
                def password = 'admin'
                log.info("Contraseña original: ${password}")
                
                adminUser = new User(
                    username: 'admin',
                    password: password, // La contraseña será encriptada por UserPasswordEncoderListener
                    enabled: true,
                    accountNonExpired: true,
                    accountNonLocked: true,
                    credentialsNonExpired: true
                ).save(flush: true)
                log.info("Usuario admin creado")

                // Verificar que la autenticación funciona
                try {
                    def auth = authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken('admin', 'admin')
                    )
                    log.info("Verificación de autenticación exitosa: ${auth.authenticated}")
                } catch (Exception e) {
                    log.error("Error al verificar la autenticación: ${e.message}", e)
                }
            }

            // Verificar si el usuario ya tiene el rol ROLE_ADMIN
            def userRole = UserRole.findByUserAndRole(adminUser, adminRole)
            if (!userRole) {
                // Asignar el rol ROLE_ADMIN al usuario admin
                UserRole.create(adminUser, adminRole, true)
                log.info("Rol ROLE_ADMIN asignado al usuario admin")
            }

            // Verificar si el usuario tiene el rol ROLE_USER
            def userRole2 = Role.findByAuthority('ROLE_USER')
            if (!userRole2) {
                userRole2 = new Role(authority: 'ROLE_USER').save(flush: true)
            }
            def userRole3 = UserRole.findByUserAndRole(adminUser, userRole2)
            if (!userRole3) {
                UserRole.create(adminUser, userRole2, true)
                log.info("Rol ROLE_USER asignado al usuario admin")
            }

            flash.message = "Usuario admin creado exitosamente"
        } catch (Exception e) {
            log.error("Error al crear el usuario admin: ${e.message}", e)
            flash.error = "Error al crear el usuario admin: ${e.message}"
        }
        redirect controller: "login", action: "auth"
    }

    def forgotPassword() {

    }

    def passwordExpired() {
        [username: session['SPRING_SECURITY_LAST_USERNAME']]
    }

    def updatePassword() {
        def password = params?.password
        def password_new_1 = params?.password_new1
        def password_new_2 = params?.password_new2

        String username = session['SPRING_SECURITY_LAST_USERNAME']

        if (!username) {
            flash.message = 'Sorry, an error has occurred'
            redirect controller: 'login', action: 'auth'
            return
        }

        if (!password || !password_new_1 || !password_new_2 || password_new_1 != password_new_2 || password_new_1?.size() < 6 || password_new_1?.size() > 64) {
            flash.message = "La nueva contraseña no es correcta."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        User user = User.findByUsername(username)

        def passwordEncoder = new BCryptPasswordEncoder()
        if(!springSecurityService?.passwordEncoder.matches(password, user.password)) {
            flash.message = "La contraseña actual no es correcta."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        if (password.equals(password_new_1)) {
            flash.message = "La nueva contraseña no puede ser igual a la contraseña anterior."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        user.password = password_new_1
        user.passwordExpired = false
        user.save(failOnError: true)

        sendMail {
            to username
            from "no.reply.act.atac@gmail.com"
            subject "[ACT-ATAC] Cambio de contraseña."
            html view: "/email/password_changed"
        }

        flash.message = "Contraseña actualizada correctamente."

        redirect controller: 'login', action: 'auth'
        return
    }

    def passwordReset() {
        String username = params?.forgotUsername

        User user = User.findByUsername(username)

        if(user != null) {

            def generator = { String alphabet, int n ->
                new Random().with {
                    (1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
                }
            }

            def token = generator( (('A'..'Z')+('0'..'9')).join(), 15 )

            def uTok = username + "__" + token

            user.passwordResetToken = uTok
            user.save flush: true

            sendMail {
                to username
                from "no.reply.act.atac@gmail.com"
                subject "[SmokeFreeHomes] Reinicio de contraseña"
                html view: "/email/password_reset", model: [token: uTok]
            }
            flash.message = "Correo electrónico para restablecer la contraseña enviado correctamente."
        }
        else {
            flash.message = "No se pudo enviar el correo electrónico para restablecer la contraseña."
        }


        redirect controller: 'login', action: 'auth'
    }

    def newPassword() {
        def uTok = params?.uTok
        def username = uTok.split('__')[0]

        render view: 'newPassword', model: [username: username, uTok: uTok]
        return
    }

    def saveNewPassword() {
        String username = params?.uTok?.split("__")[0]
        String token = params?.uTok
        String password1 = params?.password_new1
        String password2 = params?.password_new2

        User user = User.findByUsernameAndPasswordResetToken(username, token)

        if(user != null && password1 && password2 && password1 == password2) {
            user.password = password1
            user.passwordResetToken = null
            user.save()
            flash.message = "Contraseña actualizada correctamente."
        }

        redirect controller: 'login', action: 'auth'
        return
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
