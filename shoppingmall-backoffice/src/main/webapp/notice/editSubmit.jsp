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

    String idStr = request.getParameter("id");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeDto dto = new NoticeDto();
    dto.setId(id);
    dto.setTitle(title);
    dto.setContent(content);

    NoticeService noticeService = new NoticeService();
    boolean success = noticeService.modifyNotice(dto);

    if (success) {
%>
    <script>
        alert('공지사항이 수정되었습니다.');
        location.href = '/notice/view.jsp?id=<%= id %>';
    </script>
<%
    } else {
%>
    <script>
        alert('수정에 실패하였습니다.');
        history.back();
    </script>
<%
    }
%>
