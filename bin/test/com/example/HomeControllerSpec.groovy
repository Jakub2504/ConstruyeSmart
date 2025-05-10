package com.example

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class HomeControllerSpec extends Specification implements ControllerUnitTest<HomeController> {

    def setup() {
    }

    def cleanup() {
    }

    void "test index action shows the home page"() {
        when:"The index action is executed"
        controller.index()

        then:"The model is correct"
        model.stats != null
        model.featuredProjects != null
        model.tools != null
        model.constructionTips != null
        model.recentProjects != null
        view == '/index'
    }
}
