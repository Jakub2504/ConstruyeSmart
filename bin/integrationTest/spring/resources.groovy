import com.example.UserPasswordEncoderListener

// Place your Spring DSL code here
beans = {
    userPasswordEncoderListener(UserPasswordEncoderListener) { bean ->
        bean.autowire = true
    }
}
