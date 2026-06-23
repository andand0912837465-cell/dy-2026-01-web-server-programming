<%-- 20251258 김상범
퀴즈 채점 결과와 각 문제별 정답/오답 여부를 리뷰하는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, kr.ac.dy.cs.quizmaster.dto.QuizResult, kr.ac.dy.cs.quizmaster.dto.QuizQuestion, kr.ac.dy.cs.quizmaster.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    QuizResult result = (QuizResult) request.getAttribute("result");
    List<QuizQuestion> questions = (List<QuizQuestion>) request.getAttribute("questions");
    List<Integer> userAnswers = (List<Integer>) request.getAttribute("userAnswers");
    double pct = (double) result.getScore() / result.getTotal() * 100;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - 결과</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; margin: 0; padding: 0; }
        .header { background: #1a73e8; color: white; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .container { max-width: 720px; margin: 30px auto; padding: 0 16px; }
        .result-card { background: white; border-radius: 12px; padding: 32px; text-align: center; box-shadow: 0 2px 12px rgba(0,0,0,0.1); margin-bottom: 24px; }
        .result-card .score { font-size: 48px; font-weight: 700; color: #1a73e8; }
        .result-card .detail { color: #666; margin-top: 8px; font-size: 16px; }
        .result-card .message { margin-top: 16px; font-size: 18px; font-weight: 600; }
        .review-card { background: white; border-radius: 10px; padding: 24px; margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .review-card .q-text { font-weight: 600; margin-bottom: 12px; }
        .review-card .option { padding: 8px 12px; margin-bottom: 4px; border-radius: 6px; font-size: 14px; }
        .review-card .correct { background: #e6f4ea; color: #137333; }
        .review-card .wrong { background: #fce8e6; color: #c5221f; }
        .review-card .neutral { background: #f8f9fa; color: #333; }
        .btn-area { text-align: center; margin: 24px 0; }
        .btn-area .btn { display: inline-block; padding: 12px 32px; background: #1a73e8; color: white; text-decoration: none; border-radius: 8px; margin: 0 8px; font-size: 16px; }
        .btn-area .btn:hover { background: #1557b0; }
        .btn-area .btn-outline { background: white; color: #1a73e8; border: 2px solid #1a73e8; }
        .btn-area .btn-outline:hover { background: #e8f0fe; }
    </style>
</head>
<body>
    <div class="header">
        <h1>QuizMaster</h1>
        <div class="right"><span><%= user.getName() %>님</span></div>
    </div>
    <div class="container">
        <div class="result-card">
            <div class="score"><%= result.getScore() %> / <%= result.getTotal() %></div>
            <div class="detail">정답률: <%= String.format("%.1f", pct) %>%</div>
            <div class="message">
                <% if (pct >= 80) { %>
                    축하합니다! 훌륭한 성적입니다!
                <% } else if (pct >= 60) { %>
                    잘 했어요! 조금만 더 노력해보세요.
                <% } else { %>
                    더 많은 연습이 필요합니다. 다시 도전하세요!
                <% } %>
            </div>
        </div>

        <% for (int i = 0; i < questions.size(); i++) {
            QuizQuestion q = questions.get(i);
            int userAns = userAnswers.get(i);
            boolean isCorrect = userAns == q.getCorrectAnswer();
        %>
            <div class="review-card">
                <div class="q-text"><%= i + 1 %>. <%= q.getQuestionText() %></div>
                <div class="option <%= q.getCorrectAnswer() == 1 ? "correct" : (userAns == 1 && !isCorrect ? "wrong" : "neutral") %>">
                    ① <%= q.getOption1() %> <%= q.getCorrectAnswer() == 1 ? "✓" : "" %>
                </div>
                <div class="option <%= q.getCorrectAnswer() == 2 ? "correct" : (userAns == 2 && !isCorrect ? "wrong" : "neutral") %>">
                    ② <%= q.getOption2() %> <%= q.getCorrectAnswer() == 2 ? "✓" : "" %>
                </div>
                <div class="option <%= q.getCorrectAnswer() == 3 ? "correct" : (userAns == 3 && !isCorrect ? "wrong" : "neutral") %>">
                    ③ <%= q.getOption3() %> <%= q.getCorrectAnswer() == 3 ? "✓" : "" %>
                </div>
                <div class="option <%= q.getCorrectAnswer() == 4 ? "correct" : (userAns == 4 && !isCorrect ? "wrong" : "neutral") %>">
                    ④ <%= q.getOption4() %> <%= q.getCorrectAnswer() == 4 ? "✓" : "" %>
                </div>
            </div>
        <% } %>

        <div class="btn-area">
            <a href="<%= request.getContextPath() %>/topics" class="btn">다른 주제 풀기</a>
            <a href="<%= request.getContextPath() %>/quiz?topicId=<%= result.getTopicId() %>" class="btn btn-outline">다시 도전</a>
            <a href="<%= request.getContextPath() %>/results" class="btn btn-outline">내 기록</a>
        </div>
    </div>
</body>
</html>
