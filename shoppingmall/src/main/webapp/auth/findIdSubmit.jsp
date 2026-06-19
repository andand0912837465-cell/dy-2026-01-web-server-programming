<%--
  Created by IntelliJ IDEA.
  User: 20251250 한상호
  Date: 26. 6. 20.
  Time: 오전 2:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector" %>
<%@ page import="java.sql.*" %>
<%
  // 인코딩 설정 및 요청 파라미터 수신
  request.setCharacterEncoding("utf-8");
  String name = request.getParameter("userName");
  String email = request.getParameter("userEmail");

  String foundId = null;
  Connection conn = null;
  PreparedStatement psmt = null;
  ResultSet rs = null;

  String contextPath = request.getContextPath();

  try {
    // 기존 데이터베이스 연동 커넥터 활용
    conn = new H2DbConnector().getConnection();
    String sql = "SELECT ID FROM PUBLIC.MEMBER WHERE NAME = ? AND EMAIL = ?";
    psmt = conn.prepareStatement(sql);
    psmt.setString(1, name);
    psmt.setString(2, email);
    rs = psmt.executeQuery();

    if (rs.next()) {
      foundId = rs.getString("id");
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    if (rs != null) try { rs.close(); } catch(Exception e) {}
    if (psmt != null) try { psmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기 처리</title>
  <script>
    <% if (foundId != null) { %>
    alert("입력하신 정보와 일치하는 아이디는 [ <%= foundId %> ] 입니다.");
    <% } else { %>
    alert("일치하는 회원 정보가 없습니다.");
    <% } %>

    location.href = "<%= contextPath %>/auth/adminLogin.jsp";
  </script>
</head>
<body>
</body>
</html>