<%@ page import="kr.ac.dy.cs.util.CookieUtils" %>
<%@ page import="kr.ac.dy.cs.adminUser.AdminUserService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String saveIdYn = request.getParameter("saveIdYn");

    AdminUserService adminUserService = new AdminUserService();
    boolean loginYn = adminUserService.isLogin(loginId, password);

    if (loginYn) {
        session.setAttribute("loginId", loginId);
        session.setAttribute("loginAt", new java.util.Date());
    }

    CookieUtils.removeSaveId(response);
    if (loginYn && "1".equals(saveIdYn)) {
        CookieUtils.addSaveId(response, loginId);
    }

    if (loginYn) {
        response.sendRedirect("/dashboard/index.jsp");
    } else {
        response.sendRedirect("/auth/adminLogin.jsp?error=1");
    }
%>