<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title> 구구단출력 </title>
</head>
<body>
    <h1>구구단 출력</h1>

    <%
        int dan = 0;
        try {
            dan = Integer.valueOf(request.getParameter("dan"));
        } catch (Exception e) {
            out.println("<p>입력값이 정확하지 않습니다.</p>");
        }
    %>

    <h2><%=dan%>단 </h2>

        <%
            if (dan > 0) {
                StringBuilder sb = new StringBuilder();

                for (int i = 1; i <= 9; i++) {
                    sb.append("<p>%d * %d = %d</p>".formatted(dan, i, (i * dan)));
                    //out.println("<p>3 * " + i + " = " + (i * 3) + "</p>");
                    //out.println("<p>%d * %d = %d</p>".formatted(dan, i, (i * dan)));
                }

                out.println(sb.toString());
            }
        %>



</body>
</html>
