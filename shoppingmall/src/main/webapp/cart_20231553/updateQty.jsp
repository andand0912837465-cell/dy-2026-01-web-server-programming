<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/updateQty.jsp
 기능 : FR-03 장바구니 수량 변경 처리 페이지.
        - 로그인 여부를 확인하고(미로그인 시 로그인 페이지로 유도, NFR-03)
        - 전송된 파라미터(cartItemId, quantity)를 받아
        - CartService.changeQuantity() 로 수량을 갱신(최소 1 보장)한 뒤
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
    int  quantity   = 1;
    try {
        cartItemId = Long.parseLong(request.getParameter("cartItemId"));
        quantity   = Integer.parseInt(request.getParameter("quantity"));
    } catch (Exception ignore) {}

    // 3) 수량 변경 (유효한 cartItemId 일 때만)
    if (cartItemId > 0) {
        CartService cartService = new CartService();
        cartService.changeQuantity(cartItemId, quantity);
    }

    // 4) 장바구니 화면으로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
