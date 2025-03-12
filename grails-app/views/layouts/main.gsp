<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title><g:layoutTitle default="ROPLISP"/></title>
    <meta name="description" content="Rock Paper Sciessors Lizard Spock Game">
    <meta name="keywords" content="rock, paper, scissors, lizard, spock, game">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,400i,500,500i,700,700i" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <asset:stylesheet src="application.css"/>
    <!--[if lt IE 9]>
	  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
    <g:layoutHead/>
</head>
<body>
<!-- Page Preloder -->
<div id="preloder">
    <div class="loader"></div>
</div>

<!-- Header section -->
<header class="header-section">
    <div class="container">
        <!-- logo -->
        <g:link controller="home" action="index" class="site-logo">
            <asset:image src="roplisp-logo.png" alt="ROPLISP Logo" width="64" />
        </g:link>
        <div class="user-panel">
            <sec:ifLoggedIn>
                <g:link controller="game" action="create">PLAY!</g:link> /
                <g:link controller="logout">Logout</g:link>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
            <g:link controller="login" action="auth">Login</g:link> /
            <g:link controller="user" action="create">Register</g:link>
            </sec:ifNotLoggedIn>
        </div>
        <!-- responsive -->
        <div class="nav-switch">
            <i class="fa fa-bars"></i>
        </div>
        <!-- site menu -->
        <nav class="main-menu">
            <ul>
                <li><g:link controller="home" action="index">Home</g:link></li>
                <li><g:link controller="game" action="index">Games</g:link></li>
                <li><g:link controller="home" action="howToPlay">How to play</g:link></li>
                <li><g:link controller="home" action="about">About us</g:link></li>
                <li><g:link controller="home" action="contact">Contact</g:link></li>
            </ul>
        </nav>
    </div>
</header>
<!-- Header section end -->

<g:layoutBody/>

<!-- Footer section -->
<footer class="footer-section">
    <div class="container">
        <ul class="footer-menu">
            <li><g:link controller="home" action="index">Home</g:link></li>
            <li><g:link controller="home" action="howToPlay">How To PLay</g:link></li>
            <sec:ifAllGranted roles='ROLE_ADMIN'>
                <li><a href="contact.html">Admin</a></li>
            </sec:ifAllGranted>
        </ul>
        <p class="copyright"><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
        Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved, whatever that means <i class="fa fa-heart-o" aria-hidden="true"></i>
            <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
        </p>
    </div>
</footer>
<!-- Footer section end -->


<!--====== Javascripts & Jquery ======-->
<!-- Font Awesome for Icons -->
<script src="https://kit.fontawesome.com/292f181dff.js" crossorigin="anonymous"></script>
<asset:javascript src="application.js"/>
<!-- Custom placeholder for page scripts -->
<g:ifPageProperty name="page.footScripts">
    <g:pageProperty name="page.footScripts" />
</g:ifPageProperty>
</body>
</html>