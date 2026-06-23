<%--
20251261 장문기
쇼핑몰 룰렛 이벤트 및 포인트 지급 기능
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>룰렛 이벤트</title>
</head>
<body>
<h1>룰렛 이벤트</h1>
<p>하루 1회 참여 가능합니다.</p>

<form action="roulette" method="post">
    <button type="submit">룰렛 돌리기</button>
</form>

<%
String message = (String)request.getAttribute("message");
if(message != null){
%>
<h2><%=message%></h2>
<%
}
%>

</body>
</html>
