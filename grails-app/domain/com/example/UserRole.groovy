package com.example

import grails.gorm.annotation.Entity
import org.bson.types.ObjectId

@Entity
class UserRole {
    ObjectId id
    User user
    Role role

    static UserRole create(User user, Role role, boolean flush = false) {
        def instance = new UserRole(user: user, role: role)
        instance.save(flush: flush, insert: true)
        instance
    }

    static void remove(User user, Role role, boolean flush = false) {
        if (user == null || role == null) return

        def instance = UserRole.findByUserAndRole(user, role)
        if (!instance) return

        instance.delete(flush: flush)
    }

    static void removeAll(User user) {
        if (user == null) return

        UserRole.where { user == user }.deleteAll()
    }

    static void removeAll(Role role) {
        if (role == null) return

        UserRole.where { role == role }.deleteAll()
    }

    static constraints = {
        role validator: { Role r, UserRole ur ->
            if (ur.user == null) return
            boolean existing = false
            UserRole.withNewSession {
                existing = UserRole.findByUserAndRole(ur.user, r) != null
            }
            if (existing) {
                return 'userRole.exists'
            }
        }
    }

    static mapping = {
        id composite: ['user', 'role']
        version false
    }
} 