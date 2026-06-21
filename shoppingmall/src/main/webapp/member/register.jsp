<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입 - SHOPMALL</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body class="login-page">

<!-- 좌측 브랜드 패널 -->
<aside class="brand-panel" style="--bg: url('https://picsum.photos/seed/register-side/900/1200');">
    <a href="/index.jsp" class="top-logo">SHOP<span>MALL</span></a>
    <div class="lead">
        <div class="eyebrow">JOIN US</div>
        <h1>지금 가입하고<br>특별한 혜택을 만나보세요.</h1>
        <p>신규 회원에게 드리는 5,000원 할인 쿠폰과 다양한<br>적립금 혜택이 기다리고 있습니다.</p>
    </div>
    <div class="foot">© 2026 SHOPMALL. All rights reserved.</div>
</aside>

<!-- 우측 폼 패널 -->
<main class="form-panel">
<div class="login-card">

    <div class="brand">
        <div class="welcome">SIGN UP</div>
        <div class="title">회원가입</div>
    </div>

    <form method="post" action="registerSubmit.jsp">

        <div class="form-group">
            <label for="userId">아이디</label>
            <input type="text" id="userId" name="userId" minlength="5"
                   placeholder="아이디를 입력해 주세요" required/>
        </div>

        <div class="form-group">
            <label for="userName">이름</label>
            <input type="text" id="userName" name="userName"
                   placeholder="이름을 입력해 주세요" required/>
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

        <button type="submit" class="btn-login">회원가입</button>

    </form>

    <div class="signup-area">
        이미 계정이 있으신가요?
        <a href="/auth/login.jsp">로그인</a>
    </div>

</div>
</main>

</body>
</html>