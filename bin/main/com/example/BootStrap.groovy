package com.example

import com.example.User
import com.example.Role
import com.example.UserRole
import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class BootStrap {

    def springSecurityService

    def init = { servletContext ->
        createDefaultRoles()
        createDefaultAdmin()
    }

    @Transactional
    def createDefaultRoles() {
        def adminRole = Role.findByAuthority('ROLE_ADMIN') ?: new Role(authority: 'ROLE_ADMIN').save(failOnError: true)
        def userRole = Role.findByAuthority('ROLE_USER') ?: new Role(authority: 'ROLE_USER').save(failOnError: true)
    }

    @Transactional
    def createDefaultAdmin() {
        def adminRole = Role.findByAuthority('ROLE_ADMIN')
        if (!adminRole) {
            println "Error: No se encontró el rol de administrador"
            return
        }

        def adminUser = User.findByUsername('admin')
        if (!adminUser) {
            def password = 'admin'
            println "Creando usuario admin con contraseña: ${password}"
            
            // Encriptar la contraseña usando springSecurityService
            def encodedPassword = springSecurityService.encodePassword(password)
            println "Contraseña encriptada: ${encodedPassword}"
            
            adminUser = new User(
                username: 'admin',
                password: encodedPassword,
                enabled: true,
                accountNonExpired: true,
                accountNonLocked: true,
                credentialsNonExpired: true
            )
            
            if (adminUser.save(failOnError: true)) {
                UserRole.create(adminUser, adminRole, true)
                println "Usuario administrador creado exitosamente"
                
                // Verificar que la autenticación funciona
                try {
                    def auth = springSecurityService.reauthenticate('admin', 'admin')
                    println "Verificación de autenticación exitosa: ${auth != null}"
                } catch (Exception e) {
                    println "Error al verificar la autenticación: ${e.message}"
                }
            } else {
                println "Error al crear el usuario administrador: ${adminUser.errors}"
            }
        } else {
            println "El usuario administrador ya existe"
        }
    }

    def destroy = {
    }
}