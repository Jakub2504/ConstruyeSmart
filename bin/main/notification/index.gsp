<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Notificaciones - ConstruyeSmart</title>
    <asset:stylesheet src="notification.css"/>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Mis Notificaciones</h1>
            <div>
                <g:if test="${notifications}">
                    <g:link action="markAllAsRead" class="btn btn-outline-primary me-2">
                        <i class="fas fa-check-double"></i> Marcar todas como leídas
                    </g:link>
                    <g:link action="clearAll" class="btn btn-outline-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar todas las notificaciones?')">
                        <i class="fas fa-trash"></i> Limpiar todo
                    </g:link>
                </g:if>
            </div>
        </div>

        <g:if test="${flash.message}">
            <div class="alert alert-${flash.messageType ?: 'info'}">
                ${flash.message}
            </div>
        </g:if>

        <g:if test="${notifications}">
            <div class="notifications-list">
                <g:each in="${notifications}" var="notification">
                    <div class="notification ${notification.isRead ? 'read' : 'unread'}">
                        <div class="notification-content">
                            <div class="notification-icon">
                                <g:if test="${notification.type == 'comment'}">
                                    <i class="fas fa-comment"></i>
                                </g:if>
                                <g:elseif test="${notification.type == 'reply'}">
                                    <i class="fas fa-reply"></i>
                                </g:elseif>
                                <g:else>
                                    <i class="fas fa-bell"></i>
                                </g:else>
                            </div>
                            <div class="notification-body">
                                <p class="mb-1">${notification.message}</p>
                                <small class="text-muted">
                                    <g:formatDate date="${notification.dateCreated}" format="dd/MM/yyyy HH:mm"/>
                                </small>
                            </div>
                            <div class="notification-actions">
                                <g:if test="${!notification.isRead}">
                                    <g:link action="markAsRead" id="${notification.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-check"></i> Marcar como leída
                                    </g:link>
                                </g:if>
                                <g:link action="delete" id="${notification.id}" class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash"></i>
                                </g:link>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </g:if>
        <g:else>
            <div class="alert alert-info">
                No tienes notificaciones.
            </div>
        </g:else>
    </div>
</body>
</html> 