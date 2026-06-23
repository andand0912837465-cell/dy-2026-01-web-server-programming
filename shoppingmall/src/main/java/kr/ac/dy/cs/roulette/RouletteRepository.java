/**
 * 20251261 장문기
 * 쇼핑몰 룰렛 이벤트 결과 저장 Repository
 */
package kr.ac.dy.cs.roulette;

import kr.ac.dy.cs.util.H2DbConnector;
import java.sql.*;

public class RouletteRepository {
    private final H2DbConnector connector = new H2DbConnector();

    public void insert(RouletteDto dto) {
        String sql = "insert into roulette(user_id, point, play_date) values (?, ?, CURRENT_DATE)";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getUserId());
            pstmt.setInt(2, dto.getPoint());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean alreadyPlayedToday(String userId) {
        String sql = "select count(*) from roulette where user_id=? and play_date=CURRENT_DATE";
        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
