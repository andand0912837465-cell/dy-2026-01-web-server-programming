package kr.ac.dy.cs.adminUser;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminUserRepository {

    /**
     * 회원정보 리턴
     */
    public AdminUserDto getAdminUser(String adminId) {

        AdminUserDto adminUser = null;

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """ 
            select admin_id, admin_name, password, using_yn, reg_dt
            from admin_user
            where admin_id = ?        
        """;
        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, adminId);

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    java.sql.Timestamp regDt = rs.getTimestamp("reg_dt");
                    adminUser = AdminUserDto.builder()
                            .adminId(rs.getString("admin_id"))
                            .adminName(rs.getString("admin_name"))
                            .password(rs.getString("password"))
                            .usingYn(rs.getString("using_yn"))
                            .regDt(regDt != null ? regDt.toLocalDateTime() : null)
                            .build();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return adminUser;
    }

    /**
     * 관리자 계정 등록
     */
    public int insert(AdminUserDto adminUser) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
            insert into admin_user (admin_id, admin_name, password, using_yn, reg_dt)
            values (?, ?, ?, ?, now())
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, adminUser.getAdminId());
            psmt.setString(2, adminUser.getAdminName());
            psmt.setString(3, adminUser.getPassword());
            psmt.setString(4, adminUser.getUsingYn());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

}
