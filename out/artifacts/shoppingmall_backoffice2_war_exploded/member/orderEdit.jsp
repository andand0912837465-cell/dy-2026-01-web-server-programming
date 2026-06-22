<%@ page import="kr.ac.dy.cs.order.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 주문 관리 탭 -->

<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="orderUpdate.jsp" method="post">

    <input type="hidden"
           name="orderId"
           value="<%= request.getParameter("orderId") %>">

    <select name="status">

        <option>결제완료</option>

        <option>상품준비중</option>

        <option>배송중</option>

        <option>배송완료</option>

        <option>주문취소</option>

    </select>

    <button type="submit">
        저장
    </button>

</form>
</body>
</html>
