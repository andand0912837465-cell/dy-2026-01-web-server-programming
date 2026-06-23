<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/shop.jsp
 기능 : 'DB 기반 장바구니' 기능의 상품 목록(진입) 화면.
        - 팀원이 작성한 공유 index.jsp 를 수정하지 않기 위해, 본 기능 전용 상품 목록을
          별도 페이지로 제공한다. (다른 사람 코드 보존)
        - 상품은 팀의 ProductCatalog(서버 상품 목록)를 그대로 재사용하여 렌더링한다.
        - '장바구니 담기' 클릭 시 addCart.jsp 로 POST 전송하여 서버 DB 장바구니에 담는다.
        - 헤더 배지에는 서버 DB 기준 총 담은 수량을 표시한다. (FR-06)
============================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.order.ProductCatalog" %>
<%@ page import="kr.ac.dy.cs.cart.CartService" %>
<%
    String contextPath = request.getContextPath();

    // 상품 목록(서버 카탈로그 재사용)
    List<ProductCatalog.Product> products = ProductCatalog.findAll();

    // FR-06 : 헤더 배지용 총 수량(로그인 회원의 DB 장바구니 기준)
    int cartBadgeCount = 0;
    if (SessionUtils.isLoginYn(session)) {
        String loginId = (String) session.getAttribute("loginId");
        CartService cartService = new CartService();
        cartBadgeCount = cartService.getTotalQuantity(cartService.getItems(loginId));
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 목록 (DB 장바구니) - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
</head>
<body>

<!-- 상단 유틸 -->
<div class="top-bar">
    <div class="container">
        <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
        <div>
            <% if (SessionUtils.isLoginYn(session)) { %>
                <a href="<%= contextPath %>/auth/logout.jsp">로그아웃</a>
                <a href="#">회원정보</a>
            <% } else { %>
                <a href="<%= contextPath %>/auth/login.jsp">로그인</a>
                <a href="<%= contextPath %>/member/register.jsp">회원가입</a>
            <% } %>
            <a href="#">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

<!-- 헤더 -->
<header>
    <div class="container header-inner">
        <a href="<%= contextPath %>/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="DB 장바구니 데모 상품 목록입니다" disabled>
            <button type="button" aria-label="검색" disabled>Q</button>
        </div>
        <div class="header-icons">
            <a href="cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니(DB)
                <span id="cartBadge" class="badge cart-badge" <%= cartBadgeCount == 0 ? "hidden" : "" %>><%= cartBadgeCount %></span>
            </a>
        </div>
    </div>
</header>

<main class="container">
    <section>
        <div class="section-head">
            <div>
                <h2>상품 목록 (서버 DB 장바구니)</h2>
                <div class="sub">담기를 누르면 서버 데이터베이스에 저장됩니다.</div>
            </div>
            <a href="cart.jsp" class="btn-secondary">장바구니 보기 →</a>
        </div>

        <div class="product-grid">
            <% for (ProductCatalog.Product p : products) { %>
                <div class="product-card">
                    <div class="product-img">
                        <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>">
                        <span class="product-tag <%= p.isBestProduct() ? "hot" : "" %>"><%= p.getLabel() %></span>
                    </div>
                    <div class="product-info">
                        <div class="product-brand"><%= p.getBrand() %></div>
                        <div class="product-name"><%= p.getName() %></div>
                        <div class="product-price">
                            <% if (p.getDiscountRate() > 0) { %>
                                <span class="discount"><%= p.getDiscountRate() %>%</span>
                            <% } %>
                            <span class="price"><%= String.format("%,d", p.getSalePrice()) %>원</span>
                        </div>

                        <%-- FR-01 : 장바구니 담기 → 서버(addCart.jsp)로 POST 전송 --%>
                        <form action="addCart.jsp" method="post" style="margin:0">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <input type="hidden" name="qty" value="1">
                            <button type="submit" class="add-cart-btn">장바구니 담기</button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </section>
</main>

</body>
</html>
