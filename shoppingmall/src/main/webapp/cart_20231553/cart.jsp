<%--
============================================================================
 학번 : 20231553
 이름 : 김성민
 파일 : cart_20231553/cart.jsp
 기능 : FR-02 장바구니 조회 화면 (서버 DB 기반).
        - 비로그인 사용자가 접근하면 로그인 페이지로 유도한다. (NFR-03)
        - 로그인 회원의 장바구니를 CartService 로 조회하여 서버에서 직접 렌더링하고,
          상품합계 / 배송비 / 결제예정금액(서버 계산)을 표시한다.
        - 수량 변경(+/-)·개별 삭제·전체 비우기는 폼 전송 방식
          (updateQty.jsp / removeItem.jsp / clearCart.jsp)으로 처리한다.
        - 기존 화면 디자인(공유 css/main.css 클래스)을 재사용하되, 팀원 파일은 수정하지 않았다.
============================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.cart.CartItemDto" %>
<%@ page import="kr.ac.dy.cs.cart.CartService" %>
<%
    String contextPath = request.getContextPath();

    // 비로그인 사용자는 로그인 페이지로 유도 (NFR-03)
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/login.jsp");
        return;
    }
    String memberId = (String) session.getAttribute("loginId");

    // 서버 DB 에서 장바구니 목록과 합계 금액을 조회·계산
    CartService cartService = new CartService();
    List<CartItemDto> cartItems = cartService.getItems(memberId);

    int totalQuantity = cartService.getTotalQuantity(cartItems);
    int subtotal      = cartService.getSubtotal(cartItems);
    int shippingFee   = cartService.getShippingFee(subtotal);
    int total         = subtotal + shippingFee;

    boolean isEmpty = cartItems.isEmpty();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니(DB) - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
</head>
<body>

<!-- 상단 유틸 -->
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
            <a href="#">고객센터</a>
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
            <a href="cart.jsp" class="icon-btn cart-link">
                <div class="icon">🛒</div>장바구니(DB)
                <%-- FR-06 : 헤더 장바구니 배지(서버에서 계산한 총 수량) --%>
                <span id="cartBadge" class="badge cart-badge" <%= totalQuantity == 0 ? "hidden" : "" %>><%= totalQuantity %></span>
            </a>
        </div>
    </div>
</header>

<main class="container cart-page">
    <div class="cart-page-head">
        <div>
            <h1>장바구니 (서버 DB)</h1>
            <p>담은 상품의 수량과 결제 예정 금액을 확인해 주세요.</p>
        </div>
        <a href="shop.jsp" class="btn-secondary">쇼핑 계속하기</a>
    </div>

    <% if (isEmpty) { %>
    <!-- 빈 장바구니 -->
    <section class="cart-empty">
        <h2>장바구니가 비어 있습니다</h2>
        <p>마음에 드는 상품을 담고 한 번에 주문해 보세요.</p>
        <a href="shop.jsp" class="btn-primary">쇼핑 계속하기</a>
    </section>
    <% } else { %>
    <!-- 장바구니 목록 -->
    <section class="cart-layout">
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
                <tbody>
                <% for (CartItemDto item : cartItems) { %>
                    <tr>
                        <!-- 상품 정보 -->
                        <td>
                            <div class="cart-product">
                                <img src="<%= item.getImageUrl() %>" alt="<%= item.getProductName() %>" loading="lazy">
                                <div>
                                    <div class="cart-brand"><%= item.getBrand() %></div>
                                    <div class="cart-name"><%= item.getProductName() %></div>
                                </div>
                            </div>
                        </td>
                        <!-- 가격 -->
                        <td class="cart-price"><%= String.format("%,d", item.getPrice()) %>원</td>
                        <!-- 수량 변경 (FR-03) : +/- 폼 전송 -->
                        <td>
                            <div class="qty-control">
                                <form action="updateQty.jsp" method="post" style="margin:0;display:inline">
                                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                    <button type="submit" aria-label="수량 감소" <%= item.getQuantity() <= 1 ? "disabled" : "" %>>-</button>
                                </form>
                                <span><%= item.getQuantity() %></span>
                                <form action="updateQty.jsp" method="post" style="margin:0;display:inline">
                                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                    <button type="submit" aria-label="수량 증가">+</button>
                                </form>
                            </div>
                        </td>
                        <!-- 합계 -->
                        <td class="cart-line-total"><%= String.format("%,d", item.getLineTotal()) %>원</td>
                        <!-- 개별 삭제 (FR-04) -->
                        <td>
                            <form action="removeItem.jsp" method="post" style="margin:0">
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                <button type="submit" class="remove-cart-btn" aria-label="삭제">삭제</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>

            <!-- 전체 비우기 (FR-05) -->
            <div class="cart-clear" style="margin-top:16px">
                <form action="clearCart.jsp" method="post" style="margin:0">
                    <button type="submit" class="btn-secondary">장바구니 비우기</button>
                </form>
            </div>
        </div>

        <aside class="cart-summary">
            <h2>결제 예정 금액</h2>
            <div class="summary-row">
                <span>총 상품금액</span>
                <strong><%= String.format("%,d", subtotal) %>원</strong>
            </div>
            <div class="summary-row">
                <span>배송비</span>
                <strong><%= String.format("%,d", shippingFee) %>원</strong>
            </div>
            <div class="summary-row summary-total">
                <span>최종 결제금액</span>
                <strong><%= String.format("%,d", total) %>원</strong>
            </div>
            <div class="cart-actions">
                <a href="<%= contextPath %>/order/checkout.jsp" class="btn-primary">주문하기</a>
                <a href="shop.jsp" class="btn-secondary">계속 둘러보기</a>
            </div>
        </aside>
    </section>
    <% } %>
</main>

</body>
</html>
