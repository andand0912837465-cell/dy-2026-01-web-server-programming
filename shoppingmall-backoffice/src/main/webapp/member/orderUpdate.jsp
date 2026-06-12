<%@ page import="kr.ac.dy.cs.order.*" %>
<!-- 주문 탭에서 넣은 값을 입력해주는 코드 -->

<%
    Long orderId =
            Long.parseLong(
                    request.getParameter("orderId"));

    String status =
            request.getParameter("status");

    OrderService service =
            new OrderService();

    service.changeStatus(
            orderId,
            status);

    response.sendRedirect(request.getHeader("Referer"));
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>
