<%--
  20252377 양효재
  부분 구현된 상품 저장 처리 로직이 남아 있어서 개선 진행하였다.
  등록과 수정 요청을 한곳에서 받아 숫자값을 정리한 뒤,
  ProductService를 통해 실제 PRODUCT_DETAIL 저장으로 연결하도록 정리했다.
  20252377 양효재
  부분 구현된 재고 관리 항목이 남아 있어서 개선 진행하였다.
  저장 처리에서도 재고 수량을 같이 받아서 정수로 맞춘 뒤,
  상품 등록과 수정 시 재고값이 함께 저장되도록 보완했다.
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

    ProductDto product = new ProductDto();
    product.setProductId(request.getParameter("productId"));
    product.setName(request.getParameter("name"));
    product.setBrand(request.getParameter("brand"));
    product.setCategory(request.getParameter("category"));
    product.setOriginalPrice(parseInt(request.getParameter("originalPrice")));
    product.setSalePrice(parseInt(request.getParameter("salePrice")));
    product.setDiscountRate(parseInt(request.getParameter("discountRate")));
    product.setBasicRate(parseDouble(request.getParameter("basicRate")));
    product.setOldReviewCount(parseInt(request.getParameter("oldReviewCount")));
    product.setStock(parseInt(request.getParameter("stock")));
    product.setImageUrl(request.getParameter("imageUrl"));
    product.setBadge(request.getParameter("badge"));
    product.setDetailText(request.getParameter("detailText"));
    product.setDeliveryText(request.getParameter("deliveryText"));

    ProductService service = new ProductService();
    boolean exists = service.getProduct(product.getProductId()) != null;
    boolean result = exists ? service.updateProduct(product) : service.createProduct(product);

    response.sendRedirect(contextPath + "/product/list.jsp" + (result ? "?productId=" + product.getProductId() : ""));
%>
<%!
    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0.0;
        }
    }
%>
