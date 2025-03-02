package com.example

import grails.gorm.services.Service

@Service(Leaderboard)
interface LeaderboardService {

    Leaderboard get(Serializable id)

    List<Leaderboard> list(Map args)

    Long count()

    void delete(Serializable id)

    Leaderboard save(Leaderboard leaderboard)

}