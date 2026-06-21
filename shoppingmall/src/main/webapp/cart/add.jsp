<%--
    20252364 강한서

    장바구니 상품 추가를 처리하는 JSP 페이지이다.
    메인 페이지나 상품 상세 페이지에서 전달받은 상품 정보를 세션 장바구니에 저장한다.
    상품 번호, 상품명, 가격, 이미지 정보를 전달받는다.
    세션에 장바구니가 없으면 새로 생성한다.
    이미 담긴 상품이면 수량을 증가시킨다.
    처음 담는 상품이면 장바구니 목록에 새로 추가한다.
    처리 후 장바구니 페이지로 이동한다.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String image = request.getParameter("image");

    if (id == null || name == null || price == null) {
        response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
        return;
    }

    List<Map<String, String>> cart =
            (List<Map<String, String>>) session.getAttribute("cart");

    if (cart == null) {
        cart = new ArrayList<>();
    }

    boolean exists = false;

    for (Map<String, String> item : cart) {
        if (id.equals(item.get("id"))) {
            int qty = Integer.parseInt(item.get("qty"));
            item.put("qty", String.valueOf(qty + 1));
            exists = true;
            break;
        }
    }

    if (!exists) {
        Map<String, String> item = new HashMap<>();
        item.put("id", id);
        item.put("name", name);
        item.put("price", price);
        item.put("image", image == null ? "" : image);
        item.put("qty", "1");
        cart.add(item);
    }

    session.setAttribute("cart", cart);

    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");
%>