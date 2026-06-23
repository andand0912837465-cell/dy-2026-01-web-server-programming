<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/clearCart.jsp
 기능 : FR-05 장바구니 전체 비우기 처리 페이지.
        - 로그인 여부를 확인하고(미로그인 시 로그인 페이지로 유도, NFR-03)
        - 세션의 로그인 회원(loginId)을 기준으로
        - CartService.clear() 로 장바구니의 모든 상품을 삭제한 뒤
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
    String memberId = (String) session.getAttribute("loginId");

    // 2) 전체 비우기
    CartService cartService = new CartService();
    cartService.clear(memberId);

    // 3) 장바구니 화면으로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
