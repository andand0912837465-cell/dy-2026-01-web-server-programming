<%--
    20252364 강한서

    장바구니 비우기를 처리하는 JSP 페이지이다.
    세션에 저장된 장바구니 정보를 삭제하여 장바구니를 초기화한다.
    session에 저장된 cart 값을 삭제한다.
    장바구니 비우기 처리 후 다시 장바구니 페이지로 이동한다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.removeAttribute("cart");
    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
%>
