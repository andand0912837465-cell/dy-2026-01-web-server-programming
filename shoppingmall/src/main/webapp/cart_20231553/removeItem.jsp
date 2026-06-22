<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/removeItem.jsp
 기능 : FR-04 장바구니 상품 개별 삭제 처리 페이지.
        - 로그인 여부를 확인하고(미로그인 시 로그인 페이지로 유도, NFR-03)
        - 전송된 파라미터(cartItemId)를 받아
        - CartService.removeItem() 으로 해당 상품을 삭제한 뒤
        - 장바구니 화면(cart.jsp)으로 리다이렉트한다.
============================================================================
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.cart.CartService" %>
<%
    request.setCharacterEncoding("utf-8");
    String contextPath = request.getContextPath();

    // 1) 로그인 확인
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/login.jsp");
        return;
    }

    // 2) 파라미터 수신
    long cartItemId = -1;
    try {
        cartItemId = Long.parseLong(request.getParameter("cartItemId"));
    } catch (Exception ignore) {}

    // 3) 개별 삭제 (유효한 cartItemId 일 때만)
    if (cartItemId > 0) {
        CartService cartService = new CartService();
        cartService.removeItem(cartItemId);
    }

    // 4) 장바구니 화면으로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
