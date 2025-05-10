package com.example

class UrlMappings {
    static mappings = {
        "/"(controller: "home", action: "index")
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/login"(controller: 'login', action: 'auth')
        "/login/auth"(controller: 'login', action: 'auth')
        "/login/authenticate"(controller: 'login', action: 'authenticate')
        "/login/register"(controller: 'login', action: 'register')
        "/home"(controller: 'home', action: 'index')
        "/home/index"(controller: 'home', action: 'index')
        "/calculator"(controller: 'calculator', action: 'index')
        "/calculator/**"(controller: 'calculator')
        "500"(view:'/error')
        "404"(view:'/notFound')

        "/create-admin"(controller: "user", action: "createAdmin")
    }
}
