package com.example

class NotificationController {
    def springSecurityService

    def index() {
        def user = springSecurityService.currentUser
        def notifications = Notification.findAllByRecipient(user, [sort: "dateCreated", order: "desc"])
        [notifications: notifications]
    }

    def markAsRead(Long id) {
        def notification = Notification.get(id)
        if (notification && notification.recipient == springSecurityService.currentUser) {
            notification.isRead = true
            notification.save()
        }
        redirect action: "index"
    }

    def markAllAsRead() {
        def user = springSecurityService.currentUser
        Notification.executeUpdate(
            "UPDATE Notification n SET n.isRead = true WHERE n.recipient = :user AND n.isRead = false",
            [user: user]
        )
        redirect action: "index"
    }

    def delete(Long id) {
        def notification = Notification.get(id)
        if (notification && notification.recipient == springSecurityService.currentUser) {
            notification.delete()
        }
        redirect action: "index"
    }

    def clearAll() {
        def user = springSecurityService.currentUser
        Notification.findAllByRecipient(user).each { it.delete() }
        redirect action: "index"
    }
} 