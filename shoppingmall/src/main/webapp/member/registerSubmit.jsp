<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.member.MemberRegisterForm" %>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberRepository" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입 결과</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");
    MemberRegisterForm memberRegisterForm = MemberRegisterForm.get(request);

    //입력된 데이터를 통해서 회원가입을 진행
    MemberService memberService = new MemberService();
    boolean result = memberService.register(memberRegisterForm);
%>

<%if (result) {%>
    <h1>회원가입에 성공하였습니다.</h1>
    <%
        String loginId = request.getParameter("userId");
        String password = request.getParameter("password");

        MemberRepository memberRepository = new MemberRepository();
        MemberDto memberDto = memberRepository.select(loginId, password);

        session.setAttribute("userOtpSecretKey", memberDto.getOtp_key());
        session.setAttribute("userEmail", memberDto.getEmail());

        response.sendRedirect("/otp/register");
    %>
<%}else {%>
    <script>
        alert('회원가입에 실패했습니다.');
        history.back(-1);
    </script>
<%}%>

</body>
</html>
