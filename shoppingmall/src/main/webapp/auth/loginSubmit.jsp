<%@ page import="kr.ac.dy.cs.util.CookieUtils" %>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.member.MemberRepository" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인 처리</title>
</head>
<body>
<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String saveIdYn = request.getParameter("saveIdYn");

    MemberService memberService = new MemberService();
    boolean loginYn = memberService.isLogin(loginId, password);

    //아이디저장확인
    //쿠키를 초기화
    CookieUtils.removeSaveId(response);
    if (loginYn && "1".equals(saveIdYn)) {
        CookieUtils.addSaveId(response, loginId);
    }

    if (loginYn) {
        MemberRepository memberRepository = new MemberRepository();
        MemberDto memberDto = memberRepository.select(loginId, password);

        session.setAttribute("userOtpSecretKey", memberDto.getOtp_key());
        session.setAttribute("tempLoginId", loginId);

        response.sendRedirect("/auth/otp.jsp");
        return;
    }
%>

<% if (loginYn) {%>
    <%
        response.sendRedirect("/");
    %>
<% } else {%>
    <p>로그인에 실패하였습니다.</p>
    <div>
        <a href="login.jsp">다시 시도</a>
    </div>
<%} %>

</body>
</html>
