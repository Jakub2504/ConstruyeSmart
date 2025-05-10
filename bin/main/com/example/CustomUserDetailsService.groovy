package com.example

import grails.gorm.transactions.Transactional
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.GrantedAuthority

@Transactional
class CustomUserDetailsService implements UserDetailsService {

    @Override
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.debug("Intentando cargar usuario: ${username}")
        
        def user = com.example.User.findByUsername(username)
        
        if (!user) {
            log.warn("Usuario no encontrado en CustomUserDetailsService: ${username}")
            throw new UsernameNotFoundException("Usuario no encontrado: ${username}")
        }

        log.debug("Usuario encontrado: ${username}, enabled: ${user.enabled}")

        // Obtener los roles del usuario
        def authorities = UserRole.findAllByUser(user).collect { userRole ->
            new SimpleGrantedAuthority(userRole.role.authority)
        } as Set<GrantedAuthority>

        log.debug("Roles encontrados para usuario ${username}: ${authorities}")

        // Retornar nuestro User directamente ya que implementa UserDetails
        return user
    }
} 