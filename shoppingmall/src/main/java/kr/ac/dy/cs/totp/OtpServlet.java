/**
 * 20251240 공호준
 * OTP 2차 인증을 위한 클래스임.
 * 시크릿 키와 입력 코드를 받아 입력이 올바른지 아닌지 확인한 뒤 결과를 반환함.
 */

package kr.ac.dy.cs.totp;

import org.jboss.aerogear.security.otp.Totp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/otp")
public class OtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String userSecretKey = (String) session.getAttribute("userOtpSecretKey");
        String userCode = request.getParameter("otpCode");
        session.removeAttribute("userOtpSecretKey");

        boolean isSuccess = false;

        if (userSecretKey != null && userCode != null && !userCode.trim().isEmpty()) {
            try {
                Totp totp = new Totp(userSecretKey);
                if (totp.verify(userCode.trim())) {
                    isSuccess = true;
                    session.setAttribute("isOtpVerified", true);
                }
            } catch (Exception e) {
                isSuccess = false;
            }
        }

        request.setAttribute("otpSuccess", isSuccess);
        request.getRequestDispatcher("/auth/otpResult.jsp").forward(request, response);
    }
}
