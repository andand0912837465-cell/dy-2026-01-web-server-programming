<%--
main
    20252364 강한서

    상품 상세 정보와 리뷰를 출력하는 JSP 페이지이다.
    URL 파라미터로 전달된 상품 번호를 이용하여 product 테이블에서 상품 정보를 조회하고,
    review 테이블에서 해당 상품의 리뷰 목록을 조회하여 화면에 출력한다.

    상품 번호(id)를 이용하여 상품 상세 정보를 조회한다.
    상품 이미지, 브랜드명, 상품명, 가격, 설명을 출력한다.
    로그인한 사용자에게 리뷰 작성 폼을 제공한다.
    해당 상품에 작성된 리뷰 목록을 출력한다.
    로그인한 사용자가 본인이 작성한 리뷰만 삭제할 수 있도록 삭제 버튼을 출력한다.
    *css는 Claude 사용
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="kr.ac.dy.cs.product.ProductDto"%>
<%@ page import="kr.ac.dy.cs.product.ProductDao"%>
<%@ page import="kr.ac.dy.cs.review.ReviewDto"%>
<%@ page import="kr.ac.dy.cs.review.ReviewDao"%>
<%@ page import="kr.ac.dy.cs.util.SessionUtils"%>
<%
    request.setCharacterEncoding("UTF-8");

    String idParam = request.getParameter("id");
    int productId = 0;

    try {
        productId = Integer.parseInt(idParam);
    } catch (Exception e) {
        productId = 0;
    }

    ProductDao productDao = new ProductDao();
    ReviewDao reviewDao = new ReviewDao();

    ProductDto product = productDao.findById(productId);
    List<ReviewDto> reviews = reviewDao.findByProductId(productId);

    boolean isLogin = SessionUtils.isLoginYn(session);
    String loginId = isLogin ? String.valueOf(session.getAttribute("loginId")) : null;
=======
  20252365 조준혁
  제품 상세 페이지를 보여주는 JSP 페이지.
  제품 정보는 PRODUCT_DETAIL 테이블에서 가져오고,
  리뷰 정보는 PRODUCT_REVIEW 테이블에서 가져온다.
  데이터베이스 생성 SQL은 init_product.sql에서 확인할 수 있다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    request.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
    String fallbackImageUrl = contextPath + "/images/product-fallback.svg";
    String productId = request.getParameter("id");

    if (productId == null || productId.trim().equals("")) {
        productId = "best-0";
    }
    productId = productId.trim();

    String loginId = "";
    if (SessionUtils.isLoginYn(session)) {
        loginId = (String) session.getAttribute("loginId");
    }

    String productName = "";
    String brand = "";
    String category = "";
    String imageUrl = "";
    String badge = "";
    String detailText = "";
    String deliveryText = "";
    int originalPrice = 0;
    int salePrice = 0;
    int discountRate = 0;
    int oldReviewCount = 0;
    double basicRate = 0.0;
    double showRate = 0.0;
    int newReviewCount = 0;
    boolean productOk = false;
    String errorMessage = "";

    ArrayList<HashMap<String, String>> reviewList = new ArrayList<>();

    H2DbConnector connector = new H2DbConnector();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = connector.getConnection();

        pstmt = conn.prepareStatement("SELECT * FROM PRODUCT_DETAIL WHERE PRODUCT_ID = ?");
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            productOk = true;
            productName = rs.getString("NAME");
            brand = rs.getString("BRAND");
            category = rs.getString("CATEGORY");
            originalPrice = rs.getInt("ORIGINAL_PRICE");
            salePrice = rs.getInt("SALE_PRICE");
            discountRate = rs.getInt("DISCOUNT_RATE");
            basicRate = rs.getDouble("BASIC_RATE");
            oldReviewCount = rs.getInt("OLD_REVIEW_COUNT");
            imageUrl = rs.getString("IMAGE_URL");
            badge = rs.getString("BADGE");
            detailText = rs.getString("DETAIL_TEXT");
            deliveryText = rs.getString("DELIVERY_TEXT");

            if (imageUrl == null || imageUrl.trim().equals("")) {
                imageUrl = fallbackImageUrl;
            }
        }
        rs.close();
        pstmt.close();

        pstmt = conn.prepareStatement(
                "SELECT COUNT(*) AS CNT, AVG(SCORE) AS AVG_SCORE FROM PRODUCT_REVIEW WHERE PRODUCT_ID = ?"
        );
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            newReviewCount = rs.getInt("CNT");
            if (newReviewCount > 0) {
                showRate = rs.getDouble("AVG_SCORE");
            } else {
                showRate = basicRate;
            }
        }
        rs.close();
        pstmt.close();

        pstmt = conn.prepareStatement(
                "SELECT WRITER, SCORE, CONTENT, REG_DATE "
                        + "FROM PRODUCT_REVIEW "
                        + "WHERE PRODUCT_ID = ? "
                        + "ORDER BY REVIEW_NO DESC"
        );
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            HashMap<String, String> review = new HashMap<>();
            Timestamp regDate = rs.getTimestamp("REG_DATE");
            String dateText = "";

            if (regDate != null) {
                dateText = regDate.toString();
                if (dateText.length() >= 16) {
                    dateText = dateText.substring(0, 16);
                }
            }

            review.put("writer", rs.getString("WRITER"));
            review.put("score", String.valueOf(rs.getInt("SCORE")));
            review.put("content", rs.getString("CONTENT"));
            review.put("regDate", dateText);
            reviewList.add(review);
        }
        rs.close();
        pstmt.close();
    } catch (Exception e) {
        errorMessage = e.getMessage();
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }



main
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
main
    <title>상품 상세</title>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', Arial, sans-serif;
            background: #f5f6f8;
            color: #222;
        }
        .header {
            background: #111827;
            color: white;
            padding: 18px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header a {
            color: white;
            text-decoration: none;
            margin-left: 16px;
        }
        .container {
            width: 1050px;
            margin: 40px auto;
        }
        .product-box {
            display: grid;
            grid-template-columns: 440px 1fr;
            gap: 40px;
            background: white;
            padding: 34px;
            border-radius: 16px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }
        .product-box img {
            width: 440px;
            height: 440px;
            object-fit: cover;
            border-radius: 14px;
            background: #ddd;
        }
        .brand {
            color: #777;
            font-size: 15px;
            margin-bottom: 10px;
        }
        h1 {
            margin: 0 0 20px 0;
            font-size: 34px;
        }
        .price {
            font-size: 30px;
            font-weight: bold;
            color: #111827;
            margin: 20px 0;
        }
        .desc {
            line-height: 1.7;
            color: #555;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
        .cart-btn {
            margin-top: 30px;
            width: 220px;
            border: none;
            background: #111827;
            color: white;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
        }
        .review-section {
            margin-top: 34px;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }
        .review-form {
            border: 1px solid #e5e7eb;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 28px;
            background: #fafafa;
        }
        .review-form select,
        .review-form textarea {
            width: 100%;
            box-sizing: border-box;
            margin-top: 8px;
            margin-bottom: 14px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-family: inherit;
        }
        .review-form button {
            background: #2563eb;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 8px;
            cursor: pointer;
        }
        .login-notice {
            padding: 18px;
            background: #fef3c7;
            border-radius: 10px;
            margin-bottom: 24px;
        }
        .review-item {
            border-top: 1px solid #eee;
            padding: 18px 0;
        }
        .review-item:first-child {
            border-top: none;
        }
        .review-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
        }
        .stars {
            color: #f59e0b;
            font-weight: bold;
        }
        .delete-btn {
            background: #ef4444;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
        }
        .empty {
            color: #777;
            padding: 20px 0;
        }
        .back {
            display: inline-block;
            margin-bottom: 20px;
            color: #111827;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="header">
    <div>
        <a href="<%= request.getContextPath() %>/index.jsp"><strong>SHOP MALL</strong></a>
        <a href="<%= request.getContextPath() %>/product/list.jsp">상품 목록</a>
    </div>
    <div>
        <% if (isLogin) { %>
            <span><%= loginId %>님</span>
            <a href="<%= request.getContextPath() %>/auth/logout.jsp">로그아웃</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/auth/login.jsp">로그인</a>
            <a href="<%= request.getContextPath() %>/member/register.jsp">회원가입</a>
        <% } %>
    </div>
</div>

<div class="container">
    <a class="back" href="<%= request.getContextPath() %>/product/list.jsp">← 상품 목록으로</a>

    <% if (product == null) { %>
        <div class="product-box">
            존재하지 않는 상품입니다.
        </div>
    <% } else { %>
        <div class="product-box">
            <div>
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
            </div>
            <div>
                <div class="brand"><%= product.getBrand() == null ? "" : product.getBrand() %></div>
                <h1><%= product.getName() %></h1>
                <div class="price"><%= String.format("%,d", product.getPrice()) %>원</div>
                <div class="desc">
                    <%= product.getDescription() == null ? "상품 설명이 없습니다." : product.getDescription() %>
                </div>
                <button class="cart-btn" type="button"
                        onclick="location.href='<%= request.getContextPath() %>/cart/add.jsp?id=<%= product.getId() %>&name=<%= java.net.URLEncoder.encode(product.getName(), "UTF-8") %>&price=<%= product.getPrice() %>&image=<%= java.net.URLEncoder.encode(product.getImageUrl(), "UTF-8") %>'">
                    장바구니 담기
                </button>
            </div>
        </div>

        <div class="review-section">
            <h2>상품 리뷰</h2>

            <% if (isLogin) { %>
                <form class="review-form" action="<%= request.getContextPath() %>/product/reviewInsert.jsp" method="post">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <label>별점</label>
                    <select name="rating" required>
                        <option value="5">★★★★★ 5점</option>
                        <option value="4">★★★★☆ 4점</option>
                        <option value="3">★★★☆☆ 3점</option>
                        <option value="2">★★☆☆☆ 2점</option>
                        <option value="1">★☆☆☆☆ 1점</option>
                    </select>

                    <label>한 줄 평</label>
                    <textarea name="content" rows="4" maxlength="1000" placeholder="리뷰를 입력하세요." required></textarea>

                    <button type="submit">리뷰 등록</button>
                </form>
            <% } else { %>
                <div class="login-notice">
                    리뷰 작성은 로그인 후 가능합니다.
                    <a href="<%= request.getContextPath() %>/auth/login.jsp">로그인하기</a>
                </div>
            <% } %>

            <% if (reviews == null || reviews.isEmpty()) { %>
                <div class="empty">아직 작성된 리뷰가 없습니다.</div>
            <% } else { %>
                <% for (ReviewDto r : reviews) { %>
                    <div class="review-item">
                        <div class="review-meta">
                            <div>
                                <strong><%= r.getWriterId() %></strong>
                                <span class="stars">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <%= i <= r.getRating() ? "★" : "☆" %>
                                    <% } %>
                                </span>
                            </div>
                            <div><%= r.getCreatedAt() %></div>
                        </div>

                        <div><%= r.getContent() %></div>

                        <% if (isLogin && loginId.equals(r.getWriterId())) { %>
                            <form action="<%= request.getContextPath() %>/product/reviewDelete.jsp" method="post" style="margin-top: 10px;"
                                  onsubmit="return confirm('리뷰를 삭제하시겠습니까?');">
                                <input type="hidden" name="reviewId" value="<%= r.getId() %>">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <button class="delete-btn" type="submit">삭제</button>
                            </form>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
        </div>
    <% } %>
</div>

    <title><%= productOk ? productName : "상품 상세" %> - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
    <style>
        .detail-page {
            margin-top: 42px;
        }

        .detail-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 24px;
        }

        .detail-top h1 {
            margin-bottom: 6px;
            font-size: 30px;
            font-weight: 900;
        }

        .detail-top p {
            color: #636e72;
            font-size: 14px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: minmax(320px, 1fr) minmax(320px, 440px);
            gap: 28px;
            align-items: start;
        }

        .detail-photo {
            overflow: hidden;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #fff;
        }

        .detail-photo img {
            display: block;
            width: 100%;
            aspect-ratio: 1;
            object-fit: cover;
        }

        .detail-box {
            padding: 24px;
            border: 1px solid #eee;
            border-radius: 8px;
            cursor: default;
        }

        .detail-box:hover {
            transform: none;
            box-shadow: none;
        }

        .detail-badge {
            display: inline-block;
            margin-bottom: 14px;
            padding: 5px 10px;
            border-radius: 4px;
            background: #2d3436;
            color: #fff;
            font-size: 12px;
            font-weight: 800;
        }

        .detail-brand {
            margin-bottom: 6px;
            color: #95a5a6;
            font-size: 13px;
            font-weight: 700;
        }

        .detail-name {
            margin-bottom: 14px;
            font-size: 26px;
            font-weight: 900;
        }

        .detail-rate {
            margin-bottom: 18px;
            color: #636e72;
            font-size: 13px;
        }

        .detail-price {
            display: flex;
            align-items: baseline;
            gap: 10px;
            margin-bottom: 22px;
        }

        .detail-price .price {
            font-size: 26px;
        }

        .detail-info-title {
            margin: 38px 0 12px;
            font-size: 16px;
            font-weight: 900;
        }

        .detail-text {
            padding: 20px;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #fff;
            color: #2d3436;
            line-height: 1.8;
        }

        .review-layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 24px;
            align-items: start;
        }

        .review-form,
        .review-list-box {
            padding: 20px;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #fff;
        }

        .review-form label {
            display: block;
            margin: 14px 0 7px;
            font-size: 13px;
            font-weight: 800;
        }

        .review-form input,
        .review-form select,
        .review-form textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #dfe6e9;
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
        }

        .review-form textarea {
            min-height: 140px;
            resize: vertical;
        }

        .review-submit-btn {
            width: 100%;
            margin-top: 14px;
            padding: 11px 14px;
            border: 1px solid #2d3436;
            border-radius: 8px;
            background: #2d3436;
            color: #fff;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
        }

        .review-submit-btn:hover {
            border-color: #1e272e;
            background: #1e272e;
        }

        .review-item {
            padding: 16px 0;
            border-bottom: 1px solid #f1f2f6;
        }

        .review-item:first-child {
            padding-top: 0;
        }

        .review-item:last-child {
            padding-bottom: 0;
            border-bottom: 0;
        }

        .review-meta {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 8px;
            color: #636e72;
            font-size: 12px;
        }

        .review-star {
            color: #f39c12;
            font-weight: 900;
        }

        .review-content {
            font-size: 14px;
            line-height: 1.7;
        }

        .empty-detail {
            padding: 50px 20px;
            border: 1px dashed #dfe6e9;
            border-radius: 8px;
            background: #fff;
            text-align: center;
        }

        .empty-detail p {
            margin: 10px 0 22px;
            color: #636e72;
        }

        @media (max-width: 820px) {
            .detail-grid,
            .review-layout {
                grid-template-columns: 1fr;
            }

            .detail-top {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body data-context-path="<%= contextPath %>">

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
            <a href="<%= contextPath %>/board/list.jsp">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

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
            <div class="icon-btn">
                <div class="icon">i</div>My
            </div>
        </div>
    </div>
</header>

<main class="container detail-page">
    <% if (!errorMessage.equals("")) { %>
        <div class="empty-detail">
            <h1>DB 오류가 발생했습니다.</h1>
            <p><%= errorMessage %></p>
            <a href="<%= contextPath %>/index.jsp" class="btn-primary">메인으로</a>
        </div>
    <% } else if (!productOk) { %>
        <div class="empty-detail">
            <h1>상품을 찾을 수 없습니다.</h1>
            <p>상품 번호를 다시 확인해 주세요.</p>
            <a href="<%= contextPath %>/index.jsp" class="btn-primary">메인으로</a>
        </div>
    <% } else { %>
        <div class="detail-top">
            <div>
                <h1>상품 상세</h1>
                <p>상품 설명은 H2 shopingmall DB에서 불러온 내용입니다.</p>
            </div>
            <a href="<%= contextPath %>/index.jsp" class="btn-secondary">목록으로</a>
        </div>

        <div class="detail-grid">
            <div class="detail-photo">
                <img src="<%= imageUrl %>"
                     alt="<%= productName %>"
                     onerror="this.onerror=null; this.src='<%= fallbackImageUrl %>'; document.querySelector('.detail-box').dataset.image='<%= fallbackImageUrl %>';">
            </div>

            <div class="product-card detail-box"
                 data-id="<%= productId %>"
                 data-name="<%= productName %>"
                 data-brand="<%= brand %>"
                 data-category="<%= category %>"
                 data-price="<%= salePrice %>"
                 data-rate="<%= showRate %>"
                 data-image="<%= imageUrl %>">
                <div class="detail-badge"><%= badge %></div>
                <div class="detail-brand"><%= brand %> · <%= category %></div>
                <div class="detail-name"><%= productName %></div>
                <div class="detail-rate">
                    ★ <%= String.format("%.1f", showRate) %>
                    · 리뷰 <%= String.format("%,d", oldReviewCount + newReviewCount) %>
                </div>
                <div class="detail-price">
                    <% if (discountRate > 0) { %>
                        <span class="discount"><%= discountRate %>%</span>
                    <% } %>
                    <span class="price"><%= String.format("%,d", salePrice) %>원</span>
                    <% if (originalPrice > salePrice) { %>
                        <span class="original"><%= String.format("%,d", originalPrice) %>원</span>
                    <% } %>
                </div>
                <button type="button" class="add-cart-btn">장바구니 담기</button>
            </div>
        </div>

        <section>
            <h2 class="detail-info-title">상세 내용</h2>
            <div class="detail-text">
                <%= detailText != null ? detailText.replace("\n", "<br>") : "" %>
            </div>

            <h2 class="detail-info-title">배송 안내</h2>
            <div class="detail-text">
                <%= deliveryText != null ? deliveryText.replace("\n", "<br>") : "" %>
            </div>
        </section>

        <section>
            <div class="section-head">
                <div>
                    <h2>리뷰</h2>
                    <div class="sub">작성한 리뷰는 PRODUCT_REVIEW 테이블에 저장됩니다.</div>
                </div>
            </div>

            <div class="review-layout">
                <form id="reviewForm"
                      class="review-form"
                      method="post"
                      action="<%= contextPath %>/product/reviewSubmit.jsp">
                    <input type="hidden" name="productId" value="<%= productId %>">

                    <label for="writer">작성자</label>
                    <input id="writer"
                           name="writer"
                           type="text"
                           maxlength="30"
                           value="<%= loginId %>"
                           placeholder="익명">

                    <label for="score">별점</label>
                    <select id="score" name="score">
                        <option value="5">5점</option>
                        <option value="4">4점</option>
                        <option value="3">3점</option>
                        <option value="2">2점</option>
                        <option value="1">1점</option>
                    </select>

                    <label for="content">리뷰 내용</label>
                    <textarea id="content"
                              name="content"
                              maxlength="1000"
                              required
                              placeholder="상품을 사용한 느낌을 적어주세요."></textarea>

                    <button type="submit" class="review-submit-btn">리뷰 등록</button>
                </form>

                <div class="review-list-box">
                    <% if (reviewList.size() == 0) { %>
                        <div class="product-empty">아직 작성된 리뷰가 없습니다.</div>
                    <% } else { %>
                        <% for (int i = 0; i < reviewList.size(); i++) {
                            HashMap<String, String> review = reviewList.get(i);
                        %>
                            <div class="review-item">
                                <div class="review-meta">
                                    <span>
                                        <strong><%= review.get("writer") %></strong>
                                        · <span class="review-star">★ <%= review.get("score") %></span>
                                    </span>
                                    <span><%= review.get("regDate") %></span>
                                </div>
                                <div class="review-content">
                                    <%= review.get("content") != null
                                            ? review.get("content").replace("\n", "<br>")
                                            : "" %>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </section>
    <% } %>
</main>

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

<script src="<%= contextPath %>/js/shop.js"></script>
main
</body>
</html>
