package com.example

import grails.plugin.springsecurity.annotation.Secured
import com.example.HealthMetric
import com.example.Goal
import com.example.Exercise
import com.example.User

@Secured(['ROLE_USER'])
class DashboardController {
    def springSecurityService
    
    def index() {
        def user = User.get(springSecurityService.currentUser.id)
        def recentMetrics = HealthMetric.findAllByUser(user, [sort: 'dateRecorded', order: 'desc', max: 5])
        def recentExercises = Exercise.findAllByUser(user, [sort: 'datePerformed', order: 'desc', max: 5])
        def activeGoals = Goal.findAllByUserAndCompleted(user, false, [sort: 'targetDate', order: 'asc'])
        
        [user: user, recentMetrics: recentMetrics, recentExercises: recentExercises, activeGoals: activeGoals]
    }
    
    def metrics() {
        def user = User.get(springSecurityService.currentUser.id)
        def metrics = HealthMetric.findAllByUser(user, [sort: 'dateRecorded', order: 'desc'])
        [metrics: metrics]
    }
    
    def exercises() {
        def user = User.get(springSecurityService.currentUser.id)
        def exercises = Exercise.findAllByUser(user, [sort: 'datePerformed', order: 'desc'])
        [exercises: exercises]
    }
    
    def goals() {
        def user = User.get(springSecurityService.currentUser.id)
        def goals = Goal.findAllByUser(user, [sort: 'targetDate', order: 'asc'])
        [goals: goals]
    }
} 