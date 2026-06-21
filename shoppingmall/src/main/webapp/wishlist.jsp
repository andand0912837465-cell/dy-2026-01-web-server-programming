<%--
  20252361 김지연
  기능 설명: LocalStorage의 productId 기준 찜 목록을 BEST/NEW 상품 누락 없이 표시하는 화면
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.order.ProductCatalog" %>
<%@ page import="kr.ac.dy.cs.order.ProductCatalog.Product" %>
<%
    String contextPath = request.getContextPath();
%>
<!-- 20252358최윤서
찜 목록 구현
찜한 상품들을 모아서 볼 수 있는 화면+찜 목록에서 찜 해제 가능
찜한 상품이 없을 때 찜 목록 들어가면 찜한 상품이 없다고 안내
메인으로 가는 링크도 넣음 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>찜 목록 - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
    <style>
        /* 찜 목록에서는 무조건 하트가 채워진 빨간색 상태로 시작하도록 강제 설정 */
        .product-grid .like-btn.wish-page-active {
            background: #ff6b6b;
            color: #fff;
            box-shadow: 0 6px 14px rgba(255,107,107,0.28);
        }
    </style>
</head>
<body data-context-path="<%= contextPath %>">
<header>
    <div class="container header-inner">
        <a href="<%= contextPath %>/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="메인 페이지에서 상품을 검색해 보세요" disabled>
            <button type="button" aria-label="검색" disabled>Q</button>
        </div>
        <div class="header-icons">
            <a href="<%= contextPath %>/wishlist.jsp" class="icon-btn">
                <div class="icon">♥</div>찜
                <span id="wishlistBadge" class="badge wishlist-badge" hidden>0</span>
            </a>
            <a href="<%= contextPath %>/cart/cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니
                <span id="cartBadge" class="badge cart-badge" hidden>0</span>
            </a>
            <div class="icon-btn"><div class="icon">i</div>My</div>
        </div>
    </div>
</header>

<main class="container wishlist-page" style="margin-top: 48px;">
    <div class="cart-page-head">
        <div>
            <h1>찜 목록</h1>
            <p>찜한 상품을 확인하고 바로 장바구니에 담을 수 있습니다.</p>
        </div>
        <a href="<%= contextPath %>/index.jsp" class="btn-secondary">쇼핑 계속하기</a>
    </div>

    <div id="wishlistEmptyMessage" class="product-empty">찜한 상품이 없습니다.</div>

    <div class="product-grid wishlist-grid">
        <% for (Product product : ProductCatalog.findAll()) { %>
        <div class="product-card wishlist-product-card"
             data-id="<%= product.getId() %>"
             data-name="<%= product.getName() %>"
             data-brand="<%= product.getBrand() %>"
             data-category="<%= product.getCategory() %>"
             data-price="<%= product.getSalePrice() %>"
             data-rate="<%= product.getRating() %>"
             data-image="<%= product.getImageUrl() %>"
             hidden>
            <div class="product-img">
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                <span class="product-tag <%= product.getLabel().contains("HOT") || product.getLabel().contains("BEST") ? "hot" : "" %>"><%= product.getLabel() %></span>
                <button type="button" class="like-btn wish-page-active" aria-label="찜 해제">♥</button>
            </div>

            <div class="product-info">
                <div class="product-brand"><%= product.getBrand() %></div>
                <div class="product-name"><%= product.getName() %></div>
                <div class="product-price">
                    <% if (product.getDiscountRate() > 0) { %>
                    <span class="discount"><%= product.getDiscountRate() %>%</span>
                    <% } %>
                    <span class="price"><%= String.format("%,d", product.getSalePrice()) %>원</span>
                    <% if (product.getOriginalPrice() > product.getSalePrice()) { %>
                    <span class="original"><%= String.format("%,d", product.getOriginalPrice()) %>원</span>
                    <% } %>
                </div>
                <% if (product.getRating() > 0) { %>
                <div class="product-rate">
                    ★ <%= product.getRating() %> · 리뷰 <%= String.format("%,d", product.getReviewCount()) %>
                </div>
                <% } %>
                <button type="button" class="add-cart-btn">장바구니 담기</button>
            </div>
        </div>
        <% } %>
    </div>
</main>

<script src="<%= contextPath %>/js/shop.js"></script>
</body>
</html>
