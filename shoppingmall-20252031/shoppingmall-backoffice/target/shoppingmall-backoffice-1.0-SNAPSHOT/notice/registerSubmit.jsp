<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.util.Collection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String loginId = (String) session.getAttribute("loginId");
    
    // getParameter works for multipart in Servlet 3.0+ if configured, but sometimes it doesn't
    // For JSP/Servlet, we might need @MultipartConfig or a manual approach.
    // Since we are in a JSP, we use request.getPart() but it needs configuration in web.xml usually.
    
    String title = "";
    String content = "";
    String fileName = null;
    String fileOriginName = null;

    try {
        Part titlePart = request.getPart("title");
        if (titlePart != null) {
            java.io.InputStream is = titlePart.getInputStream();
            byte[] bytes = is.readAllBytes();
            title = new String(bytes, "UTF-8");
        }
        
        Part contentPart = request.getPart("content");
        if (contentPart != null) {
            java.io.InputStream is = contentPart.getInputStream();
            byte[] bytes = is.readAllBytes();
            content = new String(bytes, "UTF-8");
        }
        
        Part filePart = request.getPart("noticeFile");
        if (filePart != null && filePart.getSize() > 0) {
            fileOriginName = filePart.getSubmittedFileName();
            String extension = "";
            if (fileOriginName.contains(".")) {
                extension = fileOriginName.substring(fileOriginName.lastIndexOf("."));
            }
            fileName = UUID.randomUUID().toString() + extension;
            
            String uploadPath = application.getRealPath("/upload");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + fileName);
        }
    } catch (Exception e) {
            e.printStackTrace();
    }

    NoticeDto dto = new NoticeDto();
    dto.setTitle(title);
    dto.setContent(content);
    dto.setWriter(loginId);
    dto.setFileName(fileName);
    dto.setFileOriginName(fileOriginName);

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
