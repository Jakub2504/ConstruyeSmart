<!DOCTYPE html>
<html>
<head>
    <title>ROPLISP - Login</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
    *, *:before, *:after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    html, body {
        font-size: 62.5%;
        height: 100%;
        overflow: hidden;
    }
    @media (max-width: 768px) {
        html, body {
            font-size: 50%;
        }
    }

    svg {
        display: inline-block;
        width: 2rem;
        height: 2rem;
        overflow: visible;
    }

    .svg-icon {
        cursor: pointer;
    }
    .svg-icon path {
        stroke: rgba(255, 255, 255, 0.9);
        fill: none;
        stroke-width: 1;
    }

    input, button {
        outline: none;
        border: none;
    }

    .cont {
        position: relative;
        height: 100%;
        background-image: url("/assets/login-bg.jpeg");
        background-size: cover;
        overflow: auto;
        font-family: "Open Sans", Helvetica, Arial, sans-serif;
    }

    .demo {
        position: absolute;
        top: 50%;
        left: 50%;
        margin-left: -15rem;
        margin-top: -26.5rem;
        width: 30rem;
        height: 53rem;
        overflow: hidden;
    }

    .login {
        position: relative;
        height: 100%;
        background: linear-gradient(to bottom, rgba(146, 135, 187, 0.8) 0%, rgba(0, 0, 0, 0.6) 100%);
        transition: opacity 0.1s, transform 0.3s cubic-bezier(0.17, -0.65, 0.665, 1.25);
        transform: scale(1);
    }
    .login.inactive {
        opacity: 0;
        transform: scale(1.1);
    }
    .login__form {
        position: absolute;
        top: 50%;
        left: 0;
        width: 100%;
        height: 50%;
        padding: 1.5rem 2.5rem;
        text-align: center;
    }
    .login__row {
        height: 5rem;
        padding-top: 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    }
    .login__icon {
        margin-bottom: -0.4rem;
        margin-right: 0.5rem;
    }
    .login__icon.name path {
        stroke-dasharray: 73.50196075439453;
        stroke-dashoffset: 73.50196075439453;
        -webkit-animation: animatePath 2s 0.5s forwards;
        animation: animatePath 2s 0.5s forwards;
    }
    .login__icon.pass path {
        stroke-dasharray: 92.10662841796875;
        stroke-dashoffset: 92.10662841796875;
        -webkit-animation: animatePath 2s 0.5s forwards;
        animation: animatePath 2s 0.5s forwards;
    }
    .login__input {
        display: inline-block;
        width: 22rem;
        height: 100%;
        padding-left: 1.5rem;
        font-size: 1.5rem;
        background: transparent;
        color: #FDFCFD;
    }
    .login__submit {
        position: relative;
        width: 100%;
        height: 4rem;
        margin: 5rem 0 2.2rem;
        color: rgba(255, 255, 255, 0.8);
        background: #FF3366;
        font-size: 1.5rem;
        border-radius: 3rem;
        cursor: pointer;
        overflow: hidden;
        transition: width 0.3s 0.15s, font-size 0.1s 0.15s;
    }
    .login__submit:after {
        content: "";
        position: absolute;
        top: 50%;
        left: 50%;
        margin-left: -1.5rem;
        margin-top: -1.5rem;
        width: 3rem;
        height: 3rem;
        border: 2px dotted #fff;
        border-radius: 50%;
        border-left: none;
        border-bottom: none;
        transition: opacity 0.1s 0.4s;
        opacity: 0;
    }
    .login__submit.processing {
        width: 4rem;
        font-size: 0;
    }
    .login__submit.processing:after {
        opacity: 1;
        -webkit-animation: rotate 0.5s 0.4s infinite linear;
        animation: rotate 0.5s 0.4s infinite linear;
    }
    .login__submit.success {
        transition: transform 0.3s 0.1s ease-out, opacity 0.1s 0.3s, background-color 0.1s 0.3s;
        transform: scale(30);
        opacity: 0.9;
    }
    .login__submit.success:after {
        transition: opacity 0.1s 0s;
        opacity: 0;
        -webkit-animation: none;
        animation: none;
    }
    .login__signup {
        font-size: 1.2rem;
        color: #ABA8AE;
    }
    .login__signup a {
        color: #fff;
        cursor: pointer;
    }


    .ripple {
        position: absolute;
        width: 15rem;
        height: 15rem;
        margin-left: -7.5rem;
        margin-top: -7.5rem;
        background: rgba(0, 0, 0, 0.4);
        transform: scale(0);
        -webkit-animation: animRipple 0.4s;
        animation: animRipple 0.4s;
        border-radius: 50%;
    }

    @-webkit-keyframes animRipple {
        to {
            transform: scale(3.5);
            opacity: 0;
        }
    }

    @keyframes animRipple {
        to {
            transform: scale(3.5);
            opacity: 0;
        }
    }
    @-webkit-keyframes rotate {
        to {
            transform: rotate(360deg);
        }
    }
    @keyframes rotate {
        to {
            transform: rotate(360deg);
        }
    }
    @-webkit-keyframes animatePath {
        to {
            stroke-dashoffset: 0;
        }
    }
    @keyframes animatePath {
        to {
            stroke-dashoffset: 0;
        }
    }
    </style>
</head>
<body>
<g:if test='${flash.message}'>
    <div class="login_message" style="font-size: large; text-align: center; padding: 10px; background-color: gainsboro; border: 1px dashed blue;">${flash.message}</div>
</g:if>
<div class="cont">
    <div class="demo">
        <div class="login">

            <form action="${request.contextPath}/login/authenticate" method="POST" class="user" id="loginForm" autocomplete="off">
                <div class="login__form">
                    <div class="login__row">
                        <svg class="login__icon name svg-icon" viewBox="0 0 20 20">
                            <path d="M0,20 a10,8 0 0,1 20,0z M10,0 a4,4 0 0,1 0,8 a4,4 0 0,1 0,-8" />
                        </svg>
                        <input type="email" id="username" name="username" class="login__input name" placeholder="Email" autofocus />
                    </div>
                    <div class="login__row">
                        <svg class="login__icon pass svg-icon" viewBox="0 0 20 20">
                            <path d="M0,20 20,20 20,8 0,8z M10,13 10,16z M4,8 a6,8 0 0,1 12,0" />
                        </svg>
                        <input type="password" name="password" id="password" class="login__input pass" placeholder="Contraseña" required="required" />
                    </div>
                    <input type="submit" id="submit" class="login__submit" value="Entrar" />
                    <p class="login__signup"><g:link controller="user" action="forgotPassword"><g:message code="login.auth.forgotPassword" /></g:link></p>
                    <br />
                    <p class="login__signup"><g:link controller="home" action="index">Cancel</g:link></p>
                </div>
            </form>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function() {

        var animating = false;

        function ripple(elem, e) {
            $(".ripple").remove();
            var elTop = elem.offset().top,
                elLeft = elem.offset().left,
                x = e.pageX - elLeft,
                y = e.pageY - elTop;
            var $ripple = $("<div class='ripple'></div>");
            $ripple.css({top: y, left: x});
            elem.append($ripple);
        };

        $(document).on("click", ".login__submit", function(e) {
            if (animating) return;
            animating = true;
            var that = this;
            ripple($(that), e);
            $(that).addClass("processing");
            $('#loginForm').submit();
        });
    });
</script>
</body>
</html>
