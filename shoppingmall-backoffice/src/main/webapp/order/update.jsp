<%--
  20252377 양효재
  부분 구현된 취소 환불 처리 흐름이 남아 있어서 개선 진행하였다.
  주문 상세 화면에서 넘어온 상태 변경 요청을 받아서,
  주문 상태를 실제로 저장하고 다시 주문 상세로 돌아가게 정리했다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.order.OrderService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    request.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
        return;
    }

    String orderIdValue = request.getParameter("orderId");
    String status = request.getParameter("status");
    String returnUrl = request.getParameter("returnUrl");

    Long orderId = null;
    try {
        orderId = Long.parseLong(orderIdValue);
    } catch (Exception ignore) {
    }

    if (returnUrl == null || returnUrl.isBlank()) {
        returnUrl = contextPath + "/order/list.jsp";
        if (orderId != null) {
            returnUrl = contextPath + "/order/view.jsp?orderId=" + orderId;
        }
    }

    if (orderId != null && status != null && !status.isBlank()) {
        OrderService service = new OrderService();
        service.changeStatus(orderId, status);
    }

    response.sendRedirect(returnUrl);
%>
