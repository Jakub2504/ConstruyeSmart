package com.example

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class CalendarController {
    
    def index() {
        render(view: 'development')
    }
}