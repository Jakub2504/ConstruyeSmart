<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'leaderboard.label', default: 'Leaderboard')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    <div id="content" role="main">
        <div class="container">
            <section class="row">
                <a href="#list-leaderboard" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
                <div class="nav" role="navigation">
                    <ul>
                        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                        <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
                    </ul>
                </div>
            </section>
            <h2>Tria la teva opció</h2>
            <g:form controller="leaderboard" action="triarOpcio">
                <select name="op">
                    <option value="pedra">Pedra</option>
                    <option value="paper">Paper</option>
                    <option value="tisora">Tisora</option>
                </select>
                <input type="submit" value="GO">
            </g:form>

            <section class="row">
                <div id="list-leaderboard" class="col-12 content scaffold-list" role="main">
                    <h1><g:message code="default.list.label" args="[entityName]" /></h1>
                    <g:if test="${flash.message}">
                        <div class="message" role="status">${flash.message}</div>
                    </g:if>
                    <f:table collection="${leaderboardList}" />

                    <g:if test="${leaderboardCount > params.int('max')}">
                    <div class="pagination">
                        <g:paginate total="${leaderboardCount ?: 0}" />
                    </div>
                    </g:if>
                </div>
            </section>
        </div>
    </div>
    </body>
</html>