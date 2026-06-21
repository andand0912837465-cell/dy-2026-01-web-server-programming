<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    // ===== 샘플 데이터 =====
    String[] categories = {"전체", "여성의류", "남성의류", "신발", "가방", "액세서리", "뷰티", "디지털"};

    // 샘플 이미지 베이스
    String IMG = "https://picsum.photos/seed/";

    // 배너 슬라이드 데이터
    String[][] banners = {
            {"SUMMER SALE", "여름 시즌 최대 70% 할인", "#ff6b6b", "#feca57", "summer-sale"},
            {"NEW ARRIVAL", "2026 봄/여름 신상품 입고", "#4834d4", "#686de0", "new-arrival"},
            {"BEST ITEM", "이번 주 베스트 아이템", "#0abde3", "#48dbfb", "best-item"}
    };

    // 인기 상품 데이터
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

    // 신상품 데이터
    Object[][] newProducts = {
            {"린넨 원피스", "SUMMER LINE", 78000, "dress11", "NEW"},
            {"체크 셔츠", "CASUAL DAY", 56000, "check12", "NEW"},
            {"캔버스 스니커즈", "DAILY WALK", 89000, "canvas13", "HOT"},
            {"버킷햇", "STREET MODE", 35000, "hat14", "NEW"}
    };

    // 카테고리 아이콘
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
</head>
<body>

<!-- 상단 유틸 -->
<div class="top-bar">
    <div class="container">
        <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
        <div>
            <% if (SessionUtils.isLoginYn(session)) { %>
            <a href="<%= request.getContextPath() %>/auth/logout.jsp">로그아웃</a>
            <a href="<%= request.getContextPath() %>/member/info.jsp">회원정보</a>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/auth/login.jsp">로그인</a>
            <a href="<%= request.getContextPath() %>/member/register.jsp">회원가입</a>
            <% } %>
            <a href="#">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

<!-- 헤더 -->
<header>
    <div class="container header-inner">
        <a href="<%= request.getContextPath() %>/index.jsp" class="logo">SHOP<span>MALL</span></a>

        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="어떤 상품을 찾고 계신가요?">
            <button aria-label="검색">Q</button>
        </div>

        <div class="header-icons">
            <div class="icon-btn">
                <div class="icon">♥</div>찜
                <span id="wishlistBadge" class="badge wishlist-badge" hidden>0</span>
            </div>

            <a href="<%= request.getContextPath() %>/cart/cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니
                <span id="cartBadge" class="badge cart-badge" hidden>0</span>
            </a>

            <div class="icon-btn">
                <div class="icon">i</div>My
            </div>
        </div>
    </div>
</header>

<!-- 카테고리 네비게이션 -->
<nav>
    <div class="container">
        <ul>
            <% for (int i = 0; i < categories.length; i++) { %>
            <li class="<%= i == 0 ? "active" : "" %>">
                <a href="#"><%= categories[i] %></a>
            </li>
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

            <!-- 제품 상세/리뷰 목록 페이지로 이동 -->
            <a href="<%= request.getContextPath() %>/product/list.jsp" class="btn">
                지금 쇼핑하기 →
            </a>
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

    <!-- 제품 상세/리뷰 페이지 바로가기 -->
    <div style="margin: 24px 0;">
        <a href="<%= request.getContextPath() %>/product/list.jsp"
           class="btn"
           style="display:inline-block; text-decoration:none;">
            제품 상세/리뷰 페이지 보기
        </a>
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
                <a href="<%= request.getContextPath() %>/product/list.jsp">전체보기 →</a>
            </div>
        </div>

        <div id="productEmptyMessage" class="product-empty" hidden>검색 결과가 없습니다</div>

        <div class="product-grid">
            <% for (int i = 0; i < bestProducts.length; i++) {
                Object[] p = bestProducts[i];

                // 화면용 상품 id
                String productId = "best-" + i;

                // DB 상세 페이지 연결용 id
                // product 테이블에 샘플 상품 4개만 넣었다면 1~4번만 상세 페이지와 정확히 연결됨
                int dbProductId = i + 1;

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
                    <img src="<%= productImage %>" alt="<%= productName %>">

                    <% if (i < 3) { %>
                    <span class="product-tag hot">BEST <%= i + 1 %></span>
                    <% } else { %>
                    <span class="product-tag">SALE</span>
                    <% } %>

                    <button class="like-btn" aria-label="찜">♡</button>
                </div>

                <div class="product-info">
                    <div class="product-brand"><%= p[1] %></div>
                    <div class="product-name"><%= p[0] %></div>

                    <div class="product-price">
                        <span class="discount"><%= p[4] %>%</span>
                        <span class="price"><%= String.format("%,d", (Integer)p[3]) %>원</span>
                        <span class="original"><%= String.format("%,d", (Integer)p[2]) %>원</span>
                    </div>

                    <div class="product-rate">
                        <span class="star">★</span>
                        <%= p[5] %> · 리뷰 <%= String.format("%,d", (Integer)p[6]) %>
                    </div>

                    <form action="<%= request.getContextPath() %>/cart/add.jsp" method="post" style="margin:0;">
                        <input type="hidden" name="id" value="<%= dbProductId %>">
                        <input type="hidden" name="name" value="<%= productName %>">
                        <input type="hidden" name="price" value="<%= productPrice %>">
                        <input type="hidden" name="image" value="<%= productImage %>">

                        <button type="submit" class="cart-real-btn">
                            장바구니 담기
                        </button>
                    </form>

                    <!-- 기능구현 계획서용: 상품 상세/리뷰 페이지 연결 -->
                    <a href="<%= request.getContextPath() %>/product/detail.jsp?id=<%= dbProductId %>"
                       class="detail-review-btn"
                       style="display:block; text-align:center; text-decoration:none; margin-top:8px; background:#2f3a3a; color:white; padding:13px; border-radius:8px; font-weight:700;">
                        상세보기 / 리뷰
                    </a>
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
                <a href="<%= request.getContextPath() %>/product/list.jsp" class="btn">쿠폰 받기</a>
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
            <a href="<%= request.getContextPath() %>/product/list.jsp">전체보기 →</a>
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
                    <img src="<%= productImage %>" alt="<%= productName %>">
                    <span class="product-tag <%= "HOT".equals(p[4]) ? "hot" : "" %>"><%= p[4] %></span>
                    <button class="like-btn" aria-label="찜">♡</button>
                </div>

                <div class="product-info">
                    <div class="product-brand"><%= p[1] %></div>
                    <div class="product-name"><%= p[0] %></div>

                    <div class="product-price">
                        <span class="price"><%= String.format("%,d", (Integer)p[2]) %>원</span>
                    </div>

                    이걸 아래 코드로 교체해.

                    <form action="<%= request.getContextPath() %>/cart/add.jsp" method="post" style="margin:0;">
                        <input type="hidden" name="id" value="<%= productId %>">
                        <input type="hidden" name="name" value="<%= productName %>">
                        <input type="hidden" name="price" value="<%= productPrice %>">
                        <input type="hidden" name="image" value="<%= productImage %>">

                        <button type="submit" class="cart-real-btn">
                            장바구니 담기
                        </button>
                    </form>

                    <!-- 신상품은 일단 제품 목록 페이지로 연결 -->
                    <a href="<%= request.getContextPath() %>/product/list.jsp"
                       class="detail-review-btn">
                        상세보기 / 리뷰
                    </a>
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
                <p>
                    당신의 라이프 스타일을 완성하는 쇼핑몰<br>
                    고객님의 만족이 저희의 행복입니다.
                </p>
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

<script src="<%= request.getContextPath() %>/js/shop.js"></script>
</body>
</html>