main
<%--
    20252364 강한서

    상품 리뷰 삭제를 처리하는 JSP 페이지
    리뷰 번호와 로그인한 사용자 아이디를 이용하여 본인이 작성한 리뷰만 삭제할 수 있도록 처리한다.
    로그인 여부를 학인
    삭제할 리뷰 번호와 상품 번호를 전달받는다.
    리뷰 작성자와 현재 로그인한 사용자가 일치하는 경우에만 리뷰를 삭제한다.
    삭제 처리 후 다시 해당 상품 상세 페이지로 이동한다.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.review.ReviewDao"%>
<%@ page import="kr.ac.dy.cs.util.SessionUtils"%>
<%
    request.setCharacterEncoding("UTF-8");

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    String loginId = String.valueOf(session.getAttribute("loginId"));

    int reviewId = 0;
    int productId = 0;

    try {
        reviewId = Integer.parseInt(request.getParameter("reviewId"));
        productId = Integer.parseInt(request.getParameter("productId"));
    } catch (Exception e) {
        reviewId = 0;
        productId = 0;
    }

    if (reviewId > 0) {
        ReviewDao reviewDao = new ReviewDao();
        reviewDao.deleteReview(reviewId, loginId);
    }

    response.sendRedirect(request.getContextPath() + "/product/detail.jsp?id=" + productId);
%>
=======
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
main
