// 20251258 김상범
// 전체 퀴즈 주제 목록을 조회하여 뷰에 전달하는 서블릿
package kr.ac.dy.cs.quizmaster.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.dy.cs.quizmaster.service.QuizService;

import java.io.IOException;

@WebServlet("/topics")
public class TopicListServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("topics", quizService.getAllTopics());
        req.getRequestDispatcher("/WEB-INF/topics.jsp").forward(req, resp);
    }
}
