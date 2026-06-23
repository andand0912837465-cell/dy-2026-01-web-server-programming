<%--
============================================================================
 학번 : 20251242
 이름 : 곽미란
 파일 : cart_20251242/addCart.jsp

 기능 : FR-01 장바구니 담기 처리 페이지.
        - 로그인 여부를 확인한다.
        - 상품번호(productId)와 수량(qty)을 전달받는다.
        - CartService를 이용하여 장바구니에 상품을 추가한다.
        - 동일 상품이 존재하면 수량을 누적한다.
        - 상품 정보 및 가격은 ProductCatalog 서버 데이터를 기준으로 처리한다.
        - 처리 완료 후 장바구니 화면(cart.jsp)으로 이동한다.

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

    // 사용자가 선택한 상품 수량을 받아 서버 장바구니에 저장하기 위한 처리
    int qty = 1;
    try { qty = Integer.parseInt(request.getParameter("qty")); }
    catch (Exception ignore) {}


    // 비정상적인 수량 입력 방지 (최소 1개 라고 함)
    if (qty < 1) {
        qty = 1;
    }

    // 과도한 주문 방지를 위한 최대 수량 제한
    if (qty > 20) {
        qty = 20;
    }



    // 3) 장바구니 담기 (상품 식별자가 있을 때만)
    if (productId != null && !productId.isBlank()) {
        CartService cartService = new CartService();

        // 동일 상품은 수량 누적, 신규 상품은 INSERT 처리함
        cartService.addItem(memberId, productId, qty);
    }

    // 4) 장바구니 화면으로 리다이렉트
    response.sendRedirect("cart.jsp");
%>
