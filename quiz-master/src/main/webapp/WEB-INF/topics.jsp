<%-- 20251258 김상범
5개의 퀴즈 주제를 카드 형태로 표시하고 선택할 수 있는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, kr.ac.dy.cs.quizmaster.dto.QuizTopic, kr.ac.dy.cs.quizmaster.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<QuizTopic> topics = (List<QuizTopic>) request.getAttribute("topics");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - 주제 선택</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; margin: 0; padding: 0; }
        .header { background: #1a73e8; color: white; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .header .right { display: flex; align-items: center; gap: 16px; }
        .header .right a { color: white; text-decoration: none; font-size: 14px; }
        .container { max-width: 720px; margin: 40px auto; padding: 0 16px; }
        .container h2 { color: #333; margin-bottom: 24px; }
        .topic-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .topic-card { background: white; border-radius: 10px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; text-decoration: none; display: block; color: inherit; }
        .topic-card:hover { transform: translateY(-4px); box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        .topic-card h3 { margin: 0 0 8px 0; color: #1a73e8; }
        .topic-card p { margin: 0; color: #666; font-size: 14px; }
        .topic-card .badge { display: inline-block; margin-top: 12px; background: #e8f0fe; color: #1a73e8; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        @media (max-width: 600px) { .topic-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="header">
        <h1>QuizMaster</h1>
        <div class="right">
            <span><%= user.getName() %>님</span>
            <a href="<%= request.getContextPath() %>/results">내 기록</a>
            <a href="<%= request.getContextPath() %>/logout">로그아웃</a>
        </div>
    </div>
    <div class="container">
        <h2>퀴즈 주제를 선택하세요</h2>
        <div class="topic-grid">
            <% for (QuizTopic topic : topics) { %>
                <a class="topic-card" href="<%= request.getContextPath() %>/quiz?topicId=<%= topic.getTopicId() %>">
                    <h3><%= topic.getTopicName() %></h3>
                    <p><%= topic.getDescription() %></p>
                    <span class="badge">도전하기</span>
                </a>
            <% } %>
        </div>
    </div>
</body>
</html>
