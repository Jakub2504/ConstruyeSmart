grails.profile = 'web'
grails.codegen.defaultPackage = 'com.example'

grails.mail.host = "smtp.gmail.com"
grails.mail.port = 465
grails.mail.username = "YOURMAIL@GMAIL.com"
grails.mail.password = "YOURPASSWORD"
grails.mail.props = [
	"mail.smtp.auth": "true",
	"mail.smtp.socketFactory.port": "465",
	"mail.smtp.socketFactory.class": "javax.net.ssl.SSLSocketFactory",
	"mail.smtp.socketFactory.fallback": "false"
]

// Configuración del codificador de contraseñas
grails.plugin.springsecurity.password.algorithm = 'bcrypt'
grails.plugin.springsecurity.password.bcrypt.logrounds = 12
grails.plugin.springsecurity.password.bcrypt.workFactor = 12
grails.plugin.springsecurity.password.bcrypt.strength = 12

// Configuración de logging para seguridad
grails.plugin.springsecurity.debug.useFilter = true
grails.plugin.springsecurity.debug.filterChain = true
grails.plugin.springsecurity.debug.passwordEncoder = true

// Configuración de seguridad
grails.plugin.springsecurity.securityConfigType = "Annotation"
grails.plugin.springsecurity.userLookup.userDomainClassName = 'com.example.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'com.example.UserRole'
grails.plugin.springsecurity.authority.className = 'com.example.Role'

// Configuración de filtros
grails.plugin.springsecurity.filterChain.chainMap = [
	[pattern: '/assets/**',      filters: 'none'],
	[pattern: '/**/js/**',       filters: 'none'],
	[pattern: '/**/css/**',      filters: 'none'],
	[pattern: '/**/images/**',   filters: 'none'],
	[pattern: '/favicon.ico',    filters: 'none'],
	[pattern: '/login/auth',     filters: 'none'],
	[pattern: '/login/authAjax', filters: 'none'],
	[pattern: '/login/deniedAjax', filters: 'none'],
	[pattern: '/login/authenticate', filters: 'JOINED_FILTERS'],
	[pattern: '/logout/**',      filters: 'JOINED_FILTERS'],
	[pattern: '/user/create',    filters: 'none'],
	[pattern: '/user/save',      filters: 'none'],
	[pattern: '/user/createAdmin', filters: 'none'],
	[pattern: '/**',             filters: 'JOINED_FILTERS']
]

// Configuración de autenticación
grails.plugin.springsecurity.auth.ajaxLoginFormUrl = '/login/authAjax'
grails.plugin.springsecurity.auth.ajaxDeniedUrl = '/login/deniedAjax'
grails.plugin.springsecurity.auth.loginFormUrl = '/login/auth'
grails.plugin.springsecurity.apf.filterProcessesUrl = '/login/authenticate'
grails.plugin.springsecurity.apf.usernameParameter = 'username'
grails.plugin.springsecurity.apf.passwordParameter = 'password'
grails.plugin.springsecurity.apf.postOnly = false
grails.plugin.springsecurity.apf.allowSessionCreation = true

// Configuración de reglas de seguridad
grails.plugin.springsecurity.controllerAnnotations.staticRules = [
	[pattern: '/',               access: ['permitAll']],
	[pattern: '/error',          access: ['permitAll']],
	[pattern: '/index',          access: ['permitAll']],
	[pattern: '/index.gsp',      access: ['permitAll']],
	[pattern: '/shutdown',       access: ['permitAll']],
	[pattern: '/assets/**',      access: ['permitAll']],
	[pattern: '/**/js/**',       access: ['permitAll']],
	[pattern: '/**/css/**',      access: ['permitAll']],
	[pattern: '/**/images/**',   access: ['permitAll']],
	[pattern: '/favicon.ico',    access: ['permitAll']],
	[pattern: '/login/**',       access: ['permitAll']],
	[pattern: '/logout/**',      access: ['permitAll']],
	[pattern: '/user/create',    access: ['permitAll']],
	[pattern: '/user/save',      access: ['permitAll']],
	[pattern: '/user/createAdmin', access: ['permitAll']],
	[pattern: '/home/**',        access: ['permitAll']],
	[pattern: '/home/index',     access: ['permitAll']],
	[pattern: '/home/index.gsp', access: ['permitAll']]
]

// Configuración adicional
grails.plugin.springsecurity.useSecurityEventListener = true
grails.plugin.springsecurity.logout.postOnly = false
grails.plugin.springsecurity.apf.storeLastUsername = true
grails.plugin.springsecurity.rejectIfNoRule = false
grails.plugin.springsecurity.fii.rejectPublicInvocations = false

// Configuración de manejo de errores
grails.plugin.springsecurity.failureHandler.exceptionMappings = [
	[exception: org.springframework.security.authentication.DisabledException.name,           url: '/user/accountDisabled'],
	[exception: org.springframework.security.authentication.CredentialsExpiredException.name, url: '/user/passwordExpired'],
	[exception: org.springframework.security.authentication.BadCredentialsException.name,     url: '/login/auth?login_error=1'],
	[exception: org.springframework.security.authentication.LockedException.name,             url: '/login/auth?login_error=2']
]

// Configuración de eventos
grails.plugin.springsecurity.onAuthenticationSuccessEvent = { e, appCtx ->
	com.example.User.withTransaction {
		def user = com.example.User.findByUsername(e.authentication.name)
		if (user) {
			user.lastLogin = new Date()
			user.loginCount++
			user.save(flush: true)
		}
	}
}

// Configuración de MongoDB
grails.mongodb = [
	host: "localhost",
	port: 27017,
	databaseName: "roplisp",
	options: [
		autoConnectRetry: true,
		connectTimeout: 30000,
		socketTimeout: 30000,
		maxWaitTime: 1500,
		maxPoolSize: 50
	]
]

// Configuración de logging para seguridad
logging.level.org.springframework.security = DEBUG
logging.level.grails.plugin.springsecurity = DEBUG
logging.level.com.example = DEBUG
