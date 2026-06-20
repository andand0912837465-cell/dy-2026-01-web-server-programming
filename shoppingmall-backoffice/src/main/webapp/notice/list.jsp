<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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

    NoticeService noticeService = new NoticeService();
    List<NoticeDto> notices = noticeService.getNotices();
    int totalCount = notices != null ? notices.size() : 0;

    DateTimeFormatter regDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body class="dashboard-page">

<!-- ===== 좌측 사이드바 ===== -->
<aside class="dash-sidebar">
    <div class="dash-logo">
        <a href="/dashboard/index.jsp">SHOP<span>MALL</span></a>
        <div class="dash-logo-sub">ADMIN CONSOLE</div>
    </div>

    <nav class="dash-nav">
        <div class="nav-group">
            <div class="nav-group-title">MAIN</div>
            <a href="/dashboard/index.jsp" class="nav-item">
                <span class="nav-icon">▦</span> 대시보드
            </a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">운영</div>
            <a href="#" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🛒</span> 주문 관리</a>
            <a href="/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
            <a href="/notice/list.jsp" class="nav-item active"><span class="nav-icon">📢</span> 공지사항 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🎁</span> 프로모션</a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">분석</div>
            <a href="#" class="nav-item"><span class="nav-icon">📊</span> 매출 통계</a>
            <a href="#" class="nav-item"><span class="nav-icon">📈</span> 방문자 분석</a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">시스템</div>
            <a href="/adminUser/register.jsp" class="nav-item"><span class="nav-icon">⚙</span> 관리자 등록</a>
            <a href="#" class="nav-item"><span class="nav-icon">🔧</span> 시스템 설정</a>
        </div>
    </nav>

    <div class="dash-sidebar-foot">
        © 2026 SHOPMALL ADMIN
    </div>
</aside>

<!-- ===== 메인 영역 ===== -->
<main class="dash-main">

    <!-- 상단 바 -->
    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>공지사항 관리</h1>
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

    <!-- 공지사항 목록 테이블 -->
    <section class="dash-panel">
        <div class="panel-head" style="display: flex; justify-content: space-between; align-items: center;">
            <h3>공지사항 목록 <span class="panel-sub">총 <%= totalCount %>건</span></h3>
            <a href="/notice/register.jsp" class="btn btn-primary" style="text-decoration: none; padding: 8px 16px; background: #4f46e5; color: white; border-radius: 4px; font-size: 14px;">신규 등록</a>
        </div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th>제목</th>
                        <th style="width: 120px;">작성자</th>
                        <th style="width: 180px;">작성일시</th>
                        <th style="width: 100px;">관리</th>
                    </tr>
                </thead>
                <tbody>
                <% if (totalCount == 0) { %>
                    <tr>
                        <td colspan="5" style="text-align:center; padding: 32px; color:#9ca3af;">
                            등록된 공지사항이 없습니다.
                        </td>
                    </tr>
                <% } else { %>
                    <% for (NoticeDto n : notices) { %>
                    <tr>
                        <td><%= n.getId() %></td>
                        <td style="text-align: left;"><a href="/notice/view.jsp?id=<%= n.getId() %>" style="color: inherit; text-decoration: none;"><%= n.getTitle() %></a></td>
                        <td><%= n.getWriter() %></td>
                        <td><%= n.getRegDate() != null ? n.getRegDate().format(regDateFormatter) : "-" %></td>
                        <td>
                            <a href="/notice/edit.jsp?id=<%= n.getId() %>" style="color: #4f46e5; font-size: 13px;">수정</a>
                            <span style="color: #e5e7eb; margin: 0 4px;">|</span>
                            <form action="/notice/delete.jsp" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <input type="hidden" name="id" value="<%= n.getId() %>">
                                <button type="submit" style="border:0; background:none; padding:0; color:#ef4444; font-size:13px; cursor:pointer;">삭제</button>
                            </form>
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
