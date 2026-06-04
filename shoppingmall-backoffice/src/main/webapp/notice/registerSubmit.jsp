<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String loginId = (String) session.getAttribute("loginId");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    NoticeDto dto = new NoticeDto();
    dto.setTitle(title);
    dto.setContent(content);
    dto.setWriter(loginId);

    NoticeService noticeService = new NoticeService();
    boolean success = noticeService.registerNotice(dto);

    if (success) {
%>
    <script>
        alert('공지사항이 등록되었습니다.');
        location.href = '/notice/list.jsp';
    </script>
<%
    } else {
%>
    <script>
        alert('등록에 실패하였습니다.');
        history.back();
    </script>
<%
    }
%>
