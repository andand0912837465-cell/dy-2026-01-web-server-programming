<%@ page import="kr.ac.dy.cs.member.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="kr.ac.dy.cs.order.*" %>
<%@ page import="java.util.*" %>
<!-- 회원의 상세 정보와 주문 내역들을 열람시켜주는 페이지-->

<%
    String id = request.getParameter("id");

    MemberService service = new MemberService();
    MemberDto member = service.getMember(id);

    OrderService orderService =
            new OrderService();

    List<OrderDto> orders =
            orderService.getOrders(id);

    if(member == null){
%>
회원이 존재하지 않습니다.
<%
        return;
    }
%>

<html>
<head>
    <title>회원 상세정보</title>
</head>
<body>

<h2>회원 상세정보</h2>

<table border="1">
    <tr>
        <th>아이디</th>
        <td><%= member.getUserId() %></td>
    </tr>

    <tr>
        <th>이름</th>
        <td><%= member.getUserName() %></td>
    </tr>

    <tr>
        <th>이메일</th>
        <td><%= member.getEmail() %></td>
    </tr>

    <tr>
        <th>비밀번호</th>
        <td><%= member.getPassword() %></td>
    </tr>


</table>

<br>

<h3>거래 내역</h3>

<table border="1">

    <tr>
        <th>주문번호</th>
        <th>상품명</th>
        <th>가격</th>
        <th>수량</th>
        <th>상태</th>
        <th>관리</th>
    </tr>

    <%
        for(OrderDto order : orders){
    %>

    <tr>
        <td><%= order.getOrderId() %></td>
        <td><%= order.getProductName() %></td>
        <td><%= order.getPrice() %></td>
        <td><%= order.getQuantity() %></td>
        <td><%= order.getStatus() %></td>

        <td>
            <a href="<%= request.getContextPath() %>/order/view.jsp?orderId=<%= order.getOrderId() %>">
                주문상세
            </a>
        </td>
    </tr>

    <%
        }
    %>

</table>
<h3>거래 내역</h3>

주문 개수 : <%= orders.size() %>
<hr>

현재 회원 ID : <%= id %>
<hr>

<table border="1">
<br>

<a href="edit.jsp?id=<%= member.getUserId() %>">수정</a>
<a href="list.jsp">목록</a>

</body>
</html>
