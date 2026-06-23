// 20251258 김상범
// 퀴즈 문제와 4개 보기 및 정답 정보를 저장하는 데이터 전송 객체 (DTO)
package kr.ac.dy.cs.quizmaster.dto;

public class QuizQuestion {
    private int questionId;
    private int topicId;
    private String questionText;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private int correctAnswer;

    public QuizQuestion() {}

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public int getTopicId() { return topicId; }
    public void setTopicId(int topicId) { this.topicId = topicId; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getOption1() { return option1; }
    public void setOption1(String option1) { this.option1 = option1; }
    public String getOption2() { return option2; }
    public void setOption2(String option2) { this.option2 = option2; }
    public String getOption3() { return option3; }
    public void setOption3(String option3) { this.option3 = option3; }
    public String getOption4() { return option4; }
    public void setOption4(String option4) { this.option4 = option4; }
    public int getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(int correctAnswer) { this.correctAnswer = correctAnswer; }
}
