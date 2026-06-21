<%--
    20252364 강한서

    장바구니 목록을 출력하는 JSP 페이지이다.
    세션에 저장된 장바구니 상품 목록을 가져와 상품명, 가격, 수량, 합계 금액을 화면에 출력한다.

    세션에 저장된 장바구니 목록을 조회한다.
    상품별 이미지, 상품명, 가격, 수량, 합계 금액을 출력한다.
    전체 상품의 총 결제 금액을 계산하여 출력한다.
    장바구니가 비어 있으면 안내 문구를 출력한다.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    List<Map<String, String>> cart =
            (List<Map<String, String>>) session.getAttribute("cart");

    int totalPrice = 0;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니 - SHOPMALL</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <style>
        .cart-wrap {
            width: 1100px;
            margin: 50px auto;
        }

        .cart-title {
            font-size: 32px;
            margin-bottom: 30px;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .cart-table th,
        .cart-table td {
            padding: 18px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }

        .cart-table th {
            background: #f5f6f8;
        }

        .cart-img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 10px;
        }

        .cart-total {
            margin-top: 30px;
            text-align: right;
            font-size: 24px;
            font-weight: bold;
        }

        .cart-actions {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }

        .cart-btn {
            display: inline-block;
            padding: 14px 24px;
            background: #2f3a3a;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        .empty {
            padding: 60px;
            background: white;
            text-align: center;
            border-radius: 12px;
            color: #777;
        }
    </style>
</head>
<body>

<div class="cart-wrap">
    <h1 class="cart-title">장바구니</h1>

    <% if (cart == null || cart.isEmpty()) { %>
    <div class="empty">
        장바구니에 담긴 상품이 없습니다.
    </div>
    <% } else { %>
    <table class="cart-table">
        <thead>
        <tr>
            <th>이미지</th>
            <th>상품명</th>
            <th>가격</th>
            <th>수량</th>
            <th>합계</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, String> item : cart) {
                int price = Integer.parseInt(item.get("price"));
                int qty = Integer.parseInt(item.get("qty"));
                int itemTotal = price * qty;
                totalPrice += itemTotal;
        %>
        <tr>
            <td>
                <% if (item.get("image") != null && item.get("image").length() > 0) { %>
                <img class="cart-img" src="<%= item.get("image") %>" alt="<%= item.get("name") %>">
                <% } else { %>
                -
                <% } %>
            </td>
            <td><%= item.get("name") %></td>
            <td><%= String.format("%,d", price) %>원</td>
            <td><%= qty %></td>
            <td><%= String.format("%,d", itemTotal) %>원</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="cart-total">
        총 금액: <%= String.format("%,d", totalPrice) %>원
    </div>
    <% } %>

    <div class="cart-actions">
        <a class="cart-btn" href="<%= request.getContextPath() %>/index.jsp">쇼핑 계속하기</a>
        <a class="cart-btn" href="<%= request.getContextPath() %>/cart/clear.jsp">장바구니 비우기</a>
    </div>
</div>

</body>
</html>