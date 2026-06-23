// 20251258 김상범
// QUIZ_TOPIC 테이블에서 퀴즈 주제 목록을 조회하는 DAO 클래스
package kr.ac.dy.cs.quizmaster.repository;

import kr.ac.dy.cs.quizmaster.dto.QuizTopic;
import kr.ac.dy.cs.quizmaster.util.QuizH2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class QuizTopicRepository {
    private final QuizH2DbConnector connector = new QuizH2DbConnector();

    public List<QuizTopic> findAll() {
        List<QuizTopic> topics = new ArrayList<>();
        String sql = "SELECT * FROM QUIZ_TOPIC ORDER BY topic_id";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                QuizTopic topic = new QuizTopic();
                topic.setTopicId(rs.getInt("topic_id"));
                topic.setTopicName(rs.getString("topic_name"));
                topic.setDescription(rs.getString("description"));
                topics.add(topic);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topics;
    }

    public QuizTopic findById(int topicId) {
        String sql = "SELECT * FROM QUIZ_TOPIC WHERE topic_id = ?";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, topicId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    QuizTopic topic = new QuizTopic();
                    topic.setTopicId(rs.getInt("topic_id"));
                    topic.setTopicName(rs.getString("topic_name"));
                    topic.setDescription(rs.getString("description"));
                    return topic;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
