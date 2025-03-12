<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <style>
        .content {
            background-color: #000;
            display: block;
            margin: 0 auto;
            width: 800px;
        }

        .content .image {
            background-color: #ccc;
            cursor: pointer;
            display: block;
            height: 190px;
            float: left;
            margin: 1%;
            overflow: hidden;
            position: relative;
            width: 31%;
        }

        .content .imageplay {
            background-color: #ccc;
            cursor: pointer;
            display: block;
            height: 190px;
            float: left;
            margin: 1%;
            overflow: hidden;
            position: relative;
            width: 31%;
        }

        .content .image::after {
            -webkit-transform: translate(0, 100%);
            -moz-transform: translate(0, 100%);
            transform: translate(0, 100%);

            -webkit-transition:all .25s cubic-bezier(.25,.46,.45,.94);
            -moz-transition:all .25s cubic-bezier(.25,.46,.45,.94);
            transition:all .25s cubic-bezier(.25,.46,.45,.94);

            background: #b30000 url('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Eo_circle_pink_checkmark.svg/2048px-Eo_circle_pink_checkmark.svg.png') no-repeat center center;
            background-size: 18px 18px;
            bottom: 0;
            content: '';
            display: block;
            height: 30px;
            left: 0;
            opacity: 0.5;
            position: absolute;
            margin: 0 auto;
            right: 0;
            width: 100%;
        }

        .content .image:hover::after {
            -webkit-transform: translate(0, 0);
            -moz-transform: translate(0, 0);
            transform: translate(0, 0);
        }

        .content .image.active::after {
            -webkit-transform: translate(0, -15px);
            -moz-transform: translate(0, -15px);
            transform: translate(0, -15px);

            border-radius: 100px;
            height: 48px;
            opacity: 1;
            width: 48px;
        }

        .content .image input { display: none }
        </style>
    </head>
    <body>
    <div class="container-fluid mt-4 ml-4 mr-4 mb-4">
        <h2 class="text-center">PLAY!</h2>
        <div class="row mt-4 ml-4 mr-4 mb-4">
            <div class="col-12">
                <h3 class="text-center">Select your Champion</h3>
                <g:form controller="game" action="save" useToken="true" name="playForm">
                    <div class="content">
                        <div class="image"><asset:image src="rock.jpeg" /><input type="radio" name="userChoice" id="ROCK" value="ROCK" /></div>
                        <div class="image"><asset:image src="paper.jpeg" /><input type="radio" name="userChoice" value="PAPER" /></div>
                        <div class="image"><asset:image src="scissors.jpeg" /><input type="radio" name="userChoice" value="SCISSORS" /></div>
                        <div class="image"><asset:image src="lizard.jpeg" /><input type="radio" name="userChoice" value="LIZARD" /></div>
                        <div class="image"><asset:image src="spock.jpeg" /><input type="radio" name="userChoice" value="SPOCK" /></div>
                        <div class="imageplay"><asset:image src="play.jpeg" /></div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
    <content tag="footScripts">
        <script>
            $(function() {
                $('.content .image').click(function () {
                    $('.content .image').removeClass('active');
                    $(this).addClass('active').find('input[type=radio]').prop('checked', true);
                });
                $('.imageplay').click(function () {
                    document.playForm.submit();
                });
            });
        </script>
    </content>
    </body>
</html>
