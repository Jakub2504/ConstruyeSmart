package com.example

class HomeController {

    def index() {
        def gameCount = Game.count()
        render view: "index", model: [gc: gameCount]
    }

    def howToPlay() {

    }
}
