<%--
  20252377 양효재
  부분 구현된 상품 등록과 수정 화면이 남아 있어서 개선 진행하였다.
  관리자가 기존 상품을 불러와 수정하거나 새 상품을 직접 등록할 수 있게,
  PRODUCT_DETAIL 컬럼을 폼 형태로 정리해서 한 화면에서 처리하도록 맞췄다.
  20252377 양효재
  부분 구현된 재고 관리 항목이 남아 있어서 개선 진행하였다.
  상품 등록과 수정 화면에서 재고 수량도 같이 입력할 수 있게 해서,
  백오피스에서 재고값까지 바로 관리하도록 보완했다.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.product.ProductDto" %>
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
    ProductDto product = null;
    if (productId != null && !productId.isBlank()) {
        product = new ProductService().getProduct(productId);
    }
    boolean editMode = product != null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= editMode ? "상품 수정" : "상품 등록" %></title>
</head>
<body>
<h2><%= editMode ? "상품 수정" : "상품 등록" %></h2>
<form action="<%= contextPath %>/product/save.jsp" method="post">
    <table border="1" cellpadding="8">
        <tr><th>상품 ID</th><td><input type="text" name="productId" value="<%= editMode ? product.getProductId() : "" %>" <%= editMode ? "readonly" : "" %>></td></tr>
        <tr><th>상품명</th><td><input type="text" name="name" value="<%= editMode ? product.getName() : "" %>"></td></tr>
        <tr><th>브랜드</th><td><input type="text" name="brand" value="<%= editMode ? product.getBrand() : "" %>"></td></tr>
        <tr><th>카테고리</th><td><input type="text" name="category" value="<%= editMode ? product.getCategory() : "" %>"></td></tr>
        <tr><th>정가</th><td><input type="number" name="originalPrice" value="<%= editMode ? product.getOriginalPrice() : 0 %>"></td></tr>
        <tr><th>판매가</th><td><input type="number" name="salePrice" value="<%= editMode ? product.getSalePrice() : 0 %>"></td></tr>
        <tr><th>할인율</th><td><input type="number" name="discountRate" value="<%= editMode ? product.getDiscountRate() : 0 %>"></td></tr>
        <tr><th>기본 평점</th><td><input type="text" name="basicRate" value="<%= editMode ? product.getBasicRate() : 0 %>"></td></tr>
        <tr><th>기존 리뷰수</th><td><input type="number" name="oldReviewCount" value="<%= editMode ? product.getOldReviewCount() : 0 %>"></td></tr>
        <tr><th>재고 수량</th><td><input type="number" name="stock" value="<%= editMode ? product.getStock() : 0 %>"></td></tr>
        <tr><th>이미지 URL</th><td><input type="text" name="imageUrl" value="<%= editMode ? product.getImageUrl() : "" %>" style="width:500px;"></td></tr>
        <tr><th>배지</th><td><input type="text" name="badge" value="<%= editMode ? product.getBadge() : "" %>"></td></tr>
        <tr><th>상품 설명</th><td><textarea name="detailText" rows="8" cols="80"><%= editMode && product.getDetailText() != null ? product.getDetailText() : "" %></textarea></td></tr>
        <tr><th>배송 설명</th><td><textarea name="deliveryText" rows="5" cols="80"><%= editMode && product.getDeliveryText() != null ? product.getDeliveryText() : "" %></textarea></td></tr>
    </table>
    <br>
    <button type="submit">저장</button>
    <a href="<%= contextPath %>/product/list.jsp">목록</a>
</form>
</body>
</html>
