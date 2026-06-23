<%--
 * 학번: 20251246 / 성명: 김나우
 * 마이페이지 내 회원 정보 수정 입력 화면을 제공하는 JSP 클래스임.
 * * [주요 기능 명세]
 * 1. 세션 검증: session 객체에서 "loginId"를 확보하여 유효성을 검증하고, 비로그인 상태 접근 시 강제 차단 및 로그인 페이지(login.jsp)로 리다이렉트 처리함.
 * 2. 데이터 프리셋: MemberService 계층의 getMyPageInfo(loginId) 메서드를 호출하여 데이터베이스로부터 현재 로그인된 회원의 최신 정보(아이디, 이름, 이메일)를 단건 조회함.
 * 3. 폼 바인딩: 조회된 기존 회원 데이터를 각 HTML 입력창(input value)에 자동으로 매핑하여 사용자에게 프리셋 화면으로 출력함.
 * 4. 식별자 보호: 회원 고유 식별자인 아이디(userId) 입력란에는 readonly 속성을 명시하여 임의 변경을 원천 차단함.
 * 5. 보안 인증: 데이터 무결성과 안전한 정보 변경을 보장하기 위해 본인 인증용 현재 비밀번호 입력 영역을 필수 항목으로 배치함.
 * 6. 데이터 전송: 사용자가 입력한 수정 값과 인증 데이터의 유실을 막기 위해 POST 전송 방식을 채택하여 처리 컨트롤러(updateSubmit.jsp)로 양식(Form)을 매핑함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>

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

    MemberService memberService = new MemberService();
    MemberDto member = memberService.getMyPageInfo(loginId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <style>
        .update-container { width: 500px; margin: 50px auto; border: 1px solid #ccc; padding: 20px; font-family: sans-serif; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 95%; padding: 8px; font-size: 14px; }
        .btn-group { margin-top: 20px; display: flex; gap: 10px; }
        .btn { padding: 10px 20px; cursor: pointer; text-decoration: none; border: 1px solid #555; font-size: 14px; }
        .btn-submit { background: #007bff; color: #fff; border-color: #007bff; }
        .btn-cancel { background: #fff; color: #000; }
    </style>
</head>
<body>

<div class="update-container">
    <h2>회원 정보 수정</h2>
    <p>보안을 위해 현재 비밀번호를 입력하신 후 정보를 변경해 주세요.</p>
    <hr>

    <% if (member != null) { %>
    <form action="updateSubmit.jsp" method="POST">
        <div class="form-group">
            <label for="userId">아이디</label>
            <input type="text" id="userId" name="userId" value="<%= member.getUserId() %>" readonly>
        </div>
        <div class="form-group">
            <label for="userName">이름</label>
            <input type="text" id="userName" name="userName" value="<%= member.getUserName() %>" required>
        </div>
        <div class="form-group">
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" value="<%= member.getEmail() %>" required>
        </div>
        <div class="form-group">
            <label for="currentPassword">현재 비밀번호 인증</label>
            <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호를 입력하세요" required>
        </div>
        <div class="btn-group">
            <input type="submit" value="수정 완료" class="btn btn-submit">
            <a href="mypage.jsp" class="btn btn-cancel">취소</a>
        </div>
    </form>
    <% } else { %>
    <p>회원 정보를 불러올 수 없습니다.</p>
    <a href="mypage.jsp" class="btn btn-cancel">마이페이지로 돌아가기</a>
    <% } %>
</div>

</body>
</html>