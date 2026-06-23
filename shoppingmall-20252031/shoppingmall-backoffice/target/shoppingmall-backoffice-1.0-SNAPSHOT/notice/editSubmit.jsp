<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.UUID" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect("/auth/adminLogin.jsp");
        return;
    }

    String idStr = "";
    String title = "";
    String content = "";
    String deleteFile = "";

    try {
        Part idPart = request.getPart("id");
        if (idPart != null) {
            java.io.InputStream is = idPart.getInputStream();
            byte[] bytes = is.readAllBytes();
            idStr = new String(bytes, "UTF-8");
        }
        
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
        
        Part deleteFilePart = request.getPart("deleteFile");
        if (deleteFilePart != null) {
            java.io.InputStream is = deleteFilePart.getInputStream();
            byte[] bytes = is.readAllBytes();
            deleteFile = new String(bytes, "UTF-8");
        }
    } catch (Exception e) {}

    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeService noticeService = new NoticeService();
    NoticeDto existingNotice = noticeService.getNotice(id);

    if (existingNotice == null) {
        response.sendRedirect("/notice/list.jsp");
        return;
    }

    String fileName = existingNotice.getFileName();
    String fileOriginName = existingNotice.getFileOriginName();
    String uploadPath = application.getRealPath("/upload");

    // 1. Handle file deletion
    if ("Y".equals(deleteFile) && fileName != null) {
        File fileToDelete = new File(uploadPath + File.separator + fileName);
        if (fileToDelete.exists()) fileToDelete.delete();
        fileName = null;
        fileOriginName = null;
    }

    // 2. Handle new file upload
    try {
        Part filePart = request.getPart("noticeFile");
        if (filePart != null && filePart.getSize() > 0) {
            // Delete old file if exists
            if (fileName != null) {
                File oldFile = new File(uploadPath + File.separator + fileName);
                if (oldFile.exists()) oldFile.delete();
            }

            fileOriginName = filePart.getSubmittedFileName();
            String extension = "";
            if (fileOriginName.contains(".")) {
                extension = fileOriginName.substring(fileOriginName.lastIndexOf("."));
            }
            fileName = UUID.randomUUID().toString() + extension;
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + fileName);
        }
    } catch (Exception e) {
        // e.printStackTrace();
    }

    NoticeDto dto = new NoticeDto();
    dto.setId(id);
    dto.setTitle(title);
    dto.setContent(content);
    dto.setFileName(fileName);
    dto.setFileOriginName(fileOriginName);

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
