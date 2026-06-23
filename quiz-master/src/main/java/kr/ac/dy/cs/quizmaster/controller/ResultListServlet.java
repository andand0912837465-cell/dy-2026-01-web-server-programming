// 20251258 김상범
// 로그인한 사용자의 퀴즈 풀이 기록을 조회하여 보여주는 서블릿
package kr.ac.dy.cs.quizmaster.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.dy.cs.quizmaster.dto.User;
import kr.ac.dy.cs.quizmaster.service.QuizService;

import java.io.IOException;

@WebServlet("/results")
public class ResultListServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        req.setAttribute("results", quizService.getResults(user.getUserId()));
        req.getRequestDispatcher("/WEB-INF/results.jsp").forward(req, resp);
    }
}
