<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ch06 - page2</title>
</head>
<body>
        <h1> page2.jsp </h1>
        <div class="box">
            <%
                Object obj = application.getAttribute("member");
                if (obj != null) {
                    MemberDto member = (MemberDto) obj;

                    out.println("<p>application 객체</p>");
                    out.println("<p>userId:" + member.getUserId() + "</p>");
                    out.println("<p>userName:" + member.getUserName() + "</p>");
                }
            %>
        </div>
</body>
</html>