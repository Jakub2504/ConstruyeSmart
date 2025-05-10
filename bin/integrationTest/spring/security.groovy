import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository
import org.springframework.security.web.authentication.rememberme.InMemoryTokenRepositoryImpl
import org.springframework.security.authentication.dao.DaoAuthenticationProvider
import org.springframework.security.authentication.encoding.PasswordEncoder
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import com.example.CustomUserDetailsService

beans = {
    // Configuración del servicio de detalles de usuario
    userDetailsService(CustomUserDetailsService)

    // Configuración del codificador de contraseñas
    passwordEncoder(BCryptPasswordEncoder) {
        strength = 10
    }

    // Configuración del proveedor de autenticación
    daoAuthenticationProvider(DaoAuthenticationProvider) {
        userDetailsService = ref('userDetailsService')
        passwordEncoder = ref('passwordEncoder')
    }

    // Configuración del filtro de autenticación
    usernamePasswordAuthenticationFilter(UsernamePasswordAuthenticationFilter) {
        authenticationManager = ref('authenticationManager')
        rememberMeServices = ref('rememberMeServices')
        usernameParameter = 'username'
        passwordParameter = 'password'
        filterProcessesUrl = '/login/authenticate'
        authenticationSuccessHandler = ref('authenticationSuccessHandler')
        authenticationFailureHandler = ref('authenticationFailureHandler')
    }

    // Configuración del servicio "Remember Me"
    rememberMeKey(String, 'construyesmart-remember-me-key')

    rememberMeServices(TokenBasedRememberMeServices, ref('rememberMeKey')) {
        userDetailsService = ref('userDetailsService')
    }

    // Configuración del repositorio de tokens
    tokenRepository(InMemoryTokenRepositoryImpl)
} 