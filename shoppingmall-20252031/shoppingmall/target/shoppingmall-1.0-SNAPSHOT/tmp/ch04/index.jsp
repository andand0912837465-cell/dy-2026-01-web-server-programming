<%--
  Created by IntelliJ IDEA.
  User: 214
  Date: 26. 3. 27.
  Time: 오전 11:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>GET - POST 실습</title>
</head>
<body>

    <p>GET - #1</p>
    <p>
        <a href="https://tv.naver.com/v/96506882">드라마</a>
    </p>

    <p>GET - #2 폼을 통해서 보냄</p>

    <div>
        <form method="get" action="login-submit.jsp" style="border: solid 1px red;">
            <input type="text" _name="userId" value="admin"/>
            <input type="password" name="password"  value="1234"/>
            <button type="submit">전송</button>
        </form>
    </div>

    <p>POST</p>

    <div>
        <form method="post" action="login-submit.jsp" style="border: solid 1px blue;">
            <input type="text" name="userId" value="admin"/>
            <input type="password" name="password"  value="1234"/>
            <button type="submit">전송</button>
        </form>
    </div>


    <div>
        <form method="get" action="../gugudan.jsp" style="border: solid 1px blue;">
            <input type="text" name="dan" value=""/>
            <button type="submit">전송</button>
        </form>
    </div>




</body>
</html>
