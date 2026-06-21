package kr.ac.dy.cs.member;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;
import kr.ac.dy.cs.util.SHA256;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * member테이블 데이터 처리
 */
public class MemberRepository {

    /**
     * 회원목록 전체 조회
     */
    public List<MemberDto> selectAll() {
        List<MemberDto> members = new ArrayList<>();
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            select id, name, email, password, reg_date
            from safe_member
            order by reg_date desc
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                members.add(mapMember(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return members;
    }

    /**
     * 회원정보를 리턴(by id, password)
     */
    public MemberDto select(String userId, String password) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            select id, name, email, password, reg_date
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
     * 회원 단건 조회
     */
    public MemberDto selectById(String userId) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            select id, name, email, password, reg_date
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

    /**
     * member테이블 insert
     */
    public int insert(MemberDto member) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = "insert into safe_member (id, name, email, password, reg_date) values (?, ?, ?, ?, now())";

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, member.getUserId());
            psmt.setString(2, member.getUserName());
            psmt.setString(3, member.getEmail());
            psmt.setString(4, SHA256.hashing(member.getPassword()));
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    /**
     * 회원 정보 수정
     */
    public int update(MemberDto member) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            update safe_member
            set name = ?, email = ?, password = ?
            where id = ?
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, member.getUserName());
            psmt.setString(2, member.getEmail());
            psmt.setString(3, SHA256.hashing(member.getPassword()));
            psmt.setString(4, member.getUserId());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    private MemberDto mapMember(ResultSet rs) throws SQLException {
        MemberDto member = new MemberDto();
        member.setUserId(rs.getString("id"));
        member.setUserName(rs.getString("name"));
        member.setEmail(rs.getString("email"));
        member.setPassword(rs.getString("password"));
        Timestamp regDate = rs.getTimestamp("reg_date");
        if (regDate != null) {
            member.setRegDate(regDate.toLocalDateTime());
        }
        return member;
    }
}
