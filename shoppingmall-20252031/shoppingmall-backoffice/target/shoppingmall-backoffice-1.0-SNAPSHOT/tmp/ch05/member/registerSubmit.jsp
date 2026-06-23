<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%@ page import="kr.ac.dy.cs.tmp.MemberService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입 결과</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");
    //Input tag name값
    String userId = request.getParameter("userId");
    String userName = request.getParameter("userName");
    String userEmail = request.getParameter("email");
    String password = request.getParameter("password");

    MemberDto memberDto = new MemberDto();
    memberDto.setUserId(userId);
    memberDto.setUserName(userName);
    memberDto.setEmail(userEmail);
    memberDto.setPassword(password);

    //입력된 데이터를 통해서 회원가입을 진행
    MemberService memberService = new MemberService();
    boolean result = memberService.register(memberDto);
%>
<%if (result) {%>
    <h1>회원가입에 성공하였습니다.</h1>
<%}else {%>
    <script>
        alert('회원가입에 실패했습니다.');
        history.back(-1);
    </script>
<%}%>

<%
    if (result) {
        out.prinltn("<h1>회원가입에 성공하였습니다.</h1>");
    }else {
        out.println("<script>");
        out.println("alert('회원가입에 실패했습니다.');");
        out.println("history.back(-1);");
        out.println("</script>");
    }
%>

<%--
    <p>아이디: <%=userId%></p>
    <p>이름: <%=userName%></p>
    <p>이메일: <%=userEmail%></p>
    <p>비밀번호: <%=password%></p>
--%>


</body>
</html>
