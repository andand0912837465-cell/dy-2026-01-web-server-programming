<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.tmp.MemberPointDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ch06 - request1</title>
</head>
<body>
<jsp:include page="link.jsp"/>
        <h1> request1.jsp </h1>
<div class="box">
    <%
        Object obj = application.getAttribute("member");
        if (obj !=  null) {
            MemberDto member = (MemberDto) obj;

            out.println("<p>application 객체</p>");
            out.println("<p>userId:" + member.getUserId() + "</p>");
            out.println("<p>userName:" + member.getUserName() + "</p>");
        }
    %>
</div>
<div class="session-box">
    <%
        Object sessionObj = session.getAttribute("member");
        if (sessionObj != null) {
            MemberDto sessionMember = (MemberDto) sessionObj;

            out.println("<p>session 객체</p>");
            out.println("<p>userId:" + sessionMember.getUserId() + "</p>");
            out.println("<p>userName:" + sessionMember.getUserName() + "</p>");
        }
    %>
</div>

</body>
</html>
