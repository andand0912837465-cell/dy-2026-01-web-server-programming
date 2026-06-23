<%@ page import="kr.ac.dy.cs.member.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 회원 상새 정보 수정을 하는 페이지 -->

<%
    String id = request.getParameter("id");

    MemberService service = new MemberService();
    MemberDto member = service.getMember(id);
%>

<html>
<head>
    <title>회원 수정</title>
</head>
<body>

<h2>회원 수정</h2>

<form action="editSubmit.jsp" method="post">

    <input type="hidden"
           name="id"
           value="<%= member.getUserId() %>">

    이름 :
    <input type="text"
           name="name"
           value="<%= member.getUserName() %>">
    <br><br>

    이메일 :
    <input type="text"
           name="email"
           value="<%= member.getEmail() %>">
    <br><br>

    비밀번호 :
    <input type="text"
           name="password"
           value="<%= member.getPassword() %>">
    <br><br>

    <button type="submit">수정</button>

</form>

</body>
</html>