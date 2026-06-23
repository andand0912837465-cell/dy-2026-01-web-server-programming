<%--
 * 20251246 김나우
 * [Controller] 회원 탈퇴 폼 데이터를 받아 본인 인증 후 소프트 딜리트 처리를 수행하는 로직 페이지임.
 * * 기능 설명:
 * 1. 세션의 loginId와 사용자가 입력한 현재 비밀번호 파라미터를 수신하여 앞뒤 공백을 제거함.
 * 2. MemberService.isLogin()을 활용하여 탈퇴 전 최종 패스워드 본인 검증 절차를 수행함.
 * 3. 검증 성공 시 MemberService.processWithdrawal()을 통해 회원 상태를 탈퇴('N')로 전환함.
 * 4. 최종 탈퇴 완료 시 세션을 완전 소멸(invalidate)시켜 로그아웃을 강제하고 로그인 화면으로 리다이렉트함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>

<%
    request.setCharacterEncoding("UTF-8");

    String loginId = (String) session.getAttribute("loginId");
    String currentPassword = request.getParameter("currentPassword");

    if (currentPassword != null) currentPassword = currentPassword.trim();

    // 세션 예외 방어
    if (loginId == null || loginId.trim().isEmpty()) {
%>
<script>
    alert("로그인 세션이 만료되었습니다. 다시 로그인해 주세요.");
    location.href = "login.jsp";
</script>
<%
        return;
    }

    MemberService memberService = new MemberService();

    // 1단계: 탈퇴 전 비밀번호 검증 (기존 암호화 로그인 규칙 재활용)
    boolean isVerified = memberService.isLogin(loginId, currentPassword);

    if (!isVerified) {
%>
<script>
    alert("비밀번호 인증에 실패하여 탈퇴 처리가 취소되었습니다.");
    history.back();
</script>
<%
        return;
    }

    // 2단계: 검증 통과 시 소프트 딜리트(상태값 'N' 변경) 실행
    boolean isWithdrawSuccess = memberService.processWithdrawal(loginId);

    if (isWithdrawSuccess) {
        // 3단계: 탈퇴 처리 성공 시 세션을 완전히 비워 로그아웃 강제 실행
        session.invalidate();
%>
<script>
    alert("그동안 서비스를 이용해 주셔서 감사합니다. 회원 탈퇴가 완료되었습니다.");
    location.href = "login.jsp"; // 탈퇴되었으므로 로그인 화면으로 팅겨냄
</script>
<%
} else {
%>
<script>
    alert("데이터베이스 탈퇴(UPDATE) 처리에 실패했습니다.");
    history.back();
</script>
<%
    }
%>
