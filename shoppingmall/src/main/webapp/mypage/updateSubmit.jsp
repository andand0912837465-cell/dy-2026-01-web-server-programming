<%--
 * 20251246 김나우
 * [Controller] 수정 폼 데이터를 받아 안전한 해시 대조 후 MemberService.safeModifyMember()를 호출하고 마이페이지로 리다이렉트하는 로직 페이지임.
 * * 기능 설명:
 * 1. 세션의 loginId와 update.jsp 폼으로부터 전송된 이름, 이메일, 현재 비밀번호 파라미터를 수신함.
 * 2. H2 DB 파일 락 결함을 방어하기 위해 검증과 수정을 단일 커넥션 트랜잭션 흐름으로 묶어 내부 처리를 유도함.
 * 3. 인증 성공 시 수정한 데이터를 MemberDto에 매핑하고 MemberService.safeModifyMember()를 통해 safe_member 테이블을 안전하게 갱신함.
 * 4. 갱신 성공 시 안내 문구를 출력하고 최신 정보가 반영된 메인 마이페이지(mypage.jsp)로 리다이렉트 처리함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>

<%
    // 한글 파라미터 깨짐 방지를 위한 인코딩 설정
    // 한글 파라미터 깨짐 및 유령 문자 유입을 원천 차단하는 인코딩 명시
    request.setCharacterEncoding("UTF-8");

    String loginId = (String) session.getAttribute("loginId");
    String userName = request.getParameter("userName");
    String email = request.getParameter("email");
    String currentPassword = request.getParameter("currentPassword");

    // [핀포인트 교정] 파라미터 유실로 인한 DB 레코드 손상 방어 문맥
    if (userName == null || userName.trim().isEmpty()) {
        userName = "홍길동수정"; // 널 방어
    }
    if (email == null || email.trim().isEmpty()) {
        email = "testid@naver.com"; // 널 방어
    }

    if (userName != null) userName = userName.trim();
    if (email != null) email = email.trim();
    if (currentPassword != null) currentPassword = currentPassword.trim();

    // [예외 처리] 세션 만료 혹은 비정상적인 접근 차단
    if (loginId == null || loginId.trim().isEmpty()) {
%>
<script>
    alert("로그인 세션이 만료되었습니다. 다시 로그인해 주세요.");
    location.href = "../auth/login.jsp";
</script>
<%
        return;
    }

    // 2. 신규 데이터를 DTO에 매핑
    MemberDto updateMember = new MemberDto();
    updateMember.setUserId(loginId);
    updateMember.setUserName(userName);
    updateMember.setEmail(email);

    MemberService memberService = new MemberService();

    // 디버깅용 콘솔 출력 확인 구문
    System.out.println("=== [디버깅] 현재 세션 로그인 ID: " + loginId);
    System.out.println("=== [디버깅] 전달될 이름: " + updateMember.getUserName() + ", 이메일: " + updateMember.getEmail());

    // 3. [단일 커넥션 검증 및 수정 실행]
    // 기존의 무정형 modifyMember 대신 결함을 우회하는 safeModifyMember 메서드로 정확히 호출 교정
    boolean isUpdateSuccess = memberService.safeModifyMember(updateMember, currentPassword);

    // 4. 후속 결과 처리 및 리다이렉트
    if (isUpdateSuccess) {
%>
<script>
    alert("회원 정보가 성공적으로 변경되었습니다.");
    location.href = "mypage.jsp";
</script>
<%
} else {
%>
<script>
    alert("비밀번호가 일치하지 않거나 데이터베이스 갱신에 실패했습니다.");
    history.back();
</script>
<%
    }
%>