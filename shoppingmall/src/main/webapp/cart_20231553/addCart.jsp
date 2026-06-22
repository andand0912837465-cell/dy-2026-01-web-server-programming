<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/addCart.jsp
 기능 : FR-01 장바구니 담기 처리 페이지.
        - 로그인 여부를 확인하고(미로그인 시 로그인 페이지로 유도, NFR-03)
        - 전송된 파라미터(productId, qty)를 받아
        - CartService.addItem() 으로 장바구니에 추가(상품정보·가격은 서버 ProductCatalog 신뢰,
          동일 상품이면 수량 누적)한 뒤
        - 장바구니 화면(cart.jsp)으로 리다이렉트한다.
============================================================================
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.cart.CartService" %>
<%
    request.setCharacterEncoding("utf-8");
    String contextPath = request.getContextPath();

    // 1) 로그인 확인 (미로그인 → 로그인 페이지)
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/login.jsp");
        return;
    }
    String memberId = (String) session.getAttribute("loginId");

    // 2) 파라미터 수신
    String productId = request.getParameter("productId");

    int qty = 1;
    try { qty = Integer.parseInt(request.getParameter("qty")); } catch (Exception ignore) {}
    if (qty < 1) { qty = 1; }

    // 3) 장바구니 담기 (상품 식별자가 있을 때만)
    if (productId != null && !productId.isBlank()) {
        CartService cartService = new CartService();
        cartService.addItem(memberId, productId, qty);
    }

    // 4) 장바구니 화면으로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
