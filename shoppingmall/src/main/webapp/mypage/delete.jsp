<%--
 * 학번: 20251246 / 성명: 김나우
 * 회원 탈퇴 전 본인 인증 및 최종 동의를 받는 입력 화면 JSP 클래스임.
 * * [주요 기능 명세]
 * 1. 세션 검증: session에서 "loginId"를 확보하여 비로그인 사용자의 주소창 강제 접근을 원천 차단함.
 * 2. 보안 인증: 탈퇴의 민감성을 고려하여 현재 비밀번호를 다시 한번 입력받아 본인 인증 데이터로 매핑함.
 * 3. 폼 전송: 사용자 입력 값과 탈퇴 의사를 POST 방식으로 처리 컨트롤러(deleteSubmit.jsp)에 안전하게 전송함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String loginId = (String) session.getAttribute("loginId");

    if (loginId == null || loginId.trim().isEmpty()) {
%>
<script>
    alert("로그인이 필요한 서비스입니다.");
    location.href = "../auth/login.jsp";
</script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 탈퇴</title>
    <style>
        .delete-container { width: 500px; margin: 50px auto; border: 1px solid #ccc; padding: 20px; font-family: sans-serif; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #cc0000; }
        .form-group input { width: 95%; padding: 8px; font-size: 14px; }
        .btn-group { margin-top: 20px; display: flex; gap: 10px; }
        .btn { padding: 10px 20px; cursor: pointer; text-decoration: none; border: 1px solid #555; font-size: 14px; }
        .btn-danger { background: #dc3545; color: #fff; border-color: #dc3545; }
        .btn-cancel { background: #fff; color: #000; }
        .warning-text { color: #666; font-size: 13px; line-height: 1.6; background: #fdf2f2; padding: 10px; border-left: 4px solid #dc3545; }
    </style>
</head>
<body>

<div class="delete-container">
    <h2>회원 탈퇴 인증</h2>
    <div class="warning-text">
        <strong>⚠️ 주의사항</strong><br>
        탈퇴 처리 즉시 회원 정보 및 마이페이지 서비스 이용이 불가능해집니다.<br>
        안전한 탈퇴를 위해 현재 비밀번호를 입력해 주세요.
    </div>
    <hr>

    <form action="deleteSubmit.jsp" method="POST">
        <div class="form-group">
            <label for="currentPassword">비밀번호 확인</label>
            <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호를 입력하세요" required>
        </div>
        <div class="btn-group">
            <input type="submit" value="정말 탈퇴하기" class="btn btn-danger" onclick="return confirm('정말로 탈퇴하시겠습니까?');">
            <a href="mypage.jsp" class="btn btn-cancel">취소</a>
        </div>
    </form>
</div>

</body>
</html>
