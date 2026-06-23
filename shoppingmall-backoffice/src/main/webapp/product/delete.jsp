<%--
  20252377 양효재
  부분 구현된 상품 삭제 기능이 남아 있어서 개선 진행하였다.
  선택한 상품과 연결된 리뷰를 같이 정리한 뒤,
  삭제 결과를 상품 관리 목록 화면으로 다시 연결해 주도록 정리했다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.product.ProductService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();

    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
        return;
    }

    String productId = request.getParameter("productId");
    if (productId != null && !productId.isBlank()) {
        new ProductService().deleteProduct(productId);
    }

    response.sendRedirect(contextPath + "/product/list.jsp");
%>
