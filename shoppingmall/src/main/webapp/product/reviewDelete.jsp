<%--20251266 주혜림
  URL로 전달받은 reviewNo, productId 값을 읽음
  H2 DB에 연결해서 PRODUCT_REVIEW 테이블 접근
  해당 REVIEW_NO를 가진 리뷰 1개를 DELETE 실행
  실패하면 alert 띄우고 뒤로 이동
  성공하면 다시 detail.jsp?id=productId로 리다이렉트
  특정 상품 상세 페이지에서 “리뷰 삭제 버튼” 눌렀을 때 실행되는 서버 코드--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector"%>

<%
  String reviewNo = request.getParameter("reviewNo");
  String productId = request.getParameter("productId");

  Connection conn = null;
  PreparedStatement pstmt = null;

  try{

    conn = new H2DbConnector().getConnection();

    pstmt = conn.prepareStatement(
            "DELETE FROM PRODUCT_REVIEW WHERE REVIEW_NO=?"
    );

    pstmt.setLong(1, Long.parseLong(reviewNo));

    pstmt.executeUpdate();

  }catch(Exception e){

    e.printStackTrace();
%>

<script>
  alert("삭제 실패");
  history.back();
</script>

<%
    return;
  }finally{

    try{ if(pstmt!=null) pstmt.close(); }catch(Exception e){}
    try{ if(conn!=null) conn.close(); }catch(Exception e){}
  }

  response.sendRedirect(
          "detail.jsp?id=" +
                  URLEncoder.encode(productId,"UTF-8")
  );
%>