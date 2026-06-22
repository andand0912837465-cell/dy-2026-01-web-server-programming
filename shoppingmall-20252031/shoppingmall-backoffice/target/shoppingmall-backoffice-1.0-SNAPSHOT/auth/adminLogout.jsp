<%--
  Created by IntelliJ IDEA.
  User: 214
  Date: 26. 5. 22.
  Time: 오전 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        session.invalidate();
        response.sendRedirect("/");
    %>
</body>
</html>
