<%--
  20252365 조준혁
  제품 리뷰를 삭제하는 기능을 처리하는 JSP 페이지.
  관리자 상품관리 페이지에서 삭제 버튼을 누르면 이 페이지가 호출된다.
  리뷰 정보는 PRODUCT_REVIEW 테이블에서 삭제된다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.product.ProductService" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
    if (!SessionUtils.isLoginYn(session)) {
        response.sendRedirect(contextPath + "/auth/adminLogin.jsp");
        return;
    }

    String productId = request.getParameter("productId");
    String reviewNoText = request.getParameter("reviewNo");

    if (productId == null || productId.trim().equals("")) {
        productId = "";
    } else {
        productId = productId.trim();
    }

    long reviewNo = 0;
    try {
        reviewNo = Long.parseLong(reviewNoText);
    } catch (Exception e) {
        reviewNo = 0;
    }

    ProductService productService = new ProductService();
    boolean deleted = productService.deleteReview(reviewNo, productId);

    String redirectUrl = contextPath + "/product/list.jsp";
    if (!productId.equals("")) {
        redirectUrl += "?productId=" + URLEncoder.encode(productId, "UTF-8");
    }

    if (!deleted) {
%>
<script>
    alert('리뷰 삭제에 실패했습니다.');
    location.href = '<%= redirectUrl %>';
</script>
<%
        return;
    }

    response.sendRedirect(redirectUrl);
%>
