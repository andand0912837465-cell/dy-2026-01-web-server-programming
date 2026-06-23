<%--
  Created by IntelliJ IDEA.
  User: 214
  Date: 26. 5. 22.
  Time: 오전 10:19
  To change this template use File | Settings | File Templates.
  20252377 양효재
  로그아웃 후 루트(/)로 돌아가면서 다른 앱 메인처럼 보일 수 있어서 수정하였다.
  세션 종료 후에는 현재 백오피스 컨텍스트 기준 관리자 로그인 화면으로 이동시킨다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        String contextPath = request.getContextPath();
        session.invalidate();
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
    %>
</body>
</html>
