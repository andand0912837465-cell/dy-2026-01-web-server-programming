// 20251258 김상범
// 선택한 주제의 퀴즈 문제를 출력하고 제출된 답안을 채점하는 서블릿
package kr.ac.dy.cs.quizmaster.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.dy.cs.quizmaster.dto.QuizQuestion;
import kr.ac.dy.cs.quizmaster.dto.QuizResult;
import kr.ac.dy.cs.quizmaster.dto.User;
import kr.ac.dy.cs.quizmaster.service.QuizService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int topicId = Integer.parseInt(req.getParameter("topicId"));
        req.setAttribute("topic", quizService.getTopic(topicId));
        req.setAttribute("questions", quizService.getQuestions(topicId));
        req.getRequestDispatcher("/WEB-INF/quiz.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        int topicId = Integer.parseInt(req.getParameter("topicId"));
        List<QuizQuestion> questions = quizService.getQuestions(topicId);

        List<Integer> userAnswers = new ArrayList<>();
        for (int i = 0; i < questions.size(); i++) {
            String answer = req.getParameter("q" + i);
            userAnswers.add(answer != null ? Integer.parseInt(answer) : 0);
        }

        QuizResult result = quizService.gradeQuiz(user.getUserId(), topicId, userAnswers, questions);
        req.setAttribute("result", result);
        req.setAttribute("questions", questions);
        req.setAttribute("userAnswers", userAnswers);
        req.getRequestDispatcher("/WEB-INF/result.jsp").forward(req, resp);
    }
}
