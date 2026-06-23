<%-- 20251258 김상범
사용자 아이디와 비밀번호를 입력받아 로그인하는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - 로그인</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 360px; text-align: center; }
        .login-box h1 { margin-bottom: 8px; color: #1a73e8; }
        .login-box .sub { color: #666; margin-bottom: 24px; font-size: 14px; }
        .login-box input { width: 100%; padding: 12px; margin-bottom: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        .login-box input:focus { border-color: #1a73e8; outline: none; }
        .login-box .btn { width: 100%; padding: 12px; background: #1a73e8; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .login-box .btn:hover { background: #1557b0; }
        .login-box .error { color: #d93025; margin-bottom: 12px; font-size: 14px; }
        .login-box .link { margin-top: 16px; font-size: 14px; }
        .login-box .link a { color: #1a73e8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>QuizMaster</h1>
        <div class="sub">주제별 퀴즈를 풀고 실력을 확인하세요!</div>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/login" method="post">
            <input type="text" name="userId" placeholder="아이디" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <button type="submit" class="btn">로그인</button>
        </form>
        <div class="link">계정이 없으신가요? <a href="<%= request.getContextPath() %>/register">회원가입</a></div>
    </div>
</body>
</html>
