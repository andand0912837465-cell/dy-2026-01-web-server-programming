<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.purchase.PurchaseStatsService" %>
<%@ page import="kr.ac.dy.cs.purchase.SalesSummaryDto" %>
<%@ page import="kr.ac.dy.cs.purchase.DailySalesDto" %>
<%@ page import="kr.ac.dy.cs.purchase.MonthlySalesDto" %>
<%@ page import="kr.ac.dy.cs.purchase.ProductSalesDto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String loginId = (String) session.getAttribute("loginId");
    Date loginAt = (Date) session.getAttribute("loginAt");
    String loginAtStr = loginAt != null
            ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt)
            : "-";
    String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());

    PurchaseStatsService statsService = new PurchaseStatsService();
    SalesSummaryDto summary = statsService.getSummary();
    List<MonthlySalesDto> monthlySales = statsService.getMonthlySales();
    List<DailySalesDto> dailySales = statsService.getDailySales();
    List<ProductSalesDto> productSales = statsService.getProductSales();

    long monthlyMax = 1;
    for (MonthlySalesDto m : monthlySales) monthlyMax = Math.max(monthlyMax, m.getTotalAmount());
    long dailyMax = 1;
    for (DailySalesDto d : dailySales) dailyMax = Math.max(dailyMax, d.getTotalAmount());
    long productMax = 1;
    for (ProductSalesDto p : productSales) productMax = Math.max(productMax, p.getTotalAmount());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>매출 통계 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="/css/main.css">
    <style>
        .stat-bar-track { background:#f1f5f9; border-radius:6px; height:10px; overflow:hidden; }
        .stat-bar-fill { background:#4f46e5; height:100%; border-radius:6px; }
        .num { text-align:right; }
    </style>
</head>
<body class="dashboard-page">

<aside class="dash-sidebar">
    <div class="dash-logo">
        <a href="/dashboard/index.jsp">SHOP<span>MALL</span></a>
        <div class="dash-logo-sub">ADMIN CONSOLE</div>
    </div>
    <nav class="dash-nav">
        <div class="nav-group">
            <div class="nav-group-title">MAIN</div>
            <a href="/dashboard/index.jsp" class="nav-item"><span class="nav-icon">▦</span> 대시보드</a>
        </div>
        <div class="nav-group">
            <div class="nav-group-title">운영</div>
            <a href="#" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🛒</span> 주문 관리</a>
            <a href="/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
            <a href="/notice/list.jsp" class="nav-item"><span class="nav-icon">📢</span> 공지사항 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🎁</span> 프로모션</a>
        </div>
        <div class="nav-group">
            <div class="nav-group-title">분석</div>
            <a href="/stats/sales.jsp" class="nav-item active"><span class="nav-icon">📊</span> 매출 통계</a>
            <a href="/stats/visitor.jsp" class="nav-item"><span class="nav-icon">📈</span> 방문자 분석</a>
        </div>
        <div class="nav-group">
            <div class="nav-group-title">시스템</div>
            <a href="/adminUser/register.jsp" class="nav-item"><span class="nav-icon">⚙</span> 관리자 등록</a>
            <a href="#" class="nav-item"><span class="nav-icon">🔧</span> 시스템 설정</a>
        </div>
    </nav>
    <div class="dash-sidebar-foot">© 2026 SHOPMALL ADMIN</div>
</aside>

<main class="dash-main">

    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>매출 통계</h1>
            <p><%= nowStr %></p>
        </div>
        <div class="dash-user">
            <div class="dash-user-info">
                <span class="dash-user-id"><strong><%= loginId %></strong>님</span>
                <span class="dash-user-meta">최근 로그인: <%= loginAtStr %></span>
            </div>
            <div class="dash-user-avatar"><%= loginId.substring(0, 1).toUpperCase() %></div>
            <a href="/auth/adminLogout.jsp" class="dash-logout">로그아웃</a>
        </div>
    </header>

    <!-- KPI -->
    <section class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">총 매출</span><span class="kpi-icon sales">💰</span></div>
            <div class="kpi-value">₩ <%= String.format("%,d", summary.getTotalAmount()) %></div>
            <div class="kpi-trend">전체 누적</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">구매 건수</span><span class="kpi-icon orders">🛒</span></div>
            <div class="kpi-value"><%= String.format("%,d", summary.getPurchaseCount()) %> <small>건</small></div>
            <div class="kpi-trend">총 판매 수량 <%= String.format("%,d", summary.getTotalQuantity()) %>개</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">평균 구매 금액</span><span class="kpi-icon stock">📊</span></div>
            <div class="kpi-value">₩ <%= String.format("%,d", summary.getAvgAmount()) %></div>
            <div class="kpi-trend">건당 평균</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">총 판매 수량</span><span class="kpi-icon members">📦</span></div>
            <div class="kpi-value"><%= String.format("%,d", summary.getTotalQuantity()) %> <small>개</small></div>
            <div class="kpi-trend">전체 누적</div>
        </div>
    </section>

    <!-- 월별 매출 -->
    <section class="dash-panel">
        <div class="panel-head"><h3>월별 매출</h3></div>
        <div class="chart-wrap">
            <div class="chart-bars">
                <% if (monthlySales.isEmpty()) { %>
                    <p style="color:#9ca3af; padding:24px;">데이터가 없습니다.</p>
                <% } else { for (MonthlySalesDto m : monthlySales) {
                    int h = (int) Math.max(4, m.getTotalAmount() * 100 / monthlyMax); %>
                    <div class="bar-col">
                        <span class="bar" style="height: <%= h %>%" title="₩ <%= String.format("%,d", m.getTotalAmount()) %>"></span>
                        <label><%= m.getMonth() %></label>
                    </div>
                <% } } %>
            </div>
        </div>
    </section>

    <!-- 일별 매출 -->
    <section class="dash-panel">
        <div class="panel-head"><h3>일별 매출 <span class="panel-sub">총 <%= dailySales.size() %>일</span></h3></div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                    <tr>
                        <th style="width:140px;">날짜</th>
                        <th>매출 분포</th>
                        <th class="num" style="width:140px;">매출액</th>
                        <th class="num" style="width:100px;">건수</th>
                    </tr>
                </thead>
                <tbody>
                <% if (dailySales.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align:center; padding:32px; color:#9ca3af;">데이터가 없습니다.</td></tr>
                <% } else { for (DailySalesDto d : dailySales) {
                    int w = (int) Math.max(2, d.getTotalAmount() * 100 / dailyMax); %>
                    <tr>
                        <td><%= d.getDate() %></td>
                        <td><div class="stat-bar-track"><div class="stat-bar-fill" style="width: <%= w %>%"></div></div></td>
                        <td class="num">₩ <%= String.format("%,d", d.getTotalAmount()) %></td>
                        <td class="num"><%= d.getCount() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- 상품별 매출 / 판매 수량 -->
    <section class="dash-panel">
        <div class="panel-head"><h3>상품별 매출 / 판매 수량</h3></div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>매출 분포</th>
                        <th class="num" style="width:140px;">매출액</th>
                        <th class="num" style="width:120px;">판매 수량</th>
                        <th class="num" style="width:100px;">구매 건수</th>
                    </tr>
                </thead>
                <tbody>
                <% if (productSales.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center; padding:32px; color:#9ca3af;">데이터가 없습니다.</td></tr>
                <% } else { for (ProductSalesDto p : productSales) {
                    int w = (int) Math.max(2, p.getTotalAmount() * 100 / productMax); %>
                    <tr>
                        <td style="text-align:left;"><%= p.getProductName() %></td>
                        <td><div class="stat-bar-track"><div class="stat-bar-fill" style="width: <%= w %>%"></div></div></td>
                        <td class="num">₩ <%= String.format("%,d", p.getTotalAmount()) %></td>
                        <td class="num"><%= String.format("%,d", p.getQuantity()) %>개</td>
                        <td class="num"><%= p.getCount() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </section>

</main>

</body>
</html>
