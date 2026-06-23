<%--
  20252365 조준혁
  제품 리스트를 관리하는 관리자 페이지.
  제품 정보는 PRODUCT_DETAIL 테이블에서 가져오고,
  리뷰 정보는 PRODUCT_REVIEW 테이블에서 가져온다.
  20252377 양효재
  부분 구현된 상품 관리 기능이 남아 있어서 개선 진행하였다.
  목록 화면에서 상품 등록과 수정과 삭제로 이동할 수 있게 연결하고,
  리뷰 조회와 CRUD가 한 화면 흐름으로 이어지도록 보완했다.
  20252377 양효재
  부분 구현된 재고 관리 항목이 남아 있어서 개선 진행하였다.
  상품 목록에서 재고 수량과 부족 재고를 같이 확인할 수 있게 해서,
  상품 관리 화면에서 수량 상태까지 한 번에 보도록 보완했다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.product.ProductDto" %>
<%@ page import="kr.ac.dy.cs.product.ProductReviewDto" %>
<%@ page import="kr.ac.dy.cs.product.ProductService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
    String fallbackImageUrl = contextPath + "/images/product-fallback.svg";

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
        return;
    }

    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null || loginId.isBlank()) {
        loginId = "admin";
    }

    Date loginAt = (Date) session.getAttribute("loginAt");
    String loginAtStr = loginAt != null
            ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt)
            : "-";
    String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());
    String avatarText = loginId.substring(0, 1).toUpperCase();

    ProductService productService = new ProductService();
    List<ProductDto> products = productService.getProducts();

    String selectedProductId = request.getParameter("productId");
    ProductDto selectedProduct = null;

    if (selectedProductId != null && !selectedProductId.trim().equals("")) {
        selectedProductId = selectedProductId.trim();

        for (ProductDto product : products) {
            if (selectedProductId.equals(product.getProductId())) {
                selectedProduct = product;
                break;
            }
        }

        if (selectedProduct == null) {
            selectedProduct = productService.getProduct(selectedProductId);
        }
    }

    if (selectedProduct == null && products.size() > 0) {
        selectedProduct = products.get(0);
        selectedProductId = selectedProduct.getProductId();
    }

    List<ProductReviewDto> reviews = new ArrayList<>();
    if (selectedProduct != null) {
        reviews = productService.getReviews(selectedProduct.getProductId());
    }

    int totalNewReviewCount = 0;
    int lowStockCount = 0;
    for (ProductDto product : products) {
        totalNewReviewCount += product.getNewReviewCount();
        if (product.getStock() <= 5) {
            lowStockCount++;
        }
    }

    DateTimeFormatter reviewDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 관리 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
    <style>
        .product-manage-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 430px;
            gap: 24px;
            align-items: start;
        }

        .product-summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .product-summary-card {
            background: #fff;
            border: 1px solid #eef0f4;
            border-radius: 14px;
            padding: 20px 22px;
        }

        .product-summary-card span {
            display: block;
            margin-bottom: 8px;
            color: #6b7280;
            font-size: 12px;
            font-weight: 700;
        }

        .product-summary-card strong {
            display: block;
            color: #0f172a;
            font-size: 24px;
            font-weight: 900;
        }

        .product-thumb {
            width: 54px;
            height: 54px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            background: #f9fafb;
            object-fit: cover;
        }

        .product-name-cell strong {
            display: block;
            margin-bottom: 4px;
            color: #111827;
            font-size: 13px;
        }

        .product-name-cell span {
            color: #6b7280;
            font-size: 12px;
        }

        .product-badge {
            display: inline-block;
            padding: 4px 9px;
            border-radius: 20px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 11px;
            font-weight: 800;
        }

        .review-open-link {
            display: inline-block;
            padding: 7px 11px;
            border-radius: 6px;
            background: #0f172a;
            color: #fff;
            font-size: 12px;
            font-weight: 800;
        }

        .review-open-link:hover {
            background: #334155;
        }

        .product-row-active {
            background: #f5f3ff;
        }

        .review-window {
            position: sticky;
            top: 24px;
        }

        .review-head {
            display: flex;
            gap: 14px;
            align-items: center;
            margin-bottom: 18px;
            padding-bottom: 18px;
            border-bottom: 1px solid #eef0f4;
        }

        .review-head img {
            width: 72px;
            height: 72px;
            flex-shrink: 0;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            object-fit: cover;
        }

        .review-head strong {
            display: block;
            margin-bottom: 5px;
            color: #0f172a;
            font-size: 16px;
        }

        .review-head span {
            display: block;
            color: #6b7280;
            font-size: 12px;
            line-height: 1.5;
        }

        .review-help {
            margin-bottom: 16px;
            padding: 12px 14px;
            border: 1px solid #eef0f4;
            border-radius: 8px;
            background: #f9fafb;
            color: #6b7280;
            font-size: 12px;
            line-height: 1.6;
        }

        .review-item-admin {
            margin-bottom: 12px;
            padding: 14px 15px;
            border: 1px solid #eef0f4;
            border-radius: 10px;
            background: #fff;
        }

        .review-item-admin:last-child {
            margin-bottom: 0;
        }

        .review-meta-admin {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 9px;
            color: #6b7280;
            font-size: 12px;
        }

        .review-meta-left {
            min-width: 0;
        }

        .review-meta-right {
            display: flex;
            flex-shrink: 0;
            align-items: center;
            gap: 8px;
        }

        .review-score {
            color: #d97706;
            font-weight: 900;
        }

        .review-delete-form {
            display: inline;
        }

        .review-delete-btn {
            padding: 5px 9px;
            border: 0;
            border-radius: 6px;
            background: #fee2e2;
            color: #b91c1c;
            font-family: inherit;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
        }

        .review-delete-btn:hover {
            background: #fecaca;
        }

        .review-content-admin {
            color: #374151;
            font-size: 13px;
            line-height: 1.7;
            word-break: keep-all;
        }

        .product-desc-box {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #eef0f4;
            color: #4b5563;
            font-size: 13px;
            line-height: 1.7;
        }

        .empty-product-box {
            padding: 42px 20px;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            background: #f8fafc;
            color: #6b7280;
            text-align: center;
        }

        @media (max-width: 1180px) {
            .product-manage-layout {
                grid-template-columns: 1fr;
            }

            .review-window {
                position: static;
            }
        }

        @media (max-width: 760px) {
            .product-summary-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="dashboard-page">

<aside class="dash-sidebar">
    <div class="dash-logo">
        <a href="<%= contextPath %>/dashboard/index.jsp">SHOP<span>MALL</span></a>
        <div class="dash-logo-sub">ADMIN CONSOLE</div>
    </div>

    <nav class="dash-nav">
        <div class="nav-group">
            <div class="nav-group-title">MAIN</div>
            <a href="<%= contextPath %>/dashboard/index.jsp" class="nav-item">
                <span class="nav-icon">▦</span> 대시보드
            </a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">운영</div>
            <a href="<%= contextPath %>/product/list.jsp" class="nav-item active">
                <span class="nav-icon">📦</span> 상품 관리
            </a>
            <a href="<%= contextPath %>/order/list.jsp" class="nav-item">
                <span class="nav-icon">🛒</span> 주문 관리
            </a>
            <a href="<%= contextPath %>/member/list.jsp" class="nav-item">
                <span class="nav-icon">👥</span> 회원 관리
            </a>
            <a href="<%= contextPath %>/board/adminList.jsp" class="nav-item">
                <span class="nav-icon">💬</span> 문의글 관리
            </a>
            <a href="<%= contextPath %>/notice/list.jsp" class="nav-item">
                <span class="nav-icon">📢</span> 공지사항 관리
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">🎁</span> 프로모션
            </a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">분석</div>
            <a href="#" class="nav-item">
                <span class="nav-icon">📊</span> 매출 통계
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">📈</span> 방문자 분석
            </a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">시스템</div>
            <a href="<%= contextPath %>/adminUser/register.jsp" class="nav-item">
                <span class="nav-icon">⚙</span> 관리자 등록
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">🔧</span> 시스템 설정
            </a>
        </div>
    </nav>

    <div class="dash-sidebar-foot">
        © 2026 SHOPMALL ADMIN
    </div>
</aside>

<main class="dash-main">
    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>상품 관리</h1>
            <p><%= nowStr %></p>
        </div>

        <div class="dash-user">
            <div class="dash-user-info">
                <span class="dash-user-id"><strong><%= loginId %></strong>님</span>
                <span class="dash-user-meta">최근 로그인: <%= loginAtStr %></span>
            </div>
            <div class="dash-user-avatar"><%= avatarText %></div>
            <a href="<%= contextPath %>/auth/adminLogout.jsp" class="dash-logout">로그아웃</a>
        </div>
    </header>

    <div class="product-summary-grid">
        <div class="product-summary-card">
            <span>등록 상품</span>
            <strong><%= products.size() %>개</strong>
        </div>
        <div class="product-summary-card">
            <span>DB 저장 리뷰</span>
            <strong><%= totalNewReviewCount %>개</strong>
        </div>
        <div class="product-summary-card">
            <span>선택 상품 리뷰</span>
            <strong><%= reviews.size() %>개</strong>
        </div>
        <div class="product-summary-card">
            <span>재고 부족 상품</span>
            <strong><%= lowStockCount %>개</strong>
        </div>
    </div>

    <div class="product-manage-layout">
        <section class="dash-panel" style="margin: 0;">
            <div class="panel-head">
                <h3>상품 목록 <span class="panel-sub">PRODUCT_DETAIL</span></h3>
                <a href="<%= contextPath %>/product/form.jsp" class="review-open-link">상품 등록</a>
            </div>

            <% if (products.size() == 0) { %>
                <div class="empty-product-box">
                    PRODUCT_DETAIL 테이블에 등록된 상품이 없습니다.<br>
                    일반 쇼핑몰의 <code>product/init_product.sql</code>을 먼저 실행해 주세요.
                </div>
            <% } else { %>
                <div class="table-wrap">
                    <table class="dash-table">
                        <thead>
                        <tr>
                            <th>이미지</th>
                            <th>상품</th>
                            <th>카테고리</th>
                            <th class="num">판매가</th>
                            <th class="num">재고</th>
                            <th class="num">할인</th>
                            <th>리뷰</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (ProductDto product : products) {
                            boolean active = product.getProductId().equals(selectedProductId);
                        %>
                            <tr class="<%= active ? "product-row-active" : "" %>">
                                <td>
                                    <img class="product-thumb"
                                         src="<%= product.getImageUrl() %>"
                                         alt="<%= product.getName() %>"
                                         onerror="this.onerror=null; this.src='<%= fallbackImageUrl %>';">
                                </td>
                                <td>
                                    <div class="product-name-cell">
                                        <strong><%= product.getName() %></strong>
                                        <span><code><%= product.getProductId() %></code> · <%= product.getBrand() %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="product-badge"><%= product.getCategory() %></span>
                                </td>
                                <td class="num"><%= String.format("%,d", product.getSalePrice()) %>원</td>
                                <td class="num">
                                    <span style="color:<%= product.getStock() <= 5 ? "#b91c1c" : "#111827" %>; font-weight:800;">
                                        <%= product.getStock() %>개
                                    </span>
                                </td>
                                <td class="num"><%= product.getDiscountRate() %>%</td>
                                <td>
                                    ★ <%= String.format("%.1f", product.getAverageScore()) %><br>
                                    <span style="color:#6b7280; font-size:12px;">
                                        저장 <%= product.getNewReviewCount() %> / 노출 <%= product.getReviewCount() %>
                                    </span>
                                </td>
                                <td>
                                    <a class="review-open-link"
                                       href="<%= contextPath %>/product/list.jsp?productId=<%= product.getProductId() %>">
                                        리뷰 보기
                                    </a>
                                    <br>
                                    <a class="review-open-link"
                                       href="<%= contextPath %>/product/form.jsp?productId=<%= product.getProductId() %>">
                                        상품 수정
                                    </a>
                                    <form method="post"
                                          action="<%= contextPath %>/product/delete.jsp"
                                          onsubmit="return confirm('이 상품을 삭제하시겠습니까?');"
                                          style="margin-top:6px;">
                                        <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                        <button type="submit" class="review-delete-btn">상품 삭제</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </section>

        <section class="dash-panel review-window" style="margin: 0;">
            <div class="panel-head">
                <h3>리뷰 확인 창 <span class="panel-sub">PRODUCT_REVIEW</span></h3>
            </div>

            <% if (selectedProduct == null) { %>
                <div class="empty-product-box">리뷰를 볼 상품을 선택해 주세요.</div>
            <% } else { %>
                <div class="review-head">
                    <img src="<%= selectedProduct.getImageUrl() %>"
                         alt="<%= selectedProduct.getName() %>"
                         onerror="this.onerror=null; this.src='<%= fallbackImageUrl %>';">
                    <div>
                        <strong><%= selectedProduct.getName() %></strong>
                        <span><%= selectedProduct.getBrand() %> · <%= selectedProduct.getCategory() %></span>
                        <span>상품번호: <%= selectedProduct.getProductId() %></span>
                    </div>
                </div>

                <div class="review-help">
                    이 창은 실제 <strong>PRODUCT_REVIEW</strong> 테이블에 저장된 리뷰만 보여줍니다.
                    상품 목록의 "노출 리뷰수"는 기존 쇼핑몰 표시용 누적값까지 더한 숫자입니다.
                </div>

                <% if (reviews.size() == 0) { %>
                    <div class="empty-product-box">이 상품에 저장된 리뷰가 없습니다.</div>
                <% } else { %>
                    <% for (ProductReviewDto review : reviews) {
                        String regDateText = review.getRegDate() != null
                                ? review.getRegDate().format(reviewDateFormatter)
                                : "-";
                    %>
                        <div class="review-item-admin">
                            <div class="review-meta-admin">
                                <span class="review-meta-left">
                                    <strong><%= review.getWriter() %></strong>
                                    · <span class="review-score">★ <%= review.getScore() %></span>
                                </span>
                                <div class="review-meta-right">
                                    <span><%= regDateText %></span>
                                    <form class="review-delete-form"
                                          method="post"
                                          action="<%= contextPath %>/product/reviewDelete.jsp"
                                          onsubmit="return confirm('이 리뷰를 삭제하시겠습니까?');">
                                        <input type="hidden" name="productId" value="<%= selectedProduct.getProductId() %>">
                                        <input type="hidden" name="reviewNo" value="<%= review.getReviewNo() %>">
                                        <button type="submit" class="review-delete-btn">삭제</button>
                                    </form>
                                </div>
                            </div>
                            <div class="review-content-admin">
                                <%= review.getContent() != null ? review.getContent().replace("\n", "<br>") : "" %>
                            </div>
                        </div>
                    <% } %>
                <% } %>

                <div class="product-desc-box">
                    <strong>상품 설명</strong><br>
                    <%= selectedProduct.getDetailText() != null
                            ? selectedProduct.getDetailText().replace("\n", "<br>")
                            : "등록된 설명이 없습니다." %>
                </div>
            <% } %>
        </section>
    </div>
</main>

</body>
</html>
