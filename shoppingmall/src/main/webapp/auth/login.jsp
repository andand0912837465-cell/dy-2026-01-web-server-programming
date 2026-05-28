<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - SHOPMALL</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body class="login-page">

<!-- 좌측 브랜드 패널 -->
<aside class="brand-panel" style="--bg: url('https://picsum.photos/seed/login-side/900/1200');">
    <a href="/index.jsp" class="top-logo">SHOP<span>MALL</span></a>
    <div class="lead">
        <div class="eyebrow">WELCOME BACK</div>
        <h1>오늘도 SHOPMALL과<br>함께해 주세요.</h1>
        <p>로그인하시면 회원 전용 혜택, 적립금, 맞춤 추천 상품을<br>편리하게 이용하실 수 있습니다.</p>
    </div>
    <div class="foot">© 2026 SHOPMALL. All rights reserved.</div>
</aside>

<!-- 우측 폼 패널 -->
<main class="form-panel">
<div class="login-card">

    <div class="brand">
        <div class="welcome">SIGN IN</div>
        <div class="title">로그인</div>
    </div>

    <form method="post" action="loginSubmit.jsp">

        <div class="form-group">
            <label for="loginId">아이디</label>
            <input type="text" name="loginId" id="loginId"
                   value="<%=loginId%>"
                   minlength="5"
                   required placeholder="아이디를 입력해 주세요"/>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" name="password" id="password"
                   required placeholder="비밀번호를 입력해 주세요"/>
        </div>

        <div class="form-options">
            <label class="save-id" for="saveIdYn">
                <input type="checkbox" <%=checked%>
                       name="saveIdYn" id="saveIdYn" value="1"/>
                아이디 저장
            </label>
            <div class="links">
                <a href="#">아이디 찾기</a>
                <span>|</span>
                <a href="#">비밀번호 찾기</a>
            </div>
        </div>

        <button type="submit" class="btn-login">로그인</button>

    </form>

    <div class="divider"><span>또는 SNS 계정으로 로그인</span></div>

    <div class="social-login">
        <button type="button" class="social-btn kakao">
            <span class="social-icon">K</span>카카오
        </button>
        <button type="button" class="social-btn naver">
            <span class="social-icon">N</span>네이버
        </button>
        <button type="button" class="social-btn google">
            <span class="social-icon">G</span>구글
        </button>
    </div>

    <div class="signup-area">
        아직 회원이 아니신가요?
        <a href="/member/register.jsp">회원가입</a>
    </div>

</div>
</main>

</body>
</html>
