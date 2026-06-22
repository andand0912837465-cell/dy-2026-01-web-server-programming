<%--
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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
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
</body>
</html>
