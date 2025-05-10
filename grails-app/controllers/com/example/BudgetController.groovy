package com.example

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class BudgetController {
    
    def index() {
        render(view: 'development')
    }
}