<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 등록 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body class="login-page">

<!-- 좌측 브랜드 패널 -->
<aside class="brand-panel" style="--bg: url('https://picsum.photos/seed/register-side/900/1200');">
    <a href="/index.jsp" class="top-logo">SHOP<span>MALL</span></a>
    <div class="lead">
        <div class="eyebrow">ADMIN ACCOUNT</div>
        <h1>관리자 계정을 등록하고<br>운영 업무를 시작하세요.</h1>
        <p>쇼핑몰 운영자는 등록된 관리자 계정으로<br>백오피스에 로그인할 수 있습니다.</p>
    </div>
    <div class="foot">© 2026 SHOPMALL. All rights reserved.</div>
</aside>

<!-- 우측 폼 패널 -->
<main class="form-panel">
<div class="login-card">

    <div class="brand">
        <div class="welcome">ADMIN SIGN UP</div>
        <div class="title">관리자 등록</div>
    </div>

    <form method="post" action="registerSubmit.jsp">

        <div class="form-group">
            <label for="userId">아이디</label>
            <input type="text" id="userId" name="userId"
                   placeholder="관리자 아이디를 입력해 주세요" required/>
        </div>

        <div class="form-group">
            <label for="userName">이름</label>
            <input type="text" id="userName" name="userName"
                   placeholder="관리자 이름을 입력해 주세요" required/>
        </div>

        <div class="form-group">
            <label for="userEmail">이메일</label>
            <input type="email" id="userEmail" name="email"
                   placeholder="이메일을 입력해 주세요" required/>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password"
                   placeholder="비밀번호를 입력해 주세요" required/>
        </div>

        <button type="submit" class="btn-login">관리자 등록</button>

    </form>

    <div class="signup-area">
        이미 관리자 계정이 있으신가요?
        <a href="/auth/adminLogin.jsp">로그인</a>
    </div>

</div>
</main>

</body>
</html>