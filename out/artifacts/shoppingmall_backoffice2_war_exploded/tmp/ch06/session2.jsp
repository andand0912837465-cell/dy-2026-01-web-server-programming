<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ch06 - session2</title>
</head>
<body>
<jsp:include page="link.jsp"/>
<h1> session2.jsp </h1>

<div class="box">
    <%
        Object obj = application.getAttribute("member");
        MemberDto member = (MemberDto) obj;

        out.println("<p>application 객체</p>");
        out.println("<p>userId:" + member.getUserId() + "</p>");
        out.println("<p>userName:" + member.getUserName() + "</p>");
    %>
</div>
</body>
</html>
