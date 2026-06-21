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
