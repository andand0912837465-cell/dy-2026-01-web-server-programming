<%-- 20251258 김상범
사용자가 그동안 응시한 모든 퀴즈의 기록을 표 형태로 조회하는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, kr.ac.dy.cs.quizmaster.dto.QuizResult, kr.ac.dy.cs.quizmaster.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<QuizResult> results = (List<QuizResult>) request.getAttribute("results");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QuizMaster - 내 기록</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; margin: 0; padding: 0; }
        .header { background: #1a73e8; color: white; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .header .right a { color: white; text-decoration: none; font-size: 14px; margin-left: 16px; }
        .container { max-width: 720px; margin: 30px auto; padding: 0 16px; }
        .container h2 { color: #333; margin-bottom: 24px; }
        .result-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .result-table th { background: #1a73e8; color: white; padding: 12px 16px; text-align: left; font-size: 14px; }
        .result-table td { padding: 12px 16px; border-bottom: 1px solid #eee; font-size: 14px; }
        .result-table tr:last-child td { border-bottom: none; }
        .result-table .score { font-weight: 600; }
        .result-table .high { color: #137333; }
        .result-table .mid { color: #e37400; }
        .result-table .low { color: #c5221f; }
        .empty { text-align: center; color: #999; padding: 48px; background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .back-link { display: inline-block; margin-top: 24px; color: #1a73e8; text-decoration: none; font-size: 14px; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="header">
        <h1>QuizMaster</h1>
        <div class="right">
            <span><%= user.getName() %>님</span>
            <a href="<%= request.getContextPath() %>/topics">주제 목록</a>
            <a href="<%= request.getContextPath() %>/logout">로그아웃</a>
        </div>
    </div>
    <div class="container">
        <h2>내 퀴즈 기록</h2>
        <% if (results.isEmpty()) { %>
            <div class="empty">아직 퀴즈를 푼 기록이 없습니다.</div>
        <% } else { %>
            <table class="result-table">
                <thead>
                    <tr>
                        <th>주제</th>
                        <th>점수</th>
                        <th>정답률</th>
                        <th>날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (QuizResult r : results) {
                        double pct = (double) r.getScore() / r.getTotal() * 100;
                        String cls = pct >= 80 ? "high" : (pct >= 60 ? "mid" : "low");
                    %>
                        <tr>
                            <td><%= r.getTopicName() %></td>
                            <td class="score <%= cls %>"><%= r.getScore() %> / <%= r.getTotal() %></td>
                            <td class="<%= cls %>"><%= String.format("%.0f", pct) %>%</td>
                            <td><%= r.getAttemptDate() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        <a href="<%= request.getContextPath() %>/topics" class="back-link">&larr; 주제 목록으로</a>
    </div>
</body>
</html>
