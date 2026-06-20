<%@ page import="kr.ac.dy.cs.order.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    String orderIdValue = request.getParameter("orderId");
    String status = request.getParameter("status");

    if (orderIdValue == null || orderIdValue.isBlank() || status == null || status.isBlank()) {
        response.sendRedirect("/member/list.jsp");
        return;
    }

    Long orderId = Long.parseLong(orderIdValue);
    OrderService service = new OrderService();
    service.changeStatus(orderId, status);

    String referer = request.getHeader("Referer");
    response.sendRedirect(referer != null && !referer.isBlank() ? referer : "/member/list.jsp");
%>
