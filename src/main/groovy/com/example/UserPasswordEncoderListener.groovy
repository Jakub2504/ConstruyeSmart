package com.example

import grails.plugin.springsecurity.SpringSecurityService
import grails.gorm.transactions.Transactional
import org.grails.datastore.mapping.engine.event.AbstractPersistenceEvent
import org.grails.datastore.mapping.engine.event.PreInsertEvent
import org.grails.datastore.mapping.engine.event.PreUpdateEvent
import org.springframework.beans.factory.annotation.Autowired
import grails.events.annotation.gorm.Listener
import groovy.transform.CompileStatic
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@CompileStatic
class UserPasswordEncoderListener {
    private static final Logger log = LoggerFactory.getLogger(UserPasswordEncoderListener)

    @Autowired
    SpringSecurityService springSecurityService

    @Listener(User)
    void onPreInsertEvent(PreInsertEvent event) {
        log.debug("Evento PreInsert detectado para User")
        encodePasswordForEvent(event)
    }

    @Listener(User)
    void onPreUpdateEvent(PreUpdateEvent event) {
        log.debug("Evento PreUpdate detectado para User")
        encodePasswordForEvent(event)
    }

    private void encodePasswordForEvent(AbstractPersistenceEvent event) {
        if (event.entityObject instanceof User) {
            User user = (User) event.entityObject
            log.info("=== PROCESO DE ENCRIPTACIÓN DE CONTRASEÑA ===")
            log.info("Usuario: ${user.username}")
            
            if (user.password) {
                boolean shouldEncode = (event instanceof PreInsertEvent) || 
                    (event instanceof PreUpdateEvent && user.isDirty('password'))
                
                // Verificar si la contraseña ya está encriptada
                boolean isAlreadyEncoded = user.password.startsWith('{bcrypt}')
                
                log.info("Contraseña sin encriptar: ${user.password}")
                log.info("¿Debe encriptarse?: ${shouldEncode}")
                log.info("¿Ya está encriptada?: ${isAlreadyEncoded}")
                
                if (shouldEncode && !isAlreadyEncoded) {
                    String encodedPassword = encodePassword(user.password)
                    log.info("Contraseña encriptada: ${encodedPassword}")
                    event.getEntityAccess().setProperty('password', encodedPassword)
                } else if (isAlreadyEncoded) {
                    log.info("La contraseña ya está encriptada, no se modificará")
                }
            } else {
                log.warn("No se encontró contraseña para el usuario ${user.username}")
            }
            log.info("==========================================")
        }
    }

    private String encodePassword(String password) {
        if (!springSecurityService?.passwordEncoder) {
            log.error("No se encontró el codificador de contraseñas")
            return password
        }
        
        try {
            String encoded = springSecurityService.encodePassword(password)
            log.info("Encriptación exitosa:")
            log.info("- Contraseña original: ${password}")
            log.info("- Contraseña encriptada: ${encoded}")
            log.info("- Longitud de la encriptación: ${encoded.length()}")
            return encoded
        } catch (Exception e) {
            log.error("Error al encriptar contraseña: ${e.message}", e)
            throw e
        }
    }
} 