<%@ page import="kr.ac.dy.cs.adminUser.AdminUserDto" %>
<%@ page import="kr.ac.dy.cs.adminUser.AdminUserService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>관리자 등록 결과</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");

    AdminUserDto adminUser = AdminUserDto.builder()
            .adminId(request.getParameter("userId"))
            .adminName(request.getParameter("userName"))
            .password(request.getParameter("password"))
            .usingYn("Y")
            .build();

    AdminUserService adminUserService = new AdminUserService();
    boolean result = adminUserService.register(adminUser);
%>

<% if (result) { %>
    <script>
        alert('관리자 등록에 성공했습니다.');
        location.href = '/auth/adminLogin.jsp';
    </script>
<% } else { %>
    <script>
        alert('관리자 등록에 실패했습니다. 입력값 또는 중복 아이디를 확인해 주세요.');
        history.back();
    </script>
<% } %>

</body>
</html>
