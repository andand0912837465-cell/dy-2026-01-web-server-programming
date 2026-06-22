<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>대시보드 - SHOPMALL ADMIN</title>
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
            <a href="/dashboard/index.jsp" class="nav-item active">
                <span class="nav-icon">▦</span> 대시보드
            </a>
        </div>

        <!-- 문의글 관리용 -->
        <div class="nav-group">
            <div class="nav-group-title">운영</div>
            <a href="/product/list.jsp" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
            <a href="#" class="nav-item"><span class="nav-icon">🛒</span> 주문 관리</a>
            <a href="/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
            <a href="/board/adminList.jsp" class="nav-item"><span class="nav-icon">💬</span> 문의글 관리</a>
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

<!-- ===== 메인 영역 ===== -->
<main class="dash-main">

    <!-- 상단 바 -->
    <header class="dash-topbar">
        <div class="dash-page-title">
            <h1>대시보드</h1>
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

    <!-- 환영 배너 -->
    <section class="dash-welcome">
        <div>
            <span class="welcome-eyebrow">WELCOME BACK</span>
            <h2><%= loginId %>님, 오늘도 좋은 하루 되세요. 👋</h2>
            <p>오늘 SHOPMALL에서 일어나는 일들을 한눈에 확인하실 수 있습니다.</p>
        </div>
        <div class="dash-welcome-actions">
            <a href="/product/list.jsp" class="btn-primary">상품 관리로 이동</a>
            <a href="#" class="btn-secondary">주문 처리하기</a>
        </div>
    </section>

    <!-- KPI 카드 -->
    <section class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-head">
                <span class="kpi-label">오늘의 주문</span>
                <span class="kpi-icon orders">🛒</span>
            </div>
            <div class="kpi-value">128 <small>건</small></div>
            <div class="kpi-trend up">▲ 12.4% (어제 대비)</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head">
                <span class="kpi-label">금일 매출</span>
                <span class="kpi-icon sales">💰</span>
            </div>
            <div class="kpi-value">₩ 4,820,000</div>
            <div class="kpi-trend up">▲ 8.1% (어제 대비)</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head">
                <span class="kpi-label">신규 회원</span>
                <span class="kpi-icon members">👥</span>
            </div>
            <div class="kpi-value">37 <small>명</small></div>
            <div class="kpi-trend down">▼ 3.2% (어제 대비)</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-head">
                <span class="kpi-label">재고 부족</span>
                <span class="kpi-icon stock">⚠</span>
            </div>
            <div class="kpi-value alert">12 <small>종</small></div>
            <div class="kpi-trend warn">조치 필요</div>
        </div>
    </section>

    <!-- 차트 + 최근 주문 -->
    <section class="dash-grid">

        <!-- 매출 차트 -->
        <div class="dash-panel">
            <div class="panel-head">
                <h3>주간 매출 추이</h3>
                <div class="panel-actions">
                    <button class="chip active">주간</button>
                    <button class="chip">월간</button>
                    <button class="chip">연간</button>
                </div>
            </div>
            <div class="chart-wrap">
                <div class="chart-bars">
                    <div class="bar-col"><span class="bar" style="height: 45%"></span><label>월</label></div>
                    <div class="bar-col"><span class="bar" style="height: 65%"></span><label>화</label></div>
                    <div class="bar-col"><span class="bar" style="height: 55%"></span><label>수</label></div>
                    <div class="bar-col"><span class="bar" style="height: 80%"></span><label>목</label></div>
                    <div class="bar-col"><span class="bar" style="height: 70%"></span><label>금</label></div>
                    <div class="bar-col"><span class="bar primary" style="height: 95%"></span><label>토</label></div>
                    <div class="bar-col"><span class="bar" style="height: 60%"></span><label>일</label></div>
                </div>
                <div class="chart-summary">
                    <div><span>주간 총매출</span><strong>₩ 28,490,000</strong></div>
                    <div><span>일 평균</span><strong>₩ 4,070,000</strong></div>
                    <div><span>최고 매출일</span><strong>토요일</strong></div>
                </div>
            </div>
        </div>

        <!-- 빠른 통계 -->
        <div class="dash-panel">
            <div class="panel-head">
                <h3>방문자 현황</h3>
                <span class="panel-sub">실시간</span>
            </div>
            <div class="visitor-now">
                <div class="visitor-num">324</div>
                <div class="visitor-label">현재 접속 중</div>
            </div>
            <div class="visitor-stats">
                <div class="vs-row">
                    <span>오늘 방문자</span>
                    <strong>2,847 명</strong>
                </div>
                <div class="vs-row">
                    <span>회원 비율</span>
                    <strong>62.4%</strong>
                </div>
                <div class="vs-row">
                    <span>평균 체류 시간</span>
                    <strong>4분 32초</strong>
                </div>
                <div class="vs-row">
                    <span>이탈률</span>
                    <strong>28.1%</strong>
                </div>
            </div>
        </div>
    </section>

    <!-- 최근 주문 테이블 -->
    <section class="dash-panel">
        <div class="panel-head">
            <h3>최근 주문</h3>
            <a href="#" class="panel-link">전체 보기 →</a>
        </div>
        <div class="table-wrap">
            <table class="dash-table">
                <thead>
                    <tr>
                        <th>주문번호</th>
                        <th>주문자</th>
                        <th>상품</th>
                        <th class="num">금액</th>
                        <th>주문일시</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>#20260529-1284</code></td>
                        <td>김민준</td>
                        <td>오버사이즈 니트 외 2건</td>
                        <td class="num">₩ 128,000</td>
                        <td>2026-05-29 14:22</td>
                        <td><span class="status status-paid">결제완료</span></td>
                    </tr>
                    <tr>
                        <td><code>#20260529-1283</code></td>
                        <td>이서윤</td>
                        <td>데일리 슬랙스</td>
                        <td class="num">₩ 49,000</td>
                        <td>2026-05-29 14:08</td>
                        <td><span class="status status-shipping">배송중</span></td>
                    </tr>
                    <tr>
                        <td><code>#20260529-1282</code></td>
                        <td>박지호</td>
                        <td>레더 크로스백</td>
                        <td class="num">₩ 215,000</td>
                        <td>2026-05-29 13:55</td>
                        <td><span class="status status-paid">결제완료</span></td>
                    </tr>
                    <tr>
                        <td><code>#20260529-1281</code></td>
                        <td>최예린</td>
                        <td>여름 원피스 외 1건</td>
                        <td class="num">₩ 86,500</td>
                        <td>2026-05-29 13:41</td>
                        <td><span class="status status-done">배송완료</span></td>
                    </tr>
                    <tr>
                        <td><code>#20260529-1280</code></td>
                        <td>정우진</td>
                        <td>스니커즈</td>
                        <td class="num">₩ 132,000</td>
                        <td>2026-05-29 13:20</td>
                        <td><span class="status status-cancel">주문취소</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>

</main>

</body>
</html>
