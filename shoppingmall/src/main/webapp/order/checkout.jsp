<%--
  20252361 김지연
  기능 설명: 장바구니 상품을 서버 주문 처리 서블릿으로 제출하는 주문서 화면
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%!
    private String rawValue(Object valuesObject, String key) {
        if (!(valuesObject instanceof java.util.Map<?, ?>)) {
            return "";
        }

        java.util.Map<?, ?> values = (java.util.Map<?, ?>) valuesObject;
        Object value = values.get(key);
        return value == null ? "" : String.valueOf(value);
    }

    private String value(Object valuesObject, String key) {
        return escapeHtml(rawValue(valuesObject, key));
    }

    private String checked(Object valuesObject, String key, String expected) {
        return expected.equals(rawValue(valuesObject, key)) ? "checked" : "";
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
%>
<%
    String contextPath = request.getContextPath();
    Object checkoutFormValues = request.getAttribute("checkoutFormValues");
    String checkoutError = (String) request.getAttribute("checkoutError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문서 작성 - SHOPMALL</title>
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
<header>
    <div class="container header-inner">
        <a href="<%= contextPath %>/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="주문서를 작성 중입니다" disabled>
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
    <div class="cart-page-head">
        <div>
            <h1>주문서 작성</h1>
            <p>배송 정보를 입력하고 주문 상품과 주문 완료 처리 예정 금액을 확인해 주세요.</p>
        </div>
        <a href="<%= contextPath %>/cart/cart.jsp" class="btn-secondary">장바구니로 돌아가기</a>
    </div>

    <section id="checkoutEmpty" class="cart-empty" hidden>
        <h2>주문할 상품이 없습니다</h2>
        <p>장바구니에 상품을 담은 뒤 주문을 진행해 주세요.</p>
        <a href="<%= contextPath %>/cart/cart.jsp" class="btn-primary">장바구니로 이동</a>
    </section>

    <section id="checkoutContent" class="order-layout" hidden>
        <form id="checkoutForm" class="checkout-panel" method="post" action="<%= contextPath %>/order/submit" novalidate>
            <h2>주문자 정보</h2>
            <p class="panel-sub">필수 배송 정보를 정확히 입력해 주세요.</p>

            <div id="checkoutError" class="form-error" <%= checkoutError == null ? "hidden" : "" %>><%= checkoutError == null ? "" : escapeHtml(checkoutError) %></div>

            <div class="form-group">
                <label for="customerName">주문자명</label>
                <input type="text" id="customerName" name="customerName" value="<%= value(checkoutFormValues, "customerName") %>" placeholder="이름을 입력해 주세요" required>
            </div>

            <div class="form-group">
                <label for="customerPhone">연락처</label>
                <input type="tel" id="customerPhone" name="customerPhone" value="<%= value(checkoutFormValues, "customerPhone") %>" placeholder="010-0000-0000" inputmode="tel" required>
            </div>

            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" value="<%= value(checkoutFormValues, "email") %>" placeholder="shopmall@example.com" required>
            </div>

            <div class="field-row">
                <div class="form-group">
                    <label for="zipcode">우편번호</label>
                    <input type="text" id="zipcode" name="zipcode" value="<%= value(checkoutFormValues, "zipcode") %>" placeholder="우편번호" required>
                </div>
                <div class="form-group">
                    <label for="address">주소</label>
                    <input type="text" id="address" name="address" value="<%= value(checkoutFormValues, "address") %>" placeholder="주소를 입력해 주세요" required>
                </div>
            </div>

            <div class="form-group">
                <label for="detailAddress">상세주소</label>
                <input type="text" id="detailAddress" name="detailAddress" value="<%= value(checkoutFormValues, "detailAddress") %>" placeholder="동, 호수 등 상세주소" required>
            </div>

            <div class="form-group">
                <label for="requestMemo">배송 요청사항</label>
                <textarea id="requestMemo" name="requestMemo" rows="4" placeholder="예: 문 앞에 놓아주세요"><%= value(checkoutFormValues, "requestMemo") %></textarea>
            </div>

            <div class="form-group">
                <span class="form-label">결제 방법</span>
                <div class="choice-list" role="radiogroup" aria-label="결제 방법">
                    <label><input type="radio" name="paymentMethod" value="card" <%= checked(checkoutFormValues, "paymentMethod", "card") %> required> 카드 결제 시뮬레이션</label>
                    <label><input type="radio" name="paymentMethod" value="bank" <%= checked(checkoutFormValues, "paymentMethod", "bank") %>> 무통장 입금</label>
                    <label><input type="radio" name="paymentMethod" value="simple" <%= checked(checkoutFormValues, "paymentMethod", "simple") %>> 간편 결제 시뮬레이션</label>
                </div>
            </div>

            <label class="agreement-box" for="privacyAgreement">
                <input type="checkbox" id="privacyAgreement" name="privacyAgreement" value="Y" <%= checked(checkoutFormValues, "privacyAgreement", "Y") %> required>
                주문 완료 처리를 위한 개인정보 수집 및 이용에 동의합니다.
            </label>

            <button type="submit" class="btn-primary order-submit-btn">주문 완료 처리</button>
        </form>

        <aside class="cart-summary order-summary">
            <h2>주문 상품 요약</h2>
            <div id="checkoutItemList" class="order-item-list"></div>
            <div class="summary-row">
                <span>총 상품금액</span>
                <strong id="checkoutSubtotal">0원</strong>
            </div>
            <div class="summary-row">
                <span>배송비</span>
                <strong id="checkoutShipping">0원</strong>
            </div>
            <div class="summary-row summary-total">
                <span>최종 주문금액</span>
                <strong id="checkoutTotal">0원</strong>
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
    </div>
</footer>

<script src="<%= contextPath %>/js/checkout.js"></script>
</body>
</html>
