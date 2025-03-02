<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
    </head>
    <body>
    <p>Make your choice...</p>
    <g:form controller="game" action="save" useToken="true">
        <bf:formField bean="${this.game}" property="userChoice" width="6" required="required" />
        <input type="submit" value="PLAY" class="btn btn-primary mt-4">
    </g:form>
    </body>
</html>
