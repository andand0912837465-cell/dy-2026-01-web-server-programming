<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.product.ProductService" %>
<%@ page import="kr.ac.dy.cs.product.ProductDto" %>
<%@ page import="kr.ac.dy.cs.visitor.VisitorService" %>
<%
    String IMG = "https://picsum.photos/seed/";

    String productId = request.getParameter("id");

    ProductDto product = new ProductService().getProduct(productId);

    // ===== 방문 기록 (로그인 회원이 상세 페이지에 진입한 경우에만 VISITOR 적재) =====
    if (product != null && SessionUtils.isLoginYn(session)) {
        String loginId = (String) session.getAttribute("loginId");
        new VisitorService().recordVisit(product.getId(), loginId);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= product != null ? product.getName() : "상품을 찾을 수 없습니다" %> - SHOPMALL</title>
    <link rel="stylesheet" href="/css/main.css">
    <style>
        .detail-wrap { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin: 32px 0 60px; }
        .detail-img { width: 100%; border-radius: 12px; overflow: hidden; background: #f3f4f6; }
        .detail-img img { width: 100%; display: block; aspect-ratio: 1/1; object-fit: cover; }
        .detail-info .detail-brand { color: #6b7280; font-size: 14px; letter-spacing: .5px; margin-bottom: 8px; }
        .detail-info .detail-name { font-size: 26px; font-weight: 700; margin: 0 0 20px; line-height: 1.35; }
        .detail-price-row { display: flex; align-items: baseline; gap: 10px; margin-bottom: 6px; }
        .detail-price-row .discount { color: #ef4444; font-size: 24px; font-weight: 800; }
        .detail-price-row .price { font-size: 28px; font-weight: 800; }
        .detail-original { color: #9ca3af; text-decoration: line-through; font-size: 16px; margin-bottom: 24px; }
        .detail-meta { border-top: 1px solid #eee; border-bottom: 1px solid #eee; padding: 18px 0; margin: 24px 0; }
        .detail-meta-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px; color: #4b5563; }
        .detail-qty { display: flex; align-items: center; gap: 12px; margin: 20px 0; }
        .detail-qty button { width: 36px; height: 36px; border: 1px solid #d1d5db; background: #fff; font-size: 18px; cursor: pointer; border-radius: 6px; }
        .detail-qty input { width: 56px; height: 36px; text-align: center; border: 1px solid #d1d5db; border-radius: 6px; font-size: 15px; }
        .detail-actions { display: flex; gap: 12px; margin-top: 12px; }
        .detail-actions .btn { flex: 1; text-align: center; padding: 16px 0; font-size: 16px; border-radius: 8px; cursor: pointer; border: none; }
        .btn-cart { background: #fff; color: #111; border: 1px solid #111 !important; }
        .btn-buy { background: #111; color: #fff; }
        .detail-back { display: inline-block; margin: 24px 0 0; color: #6b7280; text-decoration: none; font-size: 14px; }
        .detail-notfound { text-align: center; padding: 80px 0; }
        @media (max-width: 768px){ .detail-wrap { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<!-- 상단 유틸 -->
<div class="top-bar">
    <div class="container">
        <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
        <div>
            <% if (SessionUtils.isLoginYn(session)) {%>
                <a href="/auth/logout.jsp">로그아웃</a>
                <a href="#">회원정보</a>
            <% } else {%>
                <a href="/auth/login.jsp">로그인</a>
                <a href="/member/register.jsp">회원가입</a>
            <% } %>
            <a href="#">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

<!-- 헤더 -->
<header>
    <div class="container header-inner">
        <a href="/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="메인 페이지에서 상품을 검색해 보세요" disabled>
            <button type="button" aria-label="검색" disabled>Q</button>
        </div>
        <div class="header-icons">
            <a href="/cart/cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니
                <span id="cartBadge" class="badge cart-badge" hidden>0</span>
            </a>
        </div>
    </div>
</header>

<div class="container">
<% if (product == null) { %>
    <div class="detail-notfound">
        <h2>상품을 찾을 수 없습니다.</h2>
        <p style="color:#6b7280; margin-top:8px;">존재하지 않거나 삭제된 상품입니다.</p>
        <a href="/index.jsp" class="btn" style="display:inline-block; margin-top:20px; background:#111; color:#fff; padding:12px 24px; border-radius:8px; text-decoration:none;">메인으로 돌아가기</a>
    </div>
<% } else {
    String image = IMG + product.getImage() + "/700/700";
%>
    <div class="detail-wrap"
         id="detailProduct"
         data-id="<%= product.getId() %>"
         data-name="<%= product.getName() %>"
         data-brand="<%= product.getBrand() %>"
         data-price="<%= product.getSalePrice() %>"
         data-image="<%= image %>">
        <div class="detail-img">
            <img src="<%= image %>" alt="<%= product.getName() %>">
        </div>
        <div class="detail-info">
            <div class="detail-brand"><%= product.getBrand() %></div>
            <h1 class="detail-name"><%= product.getName() %></h1>

            <div class="detail-price-row">
                <% if (product.getDiscountRate() > 0) { %>
                    <span class="discount"><%= product.getDiscountRate() %>%</span>
                <% } %>
                <span class="price"><%= String.format("%,d", product.getSalePrice()) %>원</span>
            </div>
            <% if (product.getDiscountRate() > 0) { %>
                <div class="detail-original"><%= String.format("%,d", product.getPrice()) %>원</div>
            <% } %>

            <div class="detail-meta">
                <div class="detail-meta-row"><span>배송</span><strong>무료배송 (5만원 이상)</strong></div>
                <div class="detail-meta-row"><span>적립</span><strong><%= String.format("%,d", Math.round(product.getSalePrice() * 0.01)) %>원 (1%)</strong></div>
                <div class="detail-meta-row"><span>브랜드</span><strong><%= product.getBrand() %></strong></div>
            </div>

            <div class="detail-qty">
                <span style="font-size:14px; color:#4b5563;">수량</span>
                <button type="button" id="qtyMinus" aria-label="수량 감소">−</button>
                <input type="text" id="qtyInput" value="1" inputmode="numeric" aria-label="수량">
                <button type="button" id="qtyPlus" aria-label="수량 증가">+</button>
            </div>

            <div class="detail-actions">
                <button type="button" class="btn btn-cart" id="addCartBtn">장바구니 담기</button>
                <button type="button" class="btn btn-buy" id="buyNowBtn">바로 구매</button>
            </div>

            <a href="/index.jsp" class="detail-back">← 쇼핑 계속하기</a>
        </div>
    </div>
<% } %>
</div>

<footer>
    <div class="container">
        <div class="footer-bottom">© 2026 SHOPMALL. All rights reserved.</div>
    </div>
</footer>

<script>
    (function () {
        var CART_STORAGE_KEY = 'shopmallCart';
        var root = document.querySelector('#detailProduct');
        var cartBadge = document.querySelector('#cartBadge');

        function readCartItems() {
            try {
                var parsed = JSON.parse(localStorage.getItem(CART_STORAGE_KEY));
                return Array.isArray(parsed) ? parsed : [];
            } catch (e) {
                return [];
            }
        }

        function saveCartItems(items) {
            try { localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(items)); } catch (e) {}
        }

        function updateCartBadge() {
            if (!cartBadge) { return; }
            var total = readCartItems().reduce(function (sum, item) {
                var q = Number(item.quantity);
                return sum + (Number.isFinite(q) ? q : 0);
            }, 0);
            cartBadge.textContent = String(total);
            cartBadge.hidden = total === 0;
        }

        updateCartBadge();

        if (!root) { return; }

        var qtyInput = document.querySelector('#qtyInput');

        function getQty() {
            var q = parseInt(qtyInput.value, 10);
            return Number.isFinite(q) && q > 0 ? q : 1;
        }
        function setQty(q) { qtyInput.value = String(Math.max(1, q)); }

        document.querySelector('#qtyMinus').addEventListener('click', function () { setQty(getQty() - 1); });
        document.querySelector('#qtyPlus').addEventListener('click', function () { setQty(getQty() + 1); });
        qtyInput.addEventListener('input', function () {
            qtyInput.value = qtyInput.value.replace(/[^0-9]/g, '');
        });
        qtyInput.addEventListener('blur', function () { setQty(getQty()); });

        function addToCart() {
            var quantity = getQty();
            var price = Number(root.dataset.price);
            var items = readCartItems();
            var existing = items.find(function (item) { return item && item.id === root.dataset.id; });

            if (existing) {
                existing.quantity = (Number(existing.quantity) || 0) + quantity;
            } else {
                items.push({
                    id: root.dataset.id,
                    name: root.dataset.name,
                    brand: root.dataset.brand,
                    price: Number.isFinite(price) ? Math.max(0, price) : 0,
                    image: root.dataset.image,
                    quantity: quantity
                });
            }

            saveCartItems(items);
            updateCartBadge();
        }

        document.querySelector('#addCartBtn').addEventListener('click', function () {
            addToCart();
            alert(root.dataset.name + ' 상품을 장바구니에 담았습니다.');
        });

        document.querySelector('#buyNowBtn').addEventListener('click', function () {
            addToCart();
            location.href = '/cart/cart.jsp';
        });
    })();
</script>
</body>
</html>
