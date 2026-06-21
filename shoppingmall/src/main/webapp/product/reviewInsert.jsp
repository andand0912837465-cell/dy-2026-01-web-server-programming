<%--
    20252364 강한서

    상품 리뷰 등록을 처리하는 JSP 페이지이다.
    상품 상세 페이지에서 전달받은 상품 번호, 별점, 리뷰 내용을 이용하여
    review 테이블에 새로운 리뷰를 추가한다.

    로그인 여부를 확인하여 로그인한 사용자만 리뷰를 작성할 수 있도록 한다.
    상품 번호, 별점, 리뷰 내용을 전달받아 review 테이블에 저장한다.
    리뷰 등록 후 다시 해당 상품 상세 페이지로 이동한다.
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

    int productId = 0;
    int rating = 5;
    String content = request.getParameter("content");

    try {
        productId = Integer.parseInt(request.getParameter("productId"));
        rating = Integer.parseInt(request.getParameter("rating"));
    } catch (Exception e) {
        productId = 0;
        rating = 5;
    }

    if (rating < 1) {
        rating = 1;
    }

    if (rating > 5) {
        rating = 5;
    }

    if (productId > 0 && content != null && !content.trim().isEmpty()) {
        ReviewDao reviewDao = new ReviewDao();
        reviewDao.insertReview(productId, loginId, rating, content.trim());
    }

    response.sendRedirect(request.getContextPath() + "/product/detail.jsp?id=" + productId);
%>
