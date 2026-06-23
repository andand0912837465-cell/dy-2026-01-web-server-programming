<%--20251266 주혜림
  URL로 전달받은 reviewNo, productId 값을 읽음
  H2 DB에 연결해서 PRODUCT_REVIEW 테이블 접근
  해당 REVIEW_NO에 해당하는 리뷰의 SCORE, CONTENT를 조회
  조회한 값으로 수정 폼의 기본값(기존 별점, 내용)을 세팅
  결과를 form에 표시해서 사용자가 수정할 수 있는 페이지 생성
  이후 reviewEdit.jsp로 POST 전송해서 실제 수정 처리 진행--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="kr.ac.dy.cs.util.H2DbConnector"%>

<%
  request.setCharacterEncoding("UTF-8");

  String reviewNo = request.getParameter("reviewNo");
  String productId = request.getParameter("productId");

  String content = "";
  int score = 5;

  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try{
    conn = new H2DbConnector().getConnection();

    pstmt = conn.prepareStatement(
            "SELECT SCORE, CONTENT FROM PRODUCT_REVIEW WHERE REVIEW_NO=?"
    );
    pstmt.setLong(1, Long.parseLong(reviewNo));

    rs = pstmt.executeQuery();

    if(rs.next()){
      score = rs.getInt("SCORE");
      content = rs.getString("CONTENT");
    }

  }catch(Exception e){
    e.printStackTrace();
  }finally{
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(pstmt!=null) pstmt.close(); }catch(Exception e){}
    try{ if(conn!=null) conn.close(); }catch(Exception e){}
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>리뷰 수정</title>

  <style>
    body{
      font-family: sans-serif;
      max-width:800px;
      margin:40px auto;
    }

    textarea{
      width:100%;
      height:200px;
    }

    button{
      padding:10px 20px;
    }
  </style>

</head>
<body>

<h2>리뷰 수정</h2>

<form method="post" action="reviewEdit.jsp">

  <input type="hidden" name="reviewNo" value="<%=reviewNo%>">
  <input type="hidden" name="productId" value="<%=productId%>">

  <p>별점</p>

  <select name="score">
    <option value="5" <%=score==5?"selected":""%>>5점</option>
    <option value="4" <%=score==4?"selected":""%>>4점</option>
    <option value="3" <%=score==3?"selected":""%>>3점</option>
    <option value="2" <%=score==2?"selected":""%>>2점</option>
    <option value="1" <%=score==1?"selected":""%>>1점</option>
  </select>

  <p>내용</p>

  <textarea name="content"><%=content%></textarea>

  <br><br>

  <button type="submit">수정하기</button>

</form>

</body>
</html>