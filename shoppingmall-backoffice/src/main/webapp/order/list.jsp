<%--
  20252377 양효재
  부분 구현된 주문 관리 기능이 남아 있어서 개선 진행하였다.
  회원 상세 안에만 있던 주문 조회를 관리자 전용 목록으로 분리해서,
  주문 상태와 취소 환불 건을 한 화면에서 보도록 정리했다.
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

    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null || loginId.isBlank()) {
        loginId = "admin";
    }
    Date loginAt = (Date) session.getAttribute("loginAt");
    String loginAtStr = loginAt != null
            ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt)
            : "-";
    String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());

    OrderService orderService = new OrderService();
    List<OrderDto> orders = orderService.getAllOrders();

    int paidCount = 0;
    int shippingCount = 0;
    int cancelRefundCount = 0;

    for (OrderDto order : orders) {
        String status = order.getStatus();
        if ("결제완료".equals(status) || "배송준비중".equals(status) || "상품준비중".equals(status)) {
            paidCount++;
        }
        if ("배송중".equals(status) || "배송완료".equals(status)) {
            shippingCount++;
        }
        if ("취소요청".equals(status) || "주문취소".equals(status)
                || "환불요청".equals(status) || "환불완료".equals(status)) {
            cancelRefundCount++;
        }
    }

    DateTimeFormatter orderDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 관리 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
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
            <a href="<%= contextPath %>/board/adminList.jsp" class="nav-item"><span class="nav-icon">💬</span> 문의글 관리</a>
            <a href="<%= contextPath %>/notice/list.jsp" class="nav-item"><span class="nav-icon">📢</span> 공지사항 관리</a>
        </div>
    </nav>

    <div class="dash-sidebar-foot">
        © 2026 SHOPMALL ADMIN
    </div>
</aside>

<main class="dash-main">
    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>주문 관리</h1>
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

    <section class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">전체 주문</span><span class="kpi-icon orders">🛒</span></div>
            <div class="kpi-value"><%= orders.size() %> <small>건</small></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">처리 대기</span><span class="kpi-icon sales">📦</span></div>
            <div class="kpi-value"><%= paidCount %> <small>건</small></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">배송 진행</span><span class="kpi-icon members">🚚</span></div>
            <div class="kpi-value"><%= shippingCount %> <small>건</small></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">취소/환불</span><span class="kpi-icon stock">↩</span></div>
            <div class="kpi-value alert"><%= cancelRefundCount %> <small>건</small></div>
        </div>
    </section>

    <section class="dash-panel">
        <div class="panel-head">
            <h3>주문 목록 <span class="panel-sub">ORDERS</span></h3>
        </div>

        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                <tr>
                    <th>주문번호</th>
                    <th>주문자</th>
                    <th>상품명</th>
                    <th class="num">금액</th>
                    <th class="num">수량</th>
                    <th>주문일시</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <% if (orders.isEmpty()) { %>
                <tr>
                    <td colspan="8" style="text-align:center; padding:32px; color:#9ca3af;">
                        등록된 주문 데이터가 없습니다.
                    </td>
                </tr>
                <% } else { %>
                <% for (OrderDto order : orders) { %>
                <tr>
                    <td><code><%= order.getOrderNumber() %></code></td>
                    <td><%= order.getMemberId() != null ? order.getMemberId() : "-" %></td>
                    <td><%= order.getProductName() != null ? order.getProductName() : "-" %></td>
                    <td class="num"><%= String.format("%,d", order.getPrice()) %>원</td>
                    <td class="num"><%= order.getQuantity() %></td>
                    <td><%= order.getOrderDate() != null ? order.getOrderDate().format(orderDateFormatter) : "-" %></td>
                    <td><%= order.getStatus() %></td>
                    <td>
                        <a href="<%= contextPath %>/order/view.jsp?orderId=<%= order.getOrderId() %>">상세보기</a>
                    </td>
                </tr>
                <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
