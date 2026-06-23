<%--
  20252377 양효재
  부분 구현된 주문 상세 기능이 남아 있어서 개선 진행하였다.
  주문 목록에서 선택한 주문의 기본 정보와 배송 결제 정보를 따로 보여주고,
  상태 변경과 취소 환불 처리를 한 화면에서 하도록 정리했다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.order.OrderDto" %>
<%@ page import="kr.ac.dy.cs.order.OrderService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%
    String contextPath = request.getContextPath();
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
        return;
    }

    String orderIdValue = request.getParameter("orderId");
    Long orderId = null;
    try {
        orderId = Long.parseLong(orderIdValue);
    } catch (Exception ignore) {
    }

    OrderService orderService = new OrderService();
    OrderDto order = orderId != null ? orderService.getOrder(orderId) : null;
    List<String> allStatuses = orderService.getOrderStatuses();
    List<String> nextStatuses = order != null ? orderService.getNextStatuses(order.getStatus()) : java.util.Collections.emptyList();

    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null || loginId.isBlank()) {
        loginId = "admin";
    }
    Date loginAt = (Date) session.getAttribute("loginAt");
    String loginAtStr = loginAt != null
            ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt)
            : "-";
    String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());
    DateTimeFormatter orderDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    String returnUrl = contextPath + "/order/view.jsp?orderId=" + (orderId != null ? orderId : "");
%>
<%! 
    private String textOrDash(String value) {
        return value == null || value.isBlank() ? "-" : value;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 상세 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
    <style>
        .order-detail-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 24px;
        }

        .order-info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-info-table th,
        .order-info-table td {
            padding: 12px 10px;
            border-bottom: 1px solid #eef0f4;
            text-align: left;
            font-size: 14px;
        }

        .order-info-table th {
            width: 140px;
            color: #6b7280;
            font-weight: 800;
        }

        .order-action-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 16px;
        }

        .order-action-row form {
            margin: 0;
        }

        .order-quick-btn {
            padding: 8px 12px;
            border: 0;
            border-radius: 8px;
            background: #0f172a;
            color: #fff;
            font-family: inherit;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .order-select-form {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 18px;
        }

        .empty-order-box {
            padding: 42px 20px;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            background: #f8fafc;
            color: #6b7280;
            text-align: center;
        }

        @media (max-width: 860px) {
            .order-detail-grid {
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
            <a href="<%= contextPath %>/product/list.jsp" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
            <a href="<%= contextPath %>/order/list.jsp" class="nav-item active"><span class="nav-icon">🛒</span> 주문 관리</a>
            <a href="<%= contextPath %>/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
        </div>
    </nav>
    <div class="dash-sidebar-foot">© 2026 SHOPMALL ADMIN</div>
</aside>

<main class="dash-main">
    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>주문 상세</h1>
            <p><%= nowStr %></p>
        </div>
        <div class="dash-user">
            <div class="dash-user-info">
                <span class="dash-user-id"><strong><%= loginId %></strong>님</span>
                <span class="dash-user-meta">최근 로그인: <%= loginAtStr %></span>
            </div>
            <div class="dash-user-avatar"><%= loginId.substring(0, 1).toUpperCase() %></div>
            <a href="<%= contextPath %>/auth/adminLogout.jsp" class="dash-logout">로그아웃</a>
        </div>
    </header>

    <% if (order == null) { %>
    <section class="dash-panel">
        <div class="empty-order-box">
            조회할 주문이 없습니다.<br>
            <a href="<%= contextPath %>/order/list.jsp">주문 목록으로 돌아가기</a>
        </div>
    </section>
    <% } else { %>
    <section class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">주문번호</span><span class="kpi-icon orders">#</span></div>
            <div class="kpi-value"><small><%= order.getOrderNumber() %></small></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">주문금액</span><span class="kpi-icon sales">₩</span></div>
            <div class="kpi-value"><%= String.format("%,d", order.getPrice()) %>원</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">주문상태</span><span class="kpi-icon members">📌</span></div>
            <div class="kpi-value"><small><%= order.getStatus() %></small></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">환불금액</span><span class="kpi-icon stock">↩</span></div>
            <div class="kpi-value"><%= String.format("%,d", order.getRefundAmount()) %>원</div>
        </div>
    </section>

    <section class="order-detail-grid">
        <div class="dash-panel">
            <div class="panel-head">
                <h3>기본 주문 정보</h3>
                <a href="<%= contextPath %>/order/list.jsp" class="panel-link">목록으로 →</a>
            </div>
            <table class="order-info-table">
                <tr><th>주문번호</th><td><%= order.getOrderNumber() %></td></tr>
                <tr><th>주문자 ID</th><td><%= textOrDash(order.getMemberId()) %></td></tr>
                <tr><th>상품 ID</th><td><%= textOrDash(order.getProductId()) %></td></tr>
                <tr><th>상품명</th><td><%= textOrDash(order.getProductName()) %></td></tr>
                <tr><th>주문금액</th><td><%= String.format("%,d", order.getPrice()) %>원</td></tr>
                <tr><th>수량</th><td><%= order.getQuantity() %>개</td></tr>
                <tr><th>주문일시</th><td><%= order.getOrderDate() != null ? order.getOrderDate().format(orderDateFormatter) : "-" %></td></tr>
                <tr><th>현재상태</th><td><%= textOrDash(order.getStatus()) %></td></tr>
            </table>

            <div class="order-action-row">
                <% for (String status : nextStatuses) { %>
                <form action="<%= contextPath %>/order/update.jsp" method="post">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <input type="hidden" name="status" value="<%= status %>">
                    <input type="hidden" name="returnUrl" value="<%= returnUrl %>">
                    <button type="submit" class="order-quick-btn"><%= status %> 처리</button>
                </form>
                <% } %>
            </div>

            <form action="<%= contextPath %>/order/update.jsp" method="post" class="order-select-form">
                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                <input type="hidden" name="returnUrl" value="<%= returnUrl %>">
                <select name="status">
                    <% for (String status : allStatuses) { %>
                    <option value="<%= status %>" <%= status.equals(order.getStatus()) ? "selected" : "" %>><%= status %></option>
                    <% } %>
                </select>
                <button type="submit" class="order-quick-btn">상태 저장</button>
            </form>
        </div>

        <div class="dash-panel">
            <div class="panel-head">
                <h3>배송 / 결제 정보</h3>
            </div>
            <table class="order-info-table">
                <tr><th>수령인</th><td><%= textOrDash(order.getReceiverName()) %></td></tr>
                <tr><th>연락처</th><td><%= textOrDash(order.getReceiverPhone()) %></td></tr>
                <tr><th>우편번호</th><td><%= textOrDash(order.getZipCode()) %></td></tr>
                <tr><th>기본주소</th><td><%= textOrDash(order.getAddressMain()) %></td></tr>
                <tr><th>상세주소</th><td><%= textOrDash(order.getAddressDetail()) %></td></tr>
                <tr><th>결제수단</th><td><%= textOrDash(order.getPaymentMethod()) %></td></tr>
                <tr><th>배송메모</th><td><%= textOrDash(order.getRequestMessage()) %></td></tr>
                <tr><th>취소사유</th><td><%= textOrDash(order.getCancelReason()) %></td></tr>
                <tr><th>환불사유</th><td><%= textOrDash(order.getRefundReason()) %></td></tr>
            </table>
        </div>
    </section>
    <% } %>
</main>
</body>
</html>
