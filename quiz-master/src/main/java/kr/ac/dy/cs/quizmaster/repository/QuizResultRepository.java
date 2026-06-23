// 20251258 김상범
// QUIZ_RESULT 테이블에 결과를 저장하고 사용자별 기록을 조회하는 DAO 클래스
package kr.ac.dy.cs.quizmaster.repository;

import kr.ac.dy.cs.quizmaster.dto.QuizResult;
import kr.ac.dy.cs.quizmaster.util.QuizH2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class QuizResultRepository {
    private final QuizH2DbConnector connector = new QuizH2DbConnector();

    public void save(QuizResult result) {
        String sql = "INSERT INTO QUIZ_RESULT (user_id, topic_id, score, total, attempt_date) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, result.getUserId());
            pstmt.setInt(2, result.getTopicId());
            pstmt.setInt(3, result.getScore());
            pstmt.setInt(4, result.getTotal());
            pstmt.setTimestamp(5, Timestamp.valueOf(result.getAttemptDate()));
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<QuizResult> findByUserId(String userId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = """
            SELECT r.*, t.topic_name
            FROM QUIZ_RESULT r
            JOIN QUIZ_TOPIC t ON r.topic_id = t.topic_id
            WHERE r.user_id = ?
            ORDER BY r.attempt_date DESC
        """;
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    QuizResult r = new QuizResult();
                    r.setResultId(rs.getInt("result_id"));
                    r.setUserId(rs.getString("user_id"));
                    r.setTopicId(rs.getInt("topic_id"));
                    r.setTopicName(rs.getString("topic_name"));
                    r.setScore(rs.getInt("score"));
                    r.setTotal(rs.getInt("total"));
                    r.setAttemptDate(rs.getTimestamp("attempt_date").toLocalDateTime());
                    results.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }
}
