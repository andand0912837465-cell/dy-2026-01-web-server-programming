<%@ page import="kr.ac.dy.cs.notice.NoticeDto" %>
<%@ page import="kr.ac.dy.cs.notice.NoticeService" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        return;
    }

    Long id = Long.parseLong(idStr);
    NoticeService noticeService = new NoticeService();
    NoticeDto notice = noticeService.getNotice(id);

    if (notice == null || notice.getFileName() == null) {
        return;
    }

    String fileName = notice.getFileName();
    String fileOriginName = notice.getFileOriginName();
    String uploadPath = application.getRealPath("/upload");
    File file = new File(uploadPath + File.separator + fileName);

    if (file.exists()) {
        String mimeType = application.getMimeType(file.toString());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        
        String encodedName = URLEncoder.encode(fileOriginName, "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
        response.setHeader("Content-Length", String.valueOf(file.length()));

        BufferedInputStream in = null;
        BufferedOutputStream outStream = null;

        try {
            in = new BufferedInputStream(new FileInputStream(file));
            outStream = new BufferedOutputStream(response.getOutputStream());

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        } finally {
            if (in != null) in.close();
            if (outStream != null) outStream.close();
        }
    }
%>
