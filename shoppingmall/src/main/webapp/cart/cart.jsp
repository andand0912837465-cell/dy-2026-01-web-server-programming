<%--
main
    20252364 강한서

    장바구니 목록을 출력하는 JSP 페이지이다.
    세션에 저장된 장바구니 상품 목록을 가져와 상품명, 가격, 수량, 합계 금액을 화면에 출력한다.

    세션에 저장된 장바구니 목록을 조회한다.
    상품별 이미지, 상품명, 가격, 수량, 합계 금액을 출력한다.
    전체 상품의 총 결제 금액을 계산하여 출력한다.
    장바구니가 비어 있으면 안내 문구를 출력한다.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    List<Map<String, String>> cart =
            (List<Map<String, String>>) session.getAttribute("cart");

    int totalPrice = 0;
%>


  20252361 김지연 - 장바구니 수량 변경, 배송비 계산, 주문서 이동 처리
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    String contextPath = request.getContextPath();
%>
main
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니 - SHOPMALL</title>
main
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <style>
        .cart-wrap {
            width: 1100px;
            margin: 50px auto;
        }

        .cart-title {
            font-size: 32px;
            margin-bottom: 30px;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .cart-table th,
        .cart-table td {
            padding: 18px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }

        .cart-table th {
            background: #f5f6f8;
        }

        .cart-img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 10px;
        }

        .cart-total {
            margin-top: 30px;
            text-align: right;
            font-size: 24px;
            font-weight: bold;
        }

        .cart-actions {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }

        .cart-btn {
            display: inline-block;
            padding: 14px 24px;
            background: #2f3a3a;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        .empty {
            padding: 60px;
            background: white;
            text-align: center;
            border-radius: 12px;
            color: #777;
        }
    </style>

    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
 main
</head>
<body data-context-path="<%= contextPath %>">

main
<div class="cart-wrap">
    <h1 class="cart-title">장바구니</h1>

    <% if (cart == null || cart.isEmpty()) { %>
    <div class="empty">
        장바구니에 담긴 상품이 없습니다.
    </div>
    <% } else { %>
    <table class="cart-table">
        <thead>
        <tr>
            <th>이미지</th>
            <th>상품명</th>
            <th>가격</th>
            <th>수량</th>
            <th>합계</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, String> item : cart) {
                int price = Integer.parseInt(item.get("price"));
                int qty = Integer.parseInt(item.get("qty"));
                int itemTotal = price * qty;
                totalPrice += itemTotal;
        %>
        <tr>
            <td>
                <% if (item.get("image") != null && item.get("image").length() > 0) { %>
                <img class="cart-img" src="<%= item.get("image") %>" alt="<%= item.get("name") %>">
                <% } else { %>
                -
                <% } %>
            </td>
            <td><%= item.get("name") %></td>
            <td><%= String.format("%,d", price) %>원</td>
            <td><%= qty %></td>
            <td><%= String.format("%,d", itemTotal) %>원</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="cart-total">
        총 금액: <%= String.format("%,d", totalPrice) %>원

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

<main class="container cart-page">
    <div class="cart-page-head">
        <div>
            <h1>장바구니</h1>
            <p>담은 상품의 수량과 주문 완료 처리 예정 금액을 확인해 주세요.</p>
        </div>
        <a href="<%= contextPath %>/index.jsp" class="btn-secondary">쇼핑 계속하기</a>
 main
    </div>
    <% } %>

 main
    <div class="cart-actions">
        <a class="cart-btn" href="<%= request.getContextPath() %>/index.jsp">쇼핑 계속하기</a>
        <a class="cart-btn" href="<%= request.getContextPath() %>/cart/clear.jsp">장바구니 비우기</a>

    <section id="cartEmpty" class="cart-empty" hidden>
        <h2>장바구니가 비어 있습니다</h2>
        <p>마음에 드는 상품을 담고 한 번에 주문해 보세요.</p>
        <a href="<%= contextPath %>/index.jsp" class="btn-primary">쇼핑 계속하기</a>
    </section>

    <section id="cartContent" class="cart-layout" hidden>
        <div class="cart-panel">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>상품 정보</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>합계</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody id="cartTableBody"></tbody>
            </table>
        </div>

        <aside class="cart-summary">
            <h2>주문 예정 금액</h2>
            <div class="summary-row">
                <span>총 상품금액</span>
                <strong id="cartSubtotal">0원</strong>
            </div>
            <div class="summary-row">
                <span>배송비</span>
                <strong id="cartShipping">0원</strong>
            </div>
            <div class="summary-row summary-total">
                <span>최종 주문금액</span>
                <strong id="cartTotal">0원</strong>
            </div>
            <div class="cart-actions">
                <button type="button" id="checkoutButton" class="btn-primary">주문서 작성</button>
                <button type="button" id="clearCartButton" class="btn-secondary">전체 삭제</button>
                <a href="<%= contextPath %>/index.jsp" class="btn-secondary">계속 둘러보기</a>
            </div>
        </aside>
    </section>
</main>

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
main
    </div>
</div>

 main

<script src="<%= contextPath %>/js/cart.js"></script>
 main
</body>
</html>