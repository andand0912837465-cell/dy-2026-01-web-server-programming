<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    if (SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/dashboard/index.jsp");
        return;
    }

    String loginId = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("saveId".equals(cookie.getName())) {
                loginId = cookie.getValue();
                break;
            }
        }
    }

    String checked = (loginId != null && loginId.length() > 0) ? "checked" : "";

    String clientIp = request.getHeader("X-Forwarded-For");
    if (clientIp == null || clientIp.isEmpty()) {
        clientIp = request.getRemoteAddr();
    }

    boolean hasError = "1".equals(request.getParameter("error"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 로그인 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
</head>
<body class="login-page admin-login-page">

<!-- 좌측 브랜드 패널 -->
<aside class="brand-panel admin-brand-panel">
    <a href="<%= contextPath %>/index.jsp" class="top-logo">SHOP<span>MALL</span> ADMIN</a>

    <div class="lead">
        <div class="admin-badge">
            <span class="badge-icon">🔒</span>
            <span>RESTRICTED ACCESS</span>
        </div>
        <h1>관리자 전용 시스템에<br>접속하고 있습니다.</h1>
        <p>본 페이지는 SHOPMALL을 운영하는 인가된 관리자만<br>이용할 수 있는 백오피스(Back-office)입니다.<br>
            관리자 계정이 없으신 경우 시스템 담당자에게 문의해 주세요.</p>

        <ul class="security-points">
            <li><span>✓</span> 모든 접속은 SSL/TLS로 암호화되어 전송됩니다.</li>
            <li><span>✓</span> 접속 IP, 시각, 활동 내역이 로그로 기록됩니다.</li>
            <li><span>✓</span> 비밀번호 5회 오류 시 계정이 일시 잠금됩니다.</li>
        </ul>
    </div>

    <div class="foot">
        © 2026 SHOPMALL ADMIN — Internal Use Only
    </div>
</aside>

<!-- 우측 폼 패널 -->
<main class="form-panel">
<div class="login-card admin-login-card">

    <div class="brand">
        <div class="admin-lock">
            <span>🛡</span>
        </div>
        <div class="welcome">ADMINISTRATOR SIGN IN</div>
        <div class="title">관리자 로그인</div>
        <div class="subtitle">발급받으신 관리자 계정으로 로그인해 주세요.</div>
    </div>

    <% if (hasError) { %>
    <div class="login-error">
        <strong>⚠ 로그인 실패</strong>
        아이디 또는 비밀번호가 올바르지 않습니다. 다시 확인해 주세요.
    </div>
    <% } %>

    <form method="post" action="<%= contextPath %>/auth/adminLoginSubmit.jsp">

        <div class="form-group">
            <label for="loginId">관리자 아이디</label>
            <input type="text" name="loginId" id="loginId"
                   value="<%=loginId%>"
                   minlength="5"
                   required placeholder="관리자 아이디를 입력해 주세요"
                   autocomplete="username"/>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" name="password" id="password"
                   required placeholder="비밀번호를 입력해 주세요"
                   autocomplete="current-password"/>
        </div>

        <div class="form-options">
            <label class="save-id" for="saveIdYn">
                <input type="checkbox" <%=checked%>
                       name="saveIdYn" id="saveIdYn" value="1"/>
                아이디 저장
            </label>
            <div class="links">
                <a href="#">비밀번호 재설정 요청</a>
            </div>
        </div>

        <button type="submit" class="btn-login admin-btn-login">
            <span>관리자 인증 후 접속하기</span>
        </button>

    </form>

    <!-- 접속 정보 -->
    <div class="access-info">
        <div class="access-row">
            <span class="access-label">접속 IP</span>
            <span class="access-value"><%=clientIp%></span>
        </div>
        <div class="access-row">
            <span class="access-label">접속 시각</span>
            <span class="access-value"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></span>
        </div>
    </div>

    <!-- 보안 안내 -->
    <div class="admin-notice">
        <strong>⚠ 보안 안내</strong>
        본 화면은 SHOPMALL의 인가된 관리자만 접근할 수 있으며,
        무단 접속 시도는 관련 법률에 따라 처벌될 수 있습니다.
        공용 PC에서는 사용 후 반드시 로그아웃해 주시기 바랍니다.
    </div>

    <div class="signup-area admin-bottom-links">
        <a href="<%= contextPath %>/index.jsp">← 메인으로 돌아가기</a>
        <span class="sep">|</span>
        <a href="mailto:admin@shopmall.example.com">시스템 담당자 문의</a>
    </div>

</div>
</main>

</body>
</html>
