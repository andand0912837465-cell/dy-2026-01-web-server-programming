<%-- 20251258 김상범
새로운 사용자의 아이디, 이름, 비밀번호를 입력받아 회원가입하는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - 회원가입</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .register-box { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 360px; text-align: center; }
        .register-box h1 { margin-bottom: 24px; color: #1a73e8; }
        .register-box input { width: 100%; padding: 12px; margin-bottom: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        .register-box input:focus { border-color: #1a73e8; outline: none; }
        .register-box .btn { width: 100%; padding: 12px; background: #1a73e8; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .register-box .btn:hover { background: #1557b0; }
        .register-box .error { color: #d93025; margin-bottom: 12px; font-size: 14px; }
        .register-box .link { margin-top: 16px; font-size: 14px; }
        .register-box .link a { color: #1a73e8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="register-box">
        <h1>회원가입</h1>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/register" method="post">
            <input type="text" name="userId" placeholder="아이디" required>
            <input type="text" name="name" placeholder="이름" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <input type="password" name="confirmPassword" placeholder="비밀번호 확인" required>
            <button type="submit" class="btn">가입하기</button>
        </form>
        <div class="link">이미 계정이 있으신가요? <a href="<%= request.getContextPath() %>/login">로그인</a></div>
    </div>
</body>
</html>
