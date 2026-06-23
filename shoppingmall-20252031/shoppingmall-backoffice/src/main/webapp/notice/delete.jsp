<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String idStr = request.getParameter("id");

    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeService noticeService = new NoticeService();
    
    // Get file info before deletion
    NoticeDto notice = noticeService.getNotice(id);
    if (notice != null && notice.getFileName() != null) {
        String uploadPath = application.getRealPath("/upload");
        File file = new File(uploadPath + File.separator + notice.getFileName());
        if (file.exists()) file.delete();
    }

    boolean success = noticeService.removeNotice(id);

    if (success) {
%>
    <script>
        alert('공지사항이 삭제되었습니다.');
        location.href = '/notice/list.jsp';
    </script>
<%
    } else {
%>
    <script>
        alert('삭제에 실패하였습니다.');
        location.href = '/notice/list.jsp';
    </script>
<%
    }
%>
