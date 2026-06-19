<%--
  Created by IntelliJ IDEA.
  User: 20251250 한상호
  Date: 26. 6. 20.
  Time: 오전 2:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 - SHOPMALL ADMIN</title>
    <link rel="stylesheet" href="../css/main.css">
</head>
<body class="login-page">
<main class="form-panel" style="margin: 0 auto; float: none; max-width: 450px;">
    <div class="login-card">
        <div class="brand">
            <div class="welcome">FIND ID</div>
            <div class="title">아이디 찾기</div>
        </div>
        <form method="post" action="findIdSubmit.jsp">
            <div class="form-group">
                <label for="userName">이름</label>
                <input type="text" name="userName" id="userName" required placeholder="이름을 입력해 주세요"/>
            </div>
            <div class="form-group">
                <label for="userEmail">이메일</label>
                <input type="email" name="userEmail" id="userEmail" required placeholder="이메일을 입력해 주세요"/>
            </div>
            <button type="submit" class="btn-login" style="margin-top:20px;">아이디 찾기</button>
        </form>
        <div class="signup-area" style="margin-top:20px;">
            <a href="login.jsp">로그인 화면으로 돌아가기</a>
        </div>
    </div>
</main>
</body>
</html>
