<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문서 작성 - SHOPMALL</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
</head>
<body>

<!-- 상단 유틸 -->
<div class="top-bar">
    <div class="container">
        <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
        <div>
            <% if (SessionUtils.isLoginYn(session)) {%>
                <a href="/auth/logout.jsp">로그아웃</a>
                <a href="#">회원정보</a>
            <% } else {%>
                <a href="/auth/login.jsp">로그인</a>
                <a href="/member/register.jsp">회원가입</a>
            <% } %>
            <a href="#">고객센터</a>
            <a href="#">마이페이지</a>
        </div>
    </div>
</div>

<!-- 헤더 -->
<header>
    <div class="container header-inner">
        <a href="/index.jsp" class="logo">SHOP<span>MALL</span></a>
        <div class="search-box">
            <label for="search" class="sr-only">상품 검색</label>
            <input id="search" type="text" placeholder="주문서를 작성 중입니다" disabled>
            <button type="button" aria-label="검색" disabled>Q</button>
        </div>
        <div class="header-icons">
            <div class="icon-btn">
                <div class="icon">♥</div>찜
                <span id="wishlistBadge" class="badge wishlist-badge" hidden>0</span>
            </div>
            <a href="/cart/cart.jsp" class="icon-btn cart-link">
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
            <p>배송 정보를 입력하고 주문 상품과 결제 예정 금액을 확인해 주세요.</p>
        </div>
        <a href="/cart/cart.jsp" class="btn-secondary">장바구니로 돌아가기</a>
    </div>

    <section id="checkoutEmpty" class="cart-empty" hidden>
        <h2>주문할 상품이 없습니다</h2>
        <p>장바구니에 상품을 담은 뒤 주문을 진행해 주세요.</p>
        <a href="/cart/cart.jsp" class="btn-primary">장바구니로 이동</a>
    </section>

    <section id="checkoutContent" class="order-layout" hidden>
        <form id="checkoutForm" class="checkout-panel" novalidate>
            <h2>주문자 정보</h2>
            <p class="panel-sub">필수 배송 정보를 정확히 입력해 주세요.</p>

            <div id="checkoutError" class="form-error" hidden></div>

            <div class="form-group">
                <label for="customerName">주문자명</label>
                <input type="text" id="customerName" name="customerName" placeholder="이름을 입력해 주세요">
            </div>

            <div class="form-group">
                <label for="customerPhone">연락처</label>
                <input type="text" id="customerPhone" name="customerPhone" placeholder="010-0000-0000">
            </div>

            <div class="field-row">
                <div class="form-group">
                    <label for="zipcode">우편번호</label>
                    <input type="text" id="zipcode" name="zipcode" placeholder="우편번호">
                </div>
                <div class="form-group">
                    <label for="address">주소</label>
                    <input type="text" id="address" name="address" placeholder="주소를 입력해 주세요">
                </div>
            </div>

            <div class="form-group">
                <label for="detailAddress">상세주소</label>
                <input type="text" id="detailAddress" name="detailAddress" placeholder="동, 호수 등 상세주소">
            </div>

            <div class="form-group">
                <label for="requestMemo">배송 요청사항</label>
                <textarea id="requestMemo" name="requestMemo" rows="4" placeholder="예: 문 앞에 놓아주세요"></textarea>
            </div>

            <button type="submit" class="btn-primary order-submit-btn">주문하기</button>
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
                <span>최종 결제금액</span>
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

<script src="/js/checkout.js"></script>
</body>
</html>
