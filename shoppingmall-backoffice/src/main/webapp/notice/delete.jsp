<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.io.File" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
%>
<script>
    alert('잘못된 요청입니다. 삭제는 버튼을 통해 다시 시도해 주세요.');
    location.href = '/notice/list.jsp';
</script>
<%
        return;
    }

    String idStr = request.getParameter("id");

    if (idStr == null || idStr.isBlank()) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeService noticeService = new NoticeService();

    NoticeDto notice = noticeService.getNotice(id);
    if (notice != null && notice.getFileName() != null) {
        String uploadPath = application.getRealPath("/upload");
        File file = new File(uploadPath + File.separator + notice.getFileName());
        if (file.exists()) {
            file.delete();
        }
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
