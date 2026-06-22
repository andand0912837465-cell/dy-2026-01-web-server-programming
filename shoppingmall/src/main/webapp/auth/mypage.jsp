<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%--
 * 20251246 김나우
 * 로그인한 사용자의 개인정보를 조회하는 마이페이지 메인 클래스임.
 * * 기능 설명:
 * 1. OTP 2차 인증 성공 시 세션에 저장되는 최종 로그인 아이디(loginId)를 확보함.
 * 2. 비로그인 상태로 URL을 통한 강제 진입 시 예외 처리를 통해 로그인 페이지로 리다이렉트함.
 * 3. MemberService 계층의 getMyPageInfo를 호출하여 데이터베이스로부터 최신 회원 정보를 단건 조회함.
 * 4. 조회된 데이터를 테이블 형태로 화면에 출력하며, 내부 기능인 정보 수정(update.jsp) 및 회원 탈퇴(delete.jsp)로 이동할 수 있는 직관적인 UI 구상을 포함함.
--%>
<%
  // 1. OTP 인증 성공 로직에 맞추어 세션 키 값을 "loginId"로 변경하여 가져옴
  String loginId = (String) session.getAttribute("loginId");

  // [예외 처리] 비로그인 사용자가 주소창으로 강제 진입 시 로그인 페이지로 리다이렉트
  if (loginId == null || loginId.trim().isEmpty()) {
%>
<script>
  alert("로그인이 필요한 서비스입니다.");
  // 현재 폴더 위치(auth/)를 고려하여 로그인 페이지 경로를 명확히 지정
  location.href = "login.jsp";
</script>
<%
    return;
  }

  // 2. 확보한 아이디를 기반으로 Service -> Repository 계층을 거쳐 최신 회원 정보를 조회함
  MemberService memberService = new MemberService();
  MemberDto member = memberService.getMyPageInfo(loginId);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <style>
    .mypage-container { width: 500px; margin: 50px auto; border: 1px solid #ccc; padding: 20px; font-family: sans-serif; }
    .profile-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
    .profile-table th, .profile-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
    .profile-table th { background-color: #f4f4f4; width: 30%; }
    .btn-group { margin-top: 20px; display: flex; gap: 10px; }
    .btn { padding: 10px 20px; cursor: pointer; text-decoration: none; border: 1px solid #555; background: #fff; color: #000; }
  </style>
</head>
<body>

<div class="mypage-container">
  <h2>마이페이지</h2>
  <% if (member != null) { %>
  <p>안녕하세요, <strong><%= member.getUserName() %></strong>님! 가입하신 정보는 아래와 같습니다.</p>

  <table class="profile-table">
    <tr>
      <th>아이디</th>
      <td><%= member.getUserId() %></td>
    </tr>
    <tr>
      <th>이름</th>
      <td><%= member.getUserName() %></td>
    </tr>
    <tr>
      <th>이메일</th>
      <td><%= member.getEmail() %></td>
    </tr>
  </table>
  <% } else { %>
  <p>회원 정보를 불러오는 데 실패했습니다.</p>
  <% } %>

  <div class="btn-group">
    <a href="update.jsp" class="btn">회원 정보 수정</a>
    <a href="delete.jsp" class="btn" style="color: red; border-color: red;">회원 탈퇴</a>
  </div>
</div>

</body>
</html>