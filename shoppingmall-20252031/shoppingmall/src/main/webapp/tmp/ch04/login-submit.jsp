<%--
  Created by IntelliJ IDEA.
  User: 214
  Date: 26. 3. 27.
  Time: 오전 11:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인 처리</title>
</head>
<body>

<%
    //String method = request.getMethod();
    //out.println("<p>method: " + method + "</p>");

    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    if ("admin".equals(userId) && password.equals("1234")) {

    } else {
        response.sendRedirect("./index.jsp");
    }
%>

    <p>
        <%=userId%>
        , <%=password%>
    </p>

</body>
</html>
