/**
 * 99999999 박규태
 * 회원테이블에 데이터를 저장하는 기능을 구현한 클래스
 */
package kr.ac.dy.cs.member;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;
import kr.ac.dy.cs.util.SHA256;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * member테이블 데이터 처리
 */
public class MemberRepository {

    /**
     * 회원정보를 리턴(by id, password)
     * 입력받은 userId와 password값에 일치하는 member 테이블의 값을 리턴
     */
    public MemberDto select(String userId, String password) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            select id, name, email, password, otp_key
            from safe_member
            where id = ? and password = ?
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, userId);
            psmt.setString(2, SHA256.hashing(password));

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    member = mapMember(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return member;
    }

    /**
     * member테이블 insert
     */
    public int insert(MemberDto member) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = "insert into safe_member (id, name, email, password, otp_key, reg_date) values (?, ?, ?, ?, ?, now())";

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, member.getUserId());
            psmt.setString(2, member.getUserName());
            psmt.setString(3, member.getEmail());
            psmt.setString(4, SHA256.hashing(member.getPassword()));
            psmt.setString(5, member.getOtp_key());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    public MemberDto selectById(String userId) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            select id, name, email, password, otp_key
            from safe_member
            where id = ?
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, userId);

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    member = mapMember(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return member;
    }

    private MemberDto mapMember(ResultSet rs) throws SQLException {
        MemberDto member = new MemberDto();
        member.setUserId(rs.getString("id"));
        member.setUserName(rs.getString("name"));
        member.setEmail(rs.getString("email"));
        member.setPassword(rs.getString("password"));
        member.setOtp_key(rs.getString("otp_key"));
        return member;
    }
}
