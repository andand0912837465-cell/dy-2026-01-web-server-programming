<%--
  20252365 조준혁
  제품 리뷰를 저장하는 JSP 페이지.
  리뷰 정보는 PRODUCT_REVIEW 테이블에 저장된다.
  데이터베이스 생성 SQL은 init_product.sql에서 확인할 수 있다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector" %>
<%
    request.setCharacterEncoding("UTF-8");

    String productId = request.getParameter("productId");
    String writer = request.getParameter("writer");
    String scoreText = request.getParameter("score");
    String content = request.getParameter("content");

    if (productId == null || productId.trim().equals("")) {
        productId = "best-0";
    }
    productId = productId.trim();

    if (writer == null || writer.trim().equals("")) {
        writer = "익명";
    } else {
        writer = writer.trim();
    }

    if (content == null || content.trim().equals("")) {
%>
<script>
    alert('리뷰 내용을 입력해주세요.');
    history.back();
</script>
<%
        return;
    }
    content = content.trim();

    int score = 5;
    try {
        score = Integer.parseInt(scoreText);
    } catch (Exception e) {
        score = 5;
    }

    if (score < 1) {
        score = 1;
    }
    if (score > 5) {
        score = 5;
    }

    H2DbConnector connector = new H2DbConnector();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = connector.getConnection();

        Statement stmt = conn.createStatement();
        stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS PRODUCT_REVIEW ("
                        + "REVIEW_NO BIGINT AUTO_INCREMENT PRIMARY KEY, "
                        + "PRODUCT_ID VARCHAR(30) NOT NULL, "
                        + "WRITER VARCHAR(50) NOT NULL, "
                        + "SCORE INT NOT NULL, "
                        + "CONTENT VARCHAR(1000) NOT NULL, "
                        + "REG_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                        + ")"
        );
        stmt.close();

        pstmt = conn.prepareStatement(
                "INSERT INTO PRODUCT_REVIEW (PRODUCT_ID, WRITER, SCORE, CONTENT) VALUES (?, ?, ?, ?)"
        );
        pstmt.setString(1, productId);
        pstmt.setString(2, writer);
        pstmt.setInt(3, score);
        pstmt.setString(4, content);
        pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
%>
<script>
    alert('리뷰 저장 중 오류가 발생했습니다.');
    history.back();
</script>
<%
        return;
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    response.sendRedirect("detail.jsp?id=" + URLEncoder.encode(productId, "UTF-8"));
%>
