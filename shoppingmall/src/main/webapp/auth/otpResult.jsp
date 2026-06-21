<%--
20251240 공호준
OTP 인증 결과를 알려주는 페이지임.
성공 시 메인 페이지로 넘기고, 실패하면 다시 시도할 수 있게 되돌아감.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Boolean otpSuccess = (Boolean) request.getAttribute("otpSuccess");
  if (otpSuccess != null && otpSuccess) {
    String tempId = (String) session.getAttribute("tempLoginId");
    session.setAttribute("loginId", tempId);
    session.removeAttribute("tempLoginId");
  }
%>
<html>
<head>
  <title>인증 결과 처리</title>
  <script type="text/javascript">
    window.onload = function() {
      <% if (otpSuccess) { %>
      location.href = "/";
      <% } else { %>
      alert("인증 실패! 코드를 다시 확인해주세요.");
      // 실패 시 다시 OTP 입력 페이지로 이동
      location.href = "./auth/otp.jsp";
      <% } %>
    };
  </script>
</head>
<body>
<p>인증 결과를 처리 중입니다...</p>
</body>
</html>
