<%--
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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
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
</body>
</html>
