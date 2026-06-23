<%--20251266 주혜림
  URL로 전달받은 reviewNo, productId, score, content 값을 읽음
  score는 int, reviewNo는 long으로 변환해서 사용
  H2 DB에 연결해서 PRODUCT_REVIEW 테이블 접근
  해당 REVIEW_NO를 가진 리뷰 1개의 SCORE와 CONTENT를 UPDATE 실행
  작업이 끝나면 DB 자원(PreparedStatement, Connection) 정리
  성공 여부와 상관없이 상품 상세 페이지(detail.jsp?id=productId)로 리다이렉트
  특정 리뷰를 수정한 뒤 결과를 반영하는 서버 처리 코드--%>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector"%>

<%
  long reviewNo=
          Long.parseLong(request.getParameter("reviewNo"));

  String productId=
          request.getParameter("productId");

  int score=
          Integer.parseInt(request.getParameter("score"));

  String content=
          request.getParameter("content");

  Connection conn=null;
  PreparedStatement pstmt=null;

  try{

    conn=new H2DbConnector().getConnection();

    pstmt=conn.prepareStatement(
            "UPDATE PRODUCT_REVIEW SET SCORE=?,CONTENT=? WHERE REVIEW_NO=?"
    );

    pstmt.setInt(1,score);
    pstmt.setString(2,content);
    pstmt.setLong(3,reviewNo);

    pstmt.executeUpdate();

  }catch(Exception e){
    e.printStackTrace();
  }
  finally{
    try{if(pstmt!=null)pstmt.close();}catch(Exception e){}
    try{if(conn!=null)conn.close();}catch(Exception e){}
  }

  response.sendRedirect(
          "detail.jsp?id="+
                  URLEncoder.encode(productId,"UTF-8")
  );
%>