/**
 * 20251261 장문기
 * 쇼핑몰 룰렛 이벤트 처리 Servlet
 */
package kr.ac.dy.cs.roulette;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/roulette")
public class RouletteServlet extends HttpServlet {

    private final RouletteService service = new RouletteService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String loginId = (String) request.getSession().getAttribute("loginId");

        if (loginId == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.getRequestDispatcher("/roulette.jsp").forward(request, response);
            return;
        }

        int result = service.spin(loginId);

        if (result == -1) {
            request.setAttribute("message", "오늘은 이미 참여하셨습니다.");
        } else {
            request.setAttribute("message", result + " 포인트 획득!");
        }

        request.getRequestDispatcher("/roulette.jsp").forward(request, response);
    }
}
