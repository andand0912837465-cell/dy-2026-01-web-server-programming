<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="kr.ac.dy.cs.visitor.VisitorStatsService" %>
<%@ page import="kr.ac.dy.cs.visitor.VisitorSummaryDto" %>
<%@ page import="kr.ac.dy.cs.visitor.DailyVisitDto" %>
<%@ page import="kr.ac.dy.cs.visitor.ProductVisitDto" %>
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

    VisitorStatsService statsService = new VisitorStatsService();
    VisitorSummaryDto summary = statsService.getSummary();
    List<DailyVisitDto> dailyVisits = statsService.getDailyVisits();
    List<ProductVisitDto> productVisits = statsService.getProductVisits();

    long dailyMax = 1;
    for (DailyVisitDto d : dailyVisits) dailyMax = Math.max(dailyMax, d.getVisits());
    long productMax = 1;
    for (ProductVisitDto p : productVisits) productMax = Math.max(productMax, p.getVisits());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>방문자 분석 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="/css/main.css">
    <style>
        .stat-bar-track { background:#f1f5f9; border-radius:6px; height:10px; overflow:hidden; }
        .stat-bar-fill { background:#0ea5e9; height:100%; border-radius:6px; }
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
            <a href="/stats/sales.jsp" class="nav-item"><span class="nav-icon">📊</span> 매출 통계</a>
            <a href="/stats/visitor.jsp" class="nav-item active"><span class="nav-icon">📈</span> 방문자 분석</a>
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
            <h1>방문자 분석</h1>
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
            <div class="kpi-head"><span class="kpi-label">총 방문 수</span><span class="kpi-icon orders">👣</span></div>
            <div class="kpi-value"><%= String.format("%,d", summary.getTotalVisits()) %> <small>회</small></div>
            <div class="kpi-trend">상품 상세 페이지 방문</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">UV (순 방문자)</span><span class="kpi-icon members">👥</span></div>
            <div class="kpi-value"><%= String.format("%,d", summary.getUniqueVisitors()) %> <small>명</small></div>
            <div class="kpi-trend">Unique Visitor</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">구매 건수</span><span class="kpi-icon sales">🛒</span></div>
            <div class="kpi-value"><%= String.format("%,d", summary.getPurchaseCount()) %> <small>건</small></div>
            <div class="kpi-trend">전환된 구매</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head"><span class="kpi-label">구매 전환율</span><span class="kpi-icon stock">📈</span></div>
            <div class="kpi-value"><%= String.format("%.1f", summary.getConversionRate()) %> <small>%</small></div>
            <div class="kpi-trend">방문 대비 구매</div>
        </div>
    </section>

    <!-- 일별 방문 수 -->
    <section class="dash-panel">
        <div class="panel-head"><h3>일별 방문 수</h3></div>
        <div class="chart-wrap">
            <div class="chart-bars">
                <% if (dailyVisits.isEmpty()) { %>
                    <p style="color:#9ca3af; padding:24px;">데이터가 없습니다.</p>
                <% } else { for (DailyVisitDto d : dailyVisits) {
                    int h = (int) Math.max(4, d.getVisits() * 100 / dailyMax); %>
                    <div class="bar-col">
                        <span class="bar primary" style="height: <%= h %>%" title="<%= d.getVisits() %>회 / UV <%= d.getUniqueVisitors() %>"></span>
                        <label><%= d.getDate().substring(5) %></label>
                    </div>
                <% } } %>
            </div>
        </div>
    </section>

    <!-- 상품별 방문 수 -->
    <section class="dash-panel">
        <div class="panel-head"><h3>상품별 방문 수</h3></div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>방문 분포</th>
                        <th class="num" style="width:120px;">방문 수</th>
                        <th class="num" style="width:120px;">UV</th>
                    </tr>
                </thead>
                <tbody>
                <% if (productVisits.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align:center; padding:32px; color:#9ca3af;">데이터가 없습니다.</td></tr>
                <% } else { for (ProductVisitDto p : productVisits) {
                    int w = (int) Math.max(2, p.getVisits() * 100 / productMax); %>
                    <tr>
                        <td style="text-align:left;"><%= p.getProductName() %></td>
                        <td><div class="stat-bar-track"><div class="stat-bar-fill" style="width: <%= w %>%"></div></div></td>
                        <td class="num"><%= p.getVisits() %></td>
                        <td class="num"><%= p.getUniqueVisitors() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </section>

</main>

</body>
</html>
