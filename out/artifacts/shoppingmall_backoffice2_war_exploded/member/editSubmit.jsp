<%@ page import="kr.ac.dy.cs.member.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 해당 정보를 수정시킬때 작동하는 페이지 -->

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    MemberDto member = new MemberDto();
    member.setUserId(id);
    member.setUserName(name);
    member.setEmail(email);
    member.setPassword(password);

    MemberService service = new MemberService();

    boolean result = service.updateMember(member);

    if(result){
        response.sendRedirect("view.jsp?id=" + id);
    }else{
%>
수정 실패
<%
    }
%>