<%--
20251240 공호준
OTP 2차 인증을 위한 페이지임.
코드를 입력받아 코드를 인증하는 otpservlet 클래스로 정보를 전송함.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>OTP 2차 인증</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
    .container { display: inline-block; padding: 20px; border: 1px solid #ccc; border-radius: 10px; }
    .qr-box { margin: 20px 0; }
    .input-group { margin-top: 15px; }
    input[type="text"] { padding: 8px; font-size: 16px; width: 150px; text-align: center; }
    input[type="submit"] { padding: 8px 15px; font-size: 16px; background-color: #007bff; color: white; border: none; cursor: pointer; }
  </style>
</head>
<body>

<div class="container">
  <h2>구글 OTP 2차 인증</h2>

  <hr>

  <form action="../otp" method="POST">
    <div class="input-group">
      <label for="otpCode">OTP 번호 6자리 입력: </label><br><br>
      <input type="text" id="otpCode" name="otpCode" placeholder="000000" maxlength="6" autocomplete="off" required>
      <input type="submit" value="인증하기">
    </div>
  </form>
</div>

</body>
</html>
