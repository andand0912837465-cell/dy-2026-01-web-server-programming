// 20251258 김상범
// 퀴즈 주제 정보를 저장하는 데이터 전송 객체 (DTO)
package kr.ac.dy.cs.quizmaster.dto;

public class QuizTopic {
    private int topicId;
    private String topicName;
    private String description;

    public QuizTopic() {}

    public QuizTopic(int topicId, String topicName, String description) {
        this.topicId = topicId;
        this.topicName = topicName;
        this.description = description;
    }

    public int getTopicId() { return topicId; }
    public void setTopicId(int topicId) { this.topicId = topicId; }
    public String getTopicName() { return topicName; }
    public void setTopicName(String topicName) { this.topicName = topicName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
