<%--
20251240 공호준
회원가입 성공 시 사용자가 OTP 앱에 등록할 QR 코드를 보여주기 위한 페이지임.
메인 페이지로 되돌아갈 수 있음.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>2차 OTP 인증</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .container { display: inline-block; padding: 20px; border: 1px solid #ccc; border-radius: 10px; }
        .qr-box { margin: 20px 0; }
        .input-group { margin-top: 15px; }
        input[type="text"] { padding: 8px; font-size: 16px; width: 150px; text-align: center; }
    </style>
</head>
<body>

<div class="container">
    <h2>구글 OTP 2차 인증</h2>
    <p>스마트폰의 Google Authenticator 앱으로 아래 QR코드를 스캔하세요. (또는 텍스트 입력)</p>
    <p>추후 로그인 시 필요한 정보이므로, 잘 저장해주세요.</p>

    <div class="qr-box">
        <img src="${qrCodeUrl}" alt="OTP QR Code">
    </div>

    <p>텍스트 키: <strong>${secretKey}</strong></p>
    <hr>

    <p><a href="../">돌아가기</a></p>
</div>

</body>
</html>
