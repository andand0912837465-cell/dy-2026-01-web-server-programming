<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeService noticeService = new NoticeService();
    NoticeDto notice = noticeService.getNotice(id);

    if (notice == null) {
%>
    <script>
        alert('존재하지 않는 게시물입니다.');
        location.href = '/notice/list.jsp';
    </script>
<%
        return;
    }

    String loginId = (String) session.getAttribute("loginId");
    Date loginAt = (Date) session.getAttribute("loginAt");
    String loginAtStr = loginAt != null
            ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt)
            : "-";
    String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세 - SHOPMALL ADMIN</title>
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
            <a href="/product/list.jsp" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
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
            <h1>공지사항 상세</h1>
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

    <!-- 공지사항 상세 내용 -->
    <section class="dash-panel">
        <div class="panel-head">
            <h3><%= notice.getTitle() %></h3>
        </div>
        <div class="panel-body" style="padding: 24px;">
            <div style="margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #f3f4f6; color: #6b7280; font-size: 14px;">
                작성자: <strong><%= notice.getWriter() %></strong> | 
                작성일: <%= notice.getRegDate().format(formatter) %> | 
                수정일: <%= notice.getModDate().format(formatter) %>
            </div>
            <div style="min-height: 300px; line-height: 1.6; white-space: pre-wrap; font-size: 15px; margin-bottom: 30px;">
<%= notice.getContent() %>
            </div>
            
            <% if (notice.getFileName() != null) { %>
            <div style="padding: 15px; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 4px; margin-bottom: 20px;">
                <span style="font-weight: 600; margin-right: 10px;">첨부파일:</span>
                <a href="/notice/download.jsp?id=<%= notice.getId() %>" style="color: #4f46e5; text-decoration: underline;">
                    <%= notice.getFileOriginName() %>
                </a>
            </div>
            <% } %>

            <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 32px; padding-top: 24px; border-top: 1px solid #f3f4f6;">
                <a href="/notice/list.jsp" style="text-decoration: none; padding: 10px 20px; background: #9ca3af; color: white; border-radius: 4px;">목록으로</a>
                <a href="/notice/edit.jsp?id=<%= notice.getId() %>" style="text-decoration: none; padding: 10px 20px; background: #4f46e5; color: white; border-radius: 4px;">수정하기</a>
                <form action="/notice/delete.jsp" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="id" value="<%= notice.getId() %>">
                    <button type="submit" style="border:0; padding:10px 20px; background:#ef4444; color:white; border-radius:4px; cursor:pointer;">삭제하기</button>
                </form>
            </div>
        </div>
    </section>

</main>

</body>
</html>
