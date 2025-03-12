<%@ page import="com.example.GameResult" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'game.label', default: 'Game')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="container-fluid mt-4 ml-4 mr-4 mb-4">
        <h2 class="text-center">GAME RESULT: YOU ${game?.isWinner == com.example.GameResult.WIN ? 'WIN!' : (game?.isWinner == GameResult.LOSE ? 'FAIL!' : 'DRAW!')}</h2>
        <div class="row mt-4 ml-4 mr-4 mb-4">
            <div class="col-4">
                <h3 class="text-center">Your Champion</h3>
                <g:if test="${game?.userChoice == com.example.Choice.ROCK}">
                    <g:set var="imgUser" value="rock.jpeg" />
                </g:if>
                <g:elseif test="${game?.userChoice == com.example.Choice.PAPER}">
                    <g:set var="imgUser" value="paper.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.userChoice == com.example.Choice.SCISSORS}">
                    <g:set var="imgUser" value="scissors.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.userChoice == com.example.Choice.LIZARD}">
                    <g:set var="imgUser" value="lizard.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.userChoice == com.example.Choice.SPOCK}">
                    <g:set var="imgUser" value="spock.jpeg" />
                </g:elseif>
                <asset:image src="${imgUser}" />
            </div>
            <div class="col-4">
                <h3 class="text-center">Your Opponent</h3>
                <g:if test="${game?.appChoice == com.example.Choice.ROCK}">
                    <g:set var="imgApp" value="rock.jpeg" />
                </g:if>
                <g:elseif test="${game?.appChoice == com.example.Choice.PAPER}">
                    <g:set var="imgApp" value="paper.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.appChoice == com.example.Choice.SCISSORS}">
                    <g:set var="imgApp" value="scissors.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.appChoice == com.example.Choice.LIZARD}">
                    <g:set var="imgApp" value="lizard.jpeg" />
                </g:elseif>
                <g:elseif test="${game?.appChoice == com.example.Choice.SPOCK}">
                    <g:set var="imgApp" value="spock.jpeg" />
                </g:elseif>
                <asset:image src="${imgApp}" />
            </div>
            <div class="col-4">
                <h3 class="text-center">The WINNER</h3>
                <g:if test="${game?.isWinner == com.example.GameResult.WIN}">
                    <asset:image src="${imgUser}" />
                </g:if>
                <g:elseif test="${game?.isWinner == com.example.GameResult.LOSE}">
                    <asset:image src="${imgApp}" />
                </g:elseif>
                <g:else>
                    <asset:image src="draw.jpeg" />
                </g:else>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-12 text-center">
                <g:link controller="game" action="create" class="site-btn">PLAY AGAIN</g:link>
            </div>
        </div>
    </div>
    </body>
</html>
