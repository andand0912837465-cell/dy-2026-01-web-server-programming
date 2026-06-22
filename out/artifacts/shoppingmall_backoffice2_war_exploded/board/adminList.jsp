<%--
 * 20252374 최은교
 * 백오피스 관리자 전용 1:1 문의글 목록 조회 웹 화면 페이지임[cite: 1].
 * 데이터베이스에 누적된 전체 고객의 문의 내역을 최신 접수순으로 정렬하여 리스트 형태로 일목요연하게 출력하는 기능을 제공한다[cite: 6, 20].
 * 추가로, 각 문의글의 카테고리, 작성자 ID, 접수일시와 함께 현재 처리상태(답변대기/답변완료)를 배지로 시각화하여 모니터링하기 쉽게 돕는 기능을 제공한다[cite: 20, 26].
 * 상세로는 문의 제목 클릭 시 해당 글의 고유 번호(boardNo) 파라미터를 들고 상세 답변 페이지(adminView.jsp)로 안전하게 화면 이동하는 링크 기능을 제공한다[cite: 27].
 * 세션 검증을 수행하여 비로그인 접근 시 로그인 폼으로 강제 튕겨내는 관리자 보안 인증 기능을 제공한다[cite: 1, 2].
 *
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.board.BoardService" %>
<%@ page import="kr.ac.dy.cs.board.BoardDto" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // 대시보드와 동일한 로그인 및 세션 검증
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

    // DB에서 전체 문의 데이터 로드
    BoardService boardService = new BoardService();
    List<BoardDto> allBoardList = boardService.getAllQuestions();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>문의글 관리 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="/css/main.css">
    <style>
        /* 대시보드 main.css 위에 테이블 및 배지 커스텀 스타일 레이어링 */
        .board-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; text-align: center; }
        .board-badge.waiting { background-color: #fff1f2; color: #f43f5e; }  /* 연한 핑크에 빨간 글씨 */
        .board-badge.complete { background-color: #f0fdf4; color: #16a34a; } /* 연한 그린에 초록 글씨 */
        .title-link { text-decoration: none; color: #334155; font-weight: 500; }
        .title-link:hover { color: #7c5cfc; text-decoration: underline; }
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
            <a href="/dashboard/index.jsp" class="nav-item">
                <span class="nav-icon">▦</span> 대시보드
            </a>
        </div>

        <div class="nav-group">
            <div class="nav-group-title">운영</div>
            <a href="/product/list.jsp" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🛒</span> 주문 관리</a>
            <a href="/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
            <a href="/board/adminList.jsp" class="nav-item active"><span class="nav-icon">💬</span> 문의글 관리</a>
            <a href="/notice/list.jsp" class="nav-item"><span class="nav-icon">📢</span> 공지사항 관리</a>
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

<main class="dash-main">

    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>문의글 관리</h1>
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

    <section class="dash-panel" style="margin-top: 20px;">
        <div class="panel-head">
            <h3>고객 1:1 문의 접수 현황</h3>
        </div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                <tr>
                    <th>번호</th>
                    <th>처리상태</th>
                    <th>문의분류</th>
                    <th>문의 제목 (클릭 시 상세보기 및 답변 가능)</th>
                    <th>작성자 ID</th>
                    <th>접수일시</th>
                </tr>
                </thead>
                <tbody>
                <% if (allBoardList == null || allBoardList.isEmpty()) { %>
                <tr>
                    <td colspan="6" style="padding: 40px; text-align: center; color: #a4b0be;">현재 접수된 고객 문의가 없습니다.</td>
                </tr>
                <% } else { %>
                <%
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    for (BoardDto board : allBoardList) {
                        // LocalDateTime을 Date로 변경하여 포맷팅
                        java.util.Date regDate = java.sql.Timestamp.valueOf(board.getRegDate());
                        String regDateStr = df.format(regDate);
                %>
                <tr>
                    <td><code>#<%= board.getBoardNo() %></code></td>
                    <td>
                        <% if ("답변대기".equals(board.getStatus())) { %>
                        <span class="board-badge waiting">답변대기</span>
                        <% } else { %>
                        <span class="board-badge complete">답변완료</span>
                        <% } %>
                    </td>
                    <td><strong style="color: #4f46e5;">[<%= board.getCategory() %>]</strong></td>
                    <td style="text-align: left;">
                        <a href="adminView.jsp?boardNo=<%= board.getBoardNo() %>" class="title-link">
                            <%= board.getTitle() %>
                        </a>
                    </td>
                    <td><code><%= board.getUserId() %></code></td>
                    <td style="color: #64748b;"><%= regDateStr %></td>
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
