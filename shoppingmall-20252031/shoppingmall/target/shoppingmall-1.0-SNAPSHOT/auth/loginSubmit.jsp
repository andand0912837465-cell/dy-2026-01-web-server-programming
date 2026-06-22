<%--
20252031 이준성
로그인 처리 구현.
memberService.isLogin을 통해 로그인 성공 여부를 boolean으로 반환받음.
이후 session에 Attribute 저장.
--%>
<%@ page import="kr.ac.dy.cs.util.CookieUtils" %>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인 처리</title>
</head>
<body>
<%
    MemberService memberService = new MemberService();
    out.println("memberService 생성됨.");

    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String saveIdYn = request.getParameter("saveIdYn");

    //로그인성공
    boolean loginYn = false;
    if (memberService.isLogin(loginId, password)) {
        session.setAttribute("loginId", loginId);
        loginYn = true;
    }

    //아이디저장확인
    //쿠키를 초기화
    CookieUtils.removeSaveId(response);
    if (loginYn && "1".equals(saveIdYn)) {
        CookieUtils.addSaveId(response, loginId);
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
