<%--
    20252364 강한서

    상품 목록을 출력하는 JSP 페이지이다.
    ProductDao를 이용하여 product 테이블에 저장된 상품 목록을 조회하고,
    조회된 상품들을 카드 형태로 화면에 출력한다.

    데이터베이스에 등록된 상품 목록을 조회한다.
    상품 이미지, 브랜드명, 상품명, 가격을 화면에 출력한다.
    상세 보기 버튼을 통해 상품 상세 페이지(detail.jsp)로 이동한다.
    *css는 Claude 사용
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="kr.ac.dy.cs.product.ProductDto"%>
<%@ page import="kr.ac.dy.cs.product.ProductDao"%>
<%@ page import="kr.ac.dy.cs.util.SessionUtils"%>
<%
    ProductDao productDao = new ProductDao();
    List<ProductDto> products = productDao.findAll();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 목록</title>
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
            width: 1100px;
            margin: 40px auto;
        }
        .title-box {
            margin-bottom: 28px;
        }
        .title-box h1 {
            margin: 0;
            font-size: 32px;
        }
        .title-box p {
            color: #666;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
        }
        .product-card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: 0.2s;
        }
        .product-card:hover {
            transform: translateY(-4px);
        }
        .product-card img {
            width: 100%;
            height: 230px;
            object-fit: cover;
            background: #ddd;
        }
        .product-info {
            padding: 18px;
        }
        .brand {
            font-size: 13px;
            color: #888;
            margin-bottom: 6px;
        }
        .name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 12px;
        }
        .price {
            font-size: 20px;
            font-weight: bold;
            color: #111827;
            margin-bottom: 14px;
        }
        .btn {
            display: block;
            text-align: center;
            background: #111827;
            color: white;
            padding: 10px;
            border-radius: 8px;
            text-decoration: none;
        }
        .empty {
            background: white;
            padding: 40px;
            text-align: center;
            border-radius: 12px;
        }
    </style>
</head>
<body>
<div class="header">
    <div>
        <a href="<%= request.getContextPath() %>/index.jsp"><strong>SHOP MALL</strong></a>
    </div>
    <div>
        <% if (SessionUtils.isLoginYn(session)) { %>
            <span><%= session.getAttribute("loginId") %>님</span>
            <a href="<%= request.getContextPath() %>/auth/logout.jsp">로그아웃</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/auth/login.jsp">로그인</a>
            <a href="<%= request.getContextPath() %>/member/register.jsp">회원가입</a>
        <% } %>
    </div>
</div>

<div class="container">
    <div class="title-box">
        <h1>상품 목록</h1>
        <p>상품을 클릭하면 상세 정보와 리뷰를 확인할 수 있습니다.</p>
    </div>

    <% if (products == null || products.isEmpty()) { %>
        <div class="empty">
            등록된 상품이 없습니다.<br>
            먼저 <code>00_schema.sql</code>의 샘플 상품 INSERT문을 실행하세요.
        </div>
    <% } else { %>
        <div class="product-grid">
            <% for (ProductDto p : products) { %>
                <div class="product-card">
                    <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>">
                    <div class="product-info">
                        <div class="brand"><%= p.getBrand() == null ? "" : p.getBrand() %></div>
                        <div class="name"><%= p.getName() %></div>
                        <div class="price"><%= String.format("%,d", p.getPrice()) %>원</div>
                        <a class="btn" href="<%= request.getContextPath() %>/product/detail.jsp?id=<%= p.getId() %>">
                            상세 보기
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>
