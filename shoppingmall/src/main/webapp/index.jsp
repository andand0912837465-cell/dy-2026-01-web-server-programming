<%--
  20252361 김지연 - 메인 상품 검색, 카테고리/정렬, 찜/장바구니 연동
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    String contextPath = request.getContextPath();
    String fallbackImageUrl = contextPath + "/images/product-fallback.svg";

    // ===== 샘플 데이터 =====
    String[] categories = {"전체", "여성의류", "남성의류", "신발", "가방", "액세서리", "뷰티", "디지털"};

    // 샘플 이미지 베이스 (picsum.photos 시드 이미지)
    String IMG = "https://picsum.photos/seed/";

    // 배너 슬라이드 데이터 (제목, 부제, 그라데이션 색1, 그라데이션 색2, 이미지 시드)
    String[][] banners = {
            {"SUMMER SALE", "여름 시즌 최대 70% 할인", "#ff6b6b", "#feca57", "summer-sale"},
            {"NEW ARRIVAL", "2026 봄/여름 신상품 입고", "#4834d4", "#686de0", "new-arrival"},
            {"BEST ITEM", "이번 주 베스트 아이템", "#0abde3", "#48dbfb", "best-item"}
    };

    // 인기 상품 데이터 (이름, 브랜드, 원가, 할인가, 할인율, 평점, 리뷰수, 이미지 시드)
    Object[][] bestProducts = {
            {"오버사이즈 코튼 셔츠", "BASIC HOUSE", 59000, 39000, 33, 4.8, 1245, "shirt01"},
            {"슬림핏 데님 팬츠", "DENIM CO.", 89000, 62300, 30, 4.6, 892, "denim02"},
            {"미니멀 크로스백", "MUJI STYLE", 120000, 84000, 30, 4.9, 2134, "bag03"},
            {"러닝 스니커즈", "ATHLEISURE", 159000, 119000, 25, 4.7, 567, "shoes04"},
            {"실크 블라우스", "ELEGANT", 98000, 68600, 30, 4.5, 423, "blouse05"},
            {"가죽 토트백", "LEATHER LAB", 280000, 196000, 30, 4.9, 1876, "tote06"},
            {"캐주얼 자켓", "URBAN STREET", 145000, 101500, 30, 4.4, 312, "jacket07"},
            {"실버 목걸이", "AURUM", 75000, 56250, 25, 4.8, 945, "necklace08"}
    };

    // 신상품 데이터 (이름, 브랜드, 가격, 이미지 시드, 라벨)
    Object[][] newProducts = {
            {"린넨 원피스", "SUMMER LINE", 78000, "dress11", "NEW"},
            {"체크 셔츠", "CASUAL DAY", 56000, "check12", "NEW"},
            {"캔버스 스니커즈", "DAILY WALK", 89000, "canvas13", "HOT"},
            {"버킷햇", "STREET MODE", 35000, "hat14", "NEW"}
    };

    // 카테고리 아이콘 (라벨, 한글명, 이미지 시드)
    String[][] categoryIcons = {
            {"WOMEN", "여성패션", "cat-women"},
            {"MEN", "남성패션", "cat-men"},
            {"SHOES", "신발", "cat-shoes"},
            {"BAG", "가방", "cat-bag"},
            {"ACC", "액세서리", "cat-acc"},
            {"BEAUTY", "뷰티", "cat-beauty"},
            {"DIGITAL", "디지털", "cat-digital"},
            {"SPORTS", "스포츠", "cat-sports"}
    };
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SHOP MALL - 당신의 라이프 스타일</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
</head>
<body data-context-path="<%= contextPath %>">

<!-- 상단 유틸 -->
<div class="top-bar">
    <div class="container">
        <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
        <div>
            <% if (SessionUtils.isLoginYn(session)) {%>
                <a href="<%= contextPath %>/auth/logout.jsp">로그아웃</a>
                <a href="#">회원정보</a>
            <% } else {%>
                <a href="<%= contextPath %>/auth/login.jsp">로그인</a>
                <a href="<%= contextPath %>/member/register.jsp">회원가입</a>
            <% } %>
            <a href="<%= contextPath %>/board/list.jsp">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

<!-- 헤더 -->
<!-- 20252358최윤서
상담 헤더의 찜 버튼 영역과 상품 리스트의 데이터ID 속성
찜 페이지로 이동할 수 있도록 <a href="wishlist.jsp"> 링크를 연결하고 개수를 표시할 배지(<span id="wishlistBadge">) 추가
상품 카드의 고유 식별자인 data-id를 "best-" + i 형태로 만들어 자바스크립트가 정확한 상품을 구별할 수 있는 기준을 세움-->
<header>
    <div class="container header-inner">
        <a href="<%= contextPath %>/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="어떤 상품을 찾고 계신가요?">
            <button aria-label="검색">Q</button>
        </div>
        <div class="header-icons">
            <a href="<%= contextPath %>/wishlist.jsp" class="icon-btn">
                <div class="icon">♥</div>찜
                <span id="wishlistBadge"
                      class="badge wishlist-badge"
                      hidden>0</span>
            </a>
            <a href="<%= contextPath %>/cart/cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니
                <span id="cartBadge" class="badge cart-badge" hidden>0</span>
            </a>
            <div class="icon-btn"><div class="icon">i</div>My</div>
        </div>
    </div>
</header>

<!-- 카테고리 네비게이션 -->
<nav>
    <div class="container">
        <ul>
            <% for (int i = 0; i < categories.length; i++) { %>
                <li class="<%= i == 0 ? "active" : "" %>"><a href="#"><%= categories[i] %></a></li>
            <% } %>
        </ul>
    </div>
</nav>

<!-- 메인 콘텐츠 -->
<div class="container">

    <!-- 메인 배너 -->
    <div class="hero">
        <div class="hero-main" style="--bg: url('<%= IMG %><%= banners[0][4] %>/1200/600');">
            <span class="tag">★ HOT DEAL</span>
            <h1><%= banners[0][0] %></h1>
            <p><%= banners[0][1] %></p>
            <a href="#" class="btn">지금 쇼핑하기 →</a>
        </div>
        <div class="hero-side">
            <div class="hero-card purple" style="--bg: url('<%= IMG %><%= banners[1][4] %>/600/300');">
                <span class="tag"><%= banners[1][0] %></span>
                <h3><%= banners[1][1] %></h3>
            </div>
            <div class="hero-card cyan" style="--bg: url('<%= IMG %><%= banners[2][4] %>/600/300');">
                <span class="tag"><%= banners[2][0] %></span>
                <h3><%= banners[2][1] %></h3>
            </div>
        </div>
    </div>

    <!-- 카테고리 -->
    <section>
        <div class="section-head">
            <div>
                <h2>카테고리</h2>
                <div class="sub">관심있는 카테고리를 선택해 보세요</div>
            </div>
        </div>
        <div class="category-grid">
            <% for (String[] cat : categoryIcons) { %>
                <div class="cat-item" role="button" tabindex="0" data-category-name="<%= cat[1] %>">
                    <div class="cat-circle">
                        <img src="<%= IMG %><%= cat[2] %>/200/200" alt="<%= cat[1] %>">
                        <div class="cat-label"><%= cat[0] %></div>
                    </div>
                    <span><%= cat[1] %></span>
                </div>
            <% } %>
        </div>
    </section>

    <!-- 베스트 상품 -->
    <section>
        <div class="section-head">
            <div>
                <h2>BEST 상품</h2>
                <div class="sub">지금 가장 인기있는 상품을 만나보세요</div>
            </div>
            <div class="product-toolbar">
                <label for="productSort" class="sr-only">상품 정렬</label>
                <select id="productSort" class="product-sort">
                    <option value="default">기본순</option>
                    <option value="price-low">가격 낮은순</option>
                    <option value="price-high">가격 높은순</option>
                    <option value="rate-high">평점 높은순</option>
                </select>
                <a href="#">전체보기 →</a>
            </div>
        </div>
        <div id="productEmptyMessage" class="product-empty" hidden>검색 결과가 없습니다</div>
        <div class="product-grid">
            <% for (int i = 0; i < bestProducts.length; i++) {
                Object[] p = bestProducts[i];
                String productId = "best-" + i;
                String productName = (String) p[0];
                String productBrand = (String) p[1];
                int productPrice = (Integer) p[3];
                double productRate = (Double) p[5];
                String productImage = IMG + p[7] + "/400/400";
                String productCategory = "의류";

                if (productName.contains("스니커즈")) {
                    productCategory = "신발";
                } else if (productName.contains("백")) {
                    productCategory = "가방";
                } else if (productName.contains("목걸이")) {
                    productCategory = "액세서리";
                }

                String detailUrl = contextPath + "/product/detail.jsp?id=" + productId;
            %>
                <div class="product-card"
                     data-id="<%= productId %>"
                     data-name="<%= productName %>"
                     data-brand="<%= productBrand %>"
                     data-category="<%= productCategory %>"
                     data-price="<%= productPrice %>"
                     data-rate="<%= productRate %>"
                    data-image="<%= productImage %>">
                    <div class="product-img">
                        <a href="<%= detailUrl %>" aria-label="<%= productName %> 상세보기">
                            <img src="<%= productImage %>" alt="<%= productName %>"
                                 onerror="this.onerror=null; this.src='<%= fallbackImageUrl %>'; this.closest('.product-card').dataset.image='<%= fallbackImageUrl %>';">
                        </a>
                        <% if (i < 3) { %>
                            <span class="product-tag hot">BEST <%= i+1 %></span>
                        <% } else { %>
                            <span class="product-tag">SALE</span>
                        <% } %>
                        <button class="like-btn" aria-label="찜">♡</button>
                    </div>
                    <div class="product-info">
                        <div class="product-brand"><%= p[1] %></div>
                        <div class="product-name"><a href="<%= detailUrl %>"><%= p[0] %></a></div>
                        <div class="product-price">
                            <span class="discount"><%= p[4] %>%</span>
                            <span class="price"><%= String.format("%,d", (Integer)p[3]) %>원</span>
                            <span class="original"><%= String.format("%,d", (Integer)p[2]) %>원</span>
                        </div>
                        <div class="product-rate">
                            <span class="star">★</span> <%= p[5] %> · 리뷰 <%= String.format("%,d", (Integer)p[6]) %>
                        </div>
                        <button type="button" class="add-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- 타임 세일 프로모션 -->
    <section>
        <div class="promo">
            <div>
                <h2>⏰ TIME SALE</h2>
                <p>오늘 자정까지! 추가 20% 쿠폰 다운로드</p>
                <a href="#" class="btn">쿠폰 받기</a>
            </div>
            <div class="timer">
                <div class="timer-box">
                    <div class="num">08</div>
                    <div class="label">HOURS</div>
                </div>
                <div class="timer-box">
                    <div class="num">42</div>
                    <div class="label">MINUTES</div>
                </div>
                <div class="timer-box">
                    <div class="num">15</div>
                    <div class="label">SECONDS</div>
                </div>
            </div>
        </div>
    </section>

    <!-- 신상품 -->
    <section>
        <div class="section-head">
            <div>
                <h2>NEW 신상품</h2>
                <div class="sub">새롭게 입고된 따끈따끈한 신상품</div>
            </div>
            <a href="#">전체보기 →</a>
        </div>
        <div class="product-grid">
            <% for (int i = 0; i < newProducts.length; i++) {
                Object[] p = newProducts[i];
                String productId = "new-" + i;
                String productName = (String) p[0];
                String productBrand = (String) p[1];
                int productPrice = (Integer) p[2];
                double productRate = 0;
                String productImage = IMG + p[3] + "/400/400";
                String productCategory = "의류";

                if (productName.contains("스니커즈")) {
                    productCategory = "신발";
                } else if (productName.contains("버킷햇")) {
                    productCategory = "액세서리";
                }

                String detailUrl = contextPath + "/product/detail.jsp?id=" + productId;
            %>
                <div class="product-card"
                     data-id="<%= productId %>"
                     data-name="<%= productName %>"
                     data-brand="<%= productBrand %>"
                     data-category="<%= productCategory %>"
                     data-price="<%= productPrice %>"
                     data-rate="<%= productRate %>"
                    data-image="<%= productImage %>">
                    <div class="product-img">
                        <a href="<%= detailUrl %>" aria-label="<%= productName %> 상세보기">
                            <img src="<%= productImage %>" alt="<%= productName %>"
                                 onerror="this.onerror=null; this.src='<%= fallbackImageUrl %>'; this.closest('.product-card').dataset.image='<%= fallbackImageUrl %>';">
                        </a>
                        <span class="product-tag <%= "HOT".equals(p[4]) ? "hot" : "" %>"><%= p[4] %></span>
                        <button type="button" class="like-btn">♡</button>
                    </div>
                    <div class="product-info">
                        <div class="product-brand"><%= p[1] %></div>
                        <div class="product-name"><a href="<%= detailUrl %>"><%= p[0] %></a></div>
                        <div class="product-price">
                            <span class="price"><%= String.format("%,d", (Integer)p[2]) %>원</span>
                        </div>
                        <button type="button" class="add-cart-btn">장바구니 담기</button>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

</div>

<!-- 푸터 -->
<footer>
    <div class="container">
        <div class="footer-grid">
            <div>
                <h4>SHOPMALL</h4>
                <p>당신의 라이프 스타일을 완성하는 쇼핑몰<br>
                고객님의 만족이 저희의 행복입니다.</p>
                <p class="footer-contact">
                    고객센터: 1588-0000<br>
                    평일 09:00 ~ 18:00 (주말/공휴일 휴무)
                </p>
            </div>
            <div>
                <h4>SHOP</h4>
                <ul>
                    <li>전체 상품</li>
                    <li>신상품</li>
                    <li>베스트</li>
                    <li>세일</li>
                </ul>
            </div>
            <div>
                <h4>MY ACCOUNT</h4>
                <ul>
                    <li>마이페이지</li>
                    <li>주문조회</li>
                    <li>장바구니</li>
                    <li>위시리스트</li>
                </ul>
            </div>
            <div>
                <h4>HELP</h4>
                <ul>
                    <li>공지사항</li>
                    <li>자주묻는 질문</li>
                    <li>1:1 문의</li>
                    <li>이용약관</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            © 2026 SHOPMALL. All rights reserved.
        </div>
    </div>
</footer>

<script src="<%= contextPath %>/js/shop.js"></script>
</body>
</html>
