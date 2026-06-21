/**
 * 20251240 공호준
 * OTP 2차 인증 등록 클래스임.
 * 회원가입 후 Google Authenticator 등 OTP 앱에서 사용할 QR 코드를 생성함.
 * 회원가입이 정상적으로 완료되었을 때만 실행됨.
 * 시크릿 키는 DB에 저장되어 있어 사용자별로 앱에 1번 등록하면 그걸 재사용할 수 있음.
 */

package kr.ac.dy.cs.totp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/otp/register")
public class OtpRegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String userSecretKey = (String) session.getAttribute("userOtpSecretKey");
        String userEmail = (String) session.getAttribute("userEmail");

        session.removeAttribute("userOtpSecretKey");
        session.removeAttribute("userEmail");

        if (userSecretKey == null || userSecretKey.trim().isEmpty()) {
            response.sendRedirect("../member/register.jsp");
            return;
        }

        String issuer = "Shoppingmall";
        if (userEmail == null) userEmail = "user@example.com";

        // QR 생성
        String qrCodeUrl = String.format(
                "https://api.qrserver.com/v1/create-qr-code/?data=otpauth://totp/%s:%s?secret=%s&issuer=%s&size=200x200",
                issuer, userEmail, userSecretKey, issuer
        );

        request.setAttribute("secretKey", userSecretKey);
        request.setAttribute("qrCodeUrl", qrCodeUrl);

        request.getRequestDispatcher("../member/registerSuccess.jsp").forward(request, response);
    }
}
