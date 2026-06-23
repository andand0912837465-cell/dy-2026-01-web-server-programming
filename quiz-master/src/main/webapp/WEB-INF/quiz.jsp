<%-- 20251258 김상범
선택한 주제의 객관식 문제를 표시하고 답안을 제출받는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, kr.ac.dy.cs.quizmaster.dto.QuizTopic, kr.ac.dy.cs.quizmaster.dto.QuizQuestion, kr.ac.dy.cs.quizmaster.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    QuizTopic topic = (QuizTopic) request.getAttribute("topic");
    List<QuizQuestion> questions = (List<QuizQuestion>) request.getAttribute("questions");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - <%= topic.getTopicName() %></title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; margin: 0; padding: 0; }
        .header { background: #1a73e8; color: white; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .header .right span { font-size: 14px; }
        .container { max-width: 720px; margin: 30px auto; padding: 0 16px; }
        .topic-title { color: #333; margin-bottom: 24px; font-size: 20px; }
        .question-card { background: white; border-radius: 10px; padding: 24px; margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .question-card .q-text { font-weight: 600; margin-bottom: 16px; font-size: 16px; }
        .question-card .q-num { color: #1a73e8; font-weight: 700; }
        .question-card label { display: block; padding: 12px 16px; margin-bottom: 8px; border: 1px solid #e0e0e0; border-radius: 8px; cursor: pointer; transition: background 0.2s; font-size: 14px; }
        .question-card label:hover { background: #f5f7fa; }
        .question-card input[type="radio"] { margin-right: 10px; }
        .submit-area { text-align: center; margin: 24px 0; }
        .submit-area .btn { padding: 14px 48px; background: #1a73e8; color: white; border: none; border-radius: 8px; font-size: 18px; cursor: pointer; }
        .submit-area .btn:hover { background: #1557b0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>QuizMaster</h1>
        <div class="right"><span><%= user.getName() %>님</span></div>
    </div>
    <div class="container">
        <div class="topic-title"><%= topic.getTopicName() %> - 총 <%= questions.size() %>문제</div>
        <form action="<%= request.getContextPath() %>/quiz" method="post" onsubmit="return confirmSubmit()">
            <input type="hidden" name="topicId" value="<%= topic.getTopicId() %>">
            <% for (int i = 0; i < questions.size(); i++) { %>
                <div class="question-card">
                    <div class="q-text"><span class="q-num"><%= i + 1 %>.</span> <%= questions.get(i).getQuestionText() %></div>
                    <label><input type="radio" name="q<%= i %>" value="1" required> <%= questions.get(i).getOption1() %></label>
                    <label><input type="radio" name="q<%= i %>" value="2"> <%= questions.get(i).getOption2() %></label>
                    <label><input type="radio" name="q<%= i %>" value="3"> <%= questions.get(i).getOption3() %></label>
                    <label><input type="radio" name="q<%= i %>" value="4"> <%= questions.get(i).getOption4() %></label>
                </div>
            <% } %>
            <div class="submit-area">
                <button type="submit" class="btn">제출하기</button>
            </div>
        </form>
    </div>
    <script>
        function confirmSubmit() {
            return confirm("정말 제출하시겠습니까?");
        }
    </script>
</body>
</html>
