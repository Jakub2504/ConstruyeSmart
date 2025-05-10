<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Health Tracker Dashboard</title>
    <asset:stylesheet src="dashboard.css"/>
    <asset:javascript src="dashboard.js"/>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#health-metrics">
                                <i class="fas fa-heartbeat"></i> Health Metrics
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#goals">
                                <i class="fas fa-bullseye"></i> Goals
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#exercises">
                                <i class="fas fa-dumbbell"></i> Exercises
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#meals">
                                <i class="fas fa-utensils"></i> Meals
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">Share</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        </div>
                    </div>
                </div>

                <!-- Health Metrics Summary -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Weight</h5>
                                <p class="card-text">${recentMetrics?.first()?.weight ?: 'N/A'} kg</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">BMI</h5>
                                <p class="card-text">${recentMetrics?.first()?.bmi ?: 'N/A'}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Steps Today</h5>
                                <p class="card-text">${recentMetrics?.first()?.steps ?: '0'}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Calories</h5>
                                <p class="card-text">${(recentMetrics?.first()?.caloriesConsumed ?: 0) - (recentMetrics?.first()?.caloriesBurned ?: 0)}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Active Goals -->
                <h2>Active Goals</h2>
                <div class="table-responsive">
                    <table class="table table-striped table-sm">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Progress</th>
                                <th>Target Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${activeGoals}" var="goal">
                                <tr>
                                    <td>${goal.title}</td>
                                    <td>${goal.goalType}</td>
                                    <td>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" style="width: ${goal.progressPercentage}%">
                                                ${goal.progressPercentage}%
                                            </div>
                                        </div>
                                    </td>
                                    <td><g:formatDate date="${goal.targetDate}" format="yyyy-MM-dd"/></td>
                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Activities -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h2>Recent Exercises</h2>
                        <div class="table-responsive">
                            <table class="table table-striped table-sm">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Duration</th>
                                        <th>Calories</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${recentExercises}" var="exercise">
                                        <tr>
                                            <td>${exercise.name}</td>
                                            <td>${exercise.exerciseType}</td>
                                            <td>${exercise.durationMinutes} min</td>
                                            <td>${exercise.caloriesBurned}</td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h2>Recent Meals</h2>
                        <div class="table-responsive">
                            <table class="table table-striped table-sm">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Calories</th>
                                        <th>Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in="${recentMeals}" var="meal">
                                        <tr>
                                            <td>${meal.name}</td>
                                            <td>${meal.mealType}</td>
                                            <td>${meal.calories}</td>
                                            <td><g:formatDate date="${meal.dateConsumed}" format="HH:mm"/></td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html> 