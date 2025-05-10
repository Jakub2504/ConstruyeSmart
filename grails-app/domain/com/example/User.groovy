package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

@Entity
class User implements UserDetails {
    ObjectId id
    String username
    String password
    boolean enabled = true
    boolean accountNonExpired = true
    boolean accountNonLocked = true
    boolean credentialsNonExpired = true
    String passwordResetToken
    Date lastLogin
    Integer loginCount = 0

    static hasMany = [authorities: Role]
    static belongsTo = Role

    static constraints = {
        username blank: false, unique: true
        password blank: false
        passwordResetToken nullable: true
        lastLogin nullable: true
        loginCount min: 0
    }

    static mapping = {
        collection "users"
        password column: '`password`'
        username index: true
        version false
    }

    Set<GrantedAuthority> getAuthorities() {
        UserRole.findAllByUser(this).collect {
            new SimpleGrantedAuthority(it.role.authority)
        } as Set
    }

    @Override
    boolean isAccountNonExpired() {
        return accountNonExpired
    }

    @Override
    boolean isAccountNonLocked() {
        return accountNonLocked
    }

    @Override
    boolean isCredentialsNonExpired() {
        return credentialsNonExpired
    }

    @Override
    boolean isEnabled() {
        return enabled
    }

    UserDetails asUserDetails() {
        new org.springframework.security.core.userdetails.User(
                username,
                password,
                enabled,
                !accountNonExpired,
                !credentialsNonExpired,
                !accountNonLocked,
                authorities
        )
    }

}