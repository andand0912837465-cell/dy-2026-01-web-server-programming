<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ch06 - app</title>
</head>
<body>
    <jsp:include page="link.jsp"/>
    <h1> app.jsp </h1>

<%
    MemberDto member = new MemberDto();
    member.setUserId("admin");
    member.setUserName("관리자");
    member.setEmail("hong@dy.ac.kr");
    application.setAttribute("member", member);
%>

</body>
</html>
