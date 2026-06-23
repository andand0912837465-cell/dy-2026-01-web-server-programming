// 20251258 김상범
// 사용자의 퀴즈 풀이 결과 정보를 저장하는 데이터 전송 객체 (DTO)
package kr.ac.dy.cs.quizmaster.dto;

import java.time.LocalDateTime;

public class QuizResult {
    private int resultId;
    private String userId;
    private int topicId;
    private String topicName;
    private int score;
    private int total;
    private LocalDateTime attemptDate;

    public QuizResult() {}

    public int getResultId() { return resultId; }
    public void setResultId(int resultId) { this.resultId = resultId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getTopicId() { return topicId; }
    public void setTopicId(int topicId) { this.topicId = topicId; }
    public String getTopicName() { return topicName; }
    public void setTopicName(String topicName) { this.topicName = topicName; }
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }
    public LocalDateTime getAttemptDate() { return attemptDate; }
    public void setAttemptDate(LocalDateTime attemptDate) { this.attemptDate = attemptDate; }
}
