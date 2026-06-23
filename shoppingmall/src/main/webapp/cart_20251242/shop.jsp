<%--
============================================================================
 학번 : 20251242
 이름 : 곽미란
 파일 : cart_20251242/shop.jsp

 기능 : 장바구니 기능 테스트용 상품 목록 화면.
        - ProductCatalog의 상품 정보를 조회하여 출력한다.
        - 사용자가 상품 수량을 선택할 수 있다.
        - 장바구니 담기 버튼 클릭 시 addCart.jsp로 상품 정보를 전송한다.
        - 로그인 회원의 장바구니 총 수량을 헤더 배지에 표시한다.
        - 서버 DB 기반 장바구니 기능 동작을 확인하기 위한 화면이다.

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
    String loginId = "";

    int cartBadgeCount = 0;
    if (SessionUtils.isLoginYn(session)) {
        loginId = (String) session.getAttribute("loginId");

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
                <!-- 로그인 사용자의 데이터베이스 장바구니 총 수량 표시 -->
                <span id="cartBadge" class="badge cart-badge" <%= cartBadgeCount == 0 ? "hidden" : "" %>><%= cartBadgeCount %></span>
            </a>
        </div>
    </div>
</header>

<main class="container">
    <section>
        <div class="section-head">
            <div>
                <h2>상품 목록 (장바구니)</h2>

                <p>현재 등록 상품 : <%= products.size() %>개</p>

                <% if(SessionUtils.isLoginYn(session)){ %>
                <p><strong><%= loginId %></strong>님 장바구니 쇼핑 중</p>
                <% } %>

                <div class="sub">담기를 누르면 서버 데이터베이스에 저장됩니다.</div>
            </div>
            <a href="cart.jsp" class="btn-secondary">장바구니 보기 →</a>
        </div>

        <div class="product-grid">
            <!-- 서버 상품 카탈로그의 상품 목록을 반복 출력 -->
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


                    <form action="addCart.jsp" method="post" style="margin:0">
                        <input type="hidden" name="productId" value="<%= p.getId() %>">
                        <!-- <input type="hidden" name="qty" value="1"> -->
                        <!-- 사용자가 장바구니에 담을 수량을 직접 선택하는 옵션 -->
                        <select name="qty">
                            <option value="1">1개</option>
                            <option value="2">2개</option>
                            <option value="3">3개</option>
                            <option value="4">4개</option>
                            <option value="5">5개</option>
                            <option value="1">6개</option>
                            <option value="2">7개</option>
                            <option value="3">8개</option>
                            <option value="4">9개</option>
                            <option value="5">10개</option>
                            <option value="1">11개</option>
                            <option value="2">12개</option>
                            <option value="3">13개</option>
                            <option value="4">14개</option>
                            <option value="5">15개</option>
                            <option value="1">16개</option>
                            <option value="2">17개</option>
                            <option value="3">18개</option>
                            <option value="4">19개</option>
                            <option value="5">20개</option>


                        </select>
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
