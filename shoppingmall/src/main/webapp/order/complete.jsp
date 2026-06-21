<%--
  20252361 김지연
  기능 설명: 서버 세션 Order 객체 기준 주문 완료 정보 출력 화면
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.order.Order" %>
<%@ page import="kr.ac.dy.cs.order.OrderItem" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%!
    private String formatPrice(int price) {
        return String.format("%,d원", price);
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String paymentLabel(String value) {
        if ("card".equals(value)) {
            return "카드 결제 시뮬레이션";
        }
        if ("bank".equals(value)) {
            return "무통장 입금";
        }
        if ("simple".equals(value)) {
            return "간편 결제 시뮬레이션";
        }

        return "주문 완료 처리";
    }
%>
<%
    String contextPath = request.getContextPath();
    Order order = (Order) session.getAttribute("shopmallLastOrder");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 완료 - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
</head>
<body data-context-path="<%= contextPath %>" data-order-complete="<%= order != null %>">

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
            <input id="search" type="text" placeholder="주문이 완료되었습니다" disabled>
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

<main class="container order-page">
    <% if (order == null) { %>
    <section id="completeEmpty" class="cart-empty">
        <h2>완료된 주문 정보가 없습니다</h2>
        <p>주문서를 작성한 뒤 완료 화면을 확인할 수 있습니다.</p>
        <a href="<%= contextPath %>/index.jsp" class="btn-primary">메인으로 이동</a>
    </section>
    <% } else { %>
    <section id="completeContent" class="complete-card">
        <div class="complete-hero">
            <span class="complete-mark">✓</span>
            <h1>주문이 완료되었습니다</h1>
            <p><strong><%= escapeHtml(order.getCustomerName()) %></strong>님의 주문을 접수했습니다.</p>
        </div>

        <div class="complete-grid">
            <div class="complete-panel">
                <h2>주문 정보</h2>
                <div class="summary-row">
                    <span>주문번호</span>
                    <strong><%= escapeHtml(order.getOrderNumber()) %></strong>
                </div>
                <div class="summary-row">
                    <span>주문일시</span>
                    <strong><%= order.getOrderedAt().format(formatter) %></strong>
                </div>
                <div class="summary-row">
                    <span>주문자</span>
                    <strong><%= escapeHtml(order.getCustomerName()) %></strong>
                </div>
                <div class="summary-row">
                    <span>연락처</span>
                    <strong><%= escapeHtml(order.getCustomerPhone()) %></strong>
                </div>
                <div class="summary-row">
                    <span>배송 주소</span>
                    <strong><%= escapeHtml(order.getZipcode()) %> <%= escapeHtml(order.getFullAddress()) %></strong>
                </div>
                <div class="summary-row">
                    <span>결제 방법</span>
                    <strong><%= paymentLabel(order.getPaymentMethod()) %></strong>
                </div>
                <div class="summary-row">
                    <span>총 상품금액</span>
                    <strong><%= formatPrice(order.getSubtotal()) %></strong>
                </div>
                <div class="summary-row">
                    <span>배송비</span>
                    <strong><%= formatPrice(order.getShippingFee()) %></strong>
                </div>
                <div class="summary-row summary-total">
                    <span>최종 주문금액</span>
                    <strong><%= formatPrice(order.getTotal()) %></strong>
                </div>
            </div>

            <div class="complete-panel">
                <h2>주문 상품</h2>
                <div class="order-item-list">
                    <% for (OrderItem item : order.getItems()) { %>
                    <div class="order-item">
                        <div>
                            <strong><%= escapeHtml(item.getProductName()) %></strong>
                            <span><%= escapeHtml(item.getBrand()) %> · 수량 <%= item.getQuantity() %>개</span>
                        </div>
                        <strong><%= formatPrice(item.getLineTotal()) %></strong>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="complete-actions">
            <a href="<%= contextPath %>/index.jsp" class="btn-primary">메인으로 이동</a>
            <a href="<%= contextPath %>/wishlist.jsp" class="btn-secondary">찜 목록 확인</a>
        </div>
    </section>
    <% } %>
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
    </div>
</footer>

<script src="<%= contextPath %>/js/complete.js"></script>
</body>
</html>
