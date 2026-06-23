<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%
  /**
   * 20231579 이순호
   * 최근 본 상품 번호를 쿠키에 저장하는 기능을 처리하는 페이지임.
   * 최근 본 상품 기능은 상품 상세 조회 시 해당 상품 번호를 브라우저 쿠키에 추가하여 기록을 유지하는 기능을 제공함.
   * 추가로, 최근 본 상품 기능은 상품 상세 조회 시 해당 상품 번호를 브라우저 쿠키에 추가하여 기록을 유지하는 기능을 제공함.
   * 최근 본 상품 기능은 상품 상세 조회 시 해당 상품 번호를 브라우저 쿠키에 추가하여 기록을 유지하는 기능을 제공함.
   * 상세로는 최근 본 상품 기능은 상품 상세 조회 시 해당 상품 번호를 브라우저 쿠키에 추가하여 기록을 유지하는 기능을 제공함.
   * 최근 본 상품 기능은 상품 상세 조회 시 해당 상품 번호를 브라우저 쿠키에 추가하여 기록을 유지하는 기능을 제공함.
   *
   */
  String productId = request.getParameter("productId");

  try {
    if (productId == null || productId.trim().isEmpty()) {
      productId = "1001";
    }

    String cookieValue = URLEncoder.encode(productId, "UTF-8");
    Cookie recentCookie = new Cookie("recent_viewed_" + productId, cookieValue);
    recentCookie.setMaxAge(60 * 60 * 24);
    recentCookie.setPath("/");
    response.addCookie(recentCookie);

  } catch (Exception e) {
    System.out.println("[ERROR] 쿠키 생성 오류: " + e.getMessage());
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 상세 조회</title>
  <style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; padding: 40px; }
    .product-card { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); text-align: center; }
    .btn-home { display: inline-block; padding: 12px 24px; background: #2c3e50; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
  </style>
</head>
<body>
<div class="product-card">
  <h2 style="color: #2c3e50;">👕 상품 상세 페이지 (ID: <%= productId %>)</h2>
  <p style="color: #16a085; font-weight: bold;">[시스템] '최근 본 상품' 쿠키가 브라우저에 저장되었습니다!</p>
  <a href="index.jsp" class="btn-home">메인 화면으로 돌아가기</a>
</div>
</body>
</html>