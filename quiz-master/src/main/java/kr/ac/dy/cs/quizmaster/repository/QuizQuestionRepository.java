// 20251258 김상범
// QUIZ_QUESTION 테이블에서 특정 주제의 문제를 조회하는 DAO 클래스
package kr.ac.dy.cs.quizmaster.repository;

import kr.ac.dy.cs.quizmaster.dto.QuizQuestion;
import kr.ac.dy.cs.quizmaster.util.QuizH2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class QuizQuestionRepository {
    private final QuizH2DbConnector connector = new QuizH2DbConnector();

    public List<QuizQuestion> findByTopicId(int topicId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM QUIZ_QUESTION WHERE topic_id = ? ORDER BY question_id";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, topicId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = new QuizQuestion();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setTopicId(rs.getInt("topic_id"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setOption1(rs.getString("option1"));
                    q.setOption2(rs.getString("option2"));
                    q.setOption3(rs.getString("option3"));
                    q.setOption4(rs.getString("option4"));
                    q.setCorrectAnswer(rs.getInt("correct_answer"));
                    questions.add(q);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questions;
    }
}
