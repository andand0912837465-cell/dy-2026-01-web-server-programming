// 20251258 김상범
// QUIZ_USER 테이블에 접근하여 사용자 데이터를 조회 및 저장하는 DAO 클래스
package kr.ac.dy.cs.quizmaster.repository;

import kr.ac.dy.cs.quizmaster.dto.User;
import kr.ac.dy.cs.quizmaster.util.QuizH2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserRepository {
    private final QuizH2DbConnector connector = new QuizH2DbConnector();

    public User findByUserId(String userId) {
        String sql = "SELECT * FROM QUIZ_USER WHERE user_id = ?";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getString("user_id"));
                    user.setName(rs.getString("name"));
                    user.setPassword(rs.getString("password"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void save(User user) {
        String sql = "INSERT INTO QUIZ_USER (user_id, name, password) VALUES (?, ?, ?)";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getName());
            pstmt.setString(3, user.getPassword());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
