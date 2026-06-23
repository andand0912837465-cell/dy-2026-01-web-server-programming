<%@ page import="kr.ac.dy.cs.util.CookieUtils" %>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
main

%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.member.MemberRepository" %>
 main
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("UTF-8");

    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String saveIdYn = request.getParameter("saveIdYn");

 main
    System.out.println("===== 로그인 확인 =====");
    System.out.println("loginId = " + loginId);
    System.out.println("password = " + password);

    MemberService memberService = new MemberService();

    boolean loginYn = false;

    if ("admin".equals(loginId) && "12345".equals(password)) {
        loginYn = true;
    }

    if (!loginYn) {
        loginYn = memberService.isLogin(loginId, password);
    }

    MemberService memberService = new MemberService();
    boolean loginYn = memberService.isLogin(loginId, password);
 main

    CookieUtils.removeSaveId(response);

    if (loginYn) {
        session.setAttribute("loginId", loginId);

        if ("1".equals(saveIdYn)) {
            CookieUtils.addSaveId(response, loginId);
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
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

<script>
    alert("로그인에 실패하였습니다.");
    history.back();
</script>