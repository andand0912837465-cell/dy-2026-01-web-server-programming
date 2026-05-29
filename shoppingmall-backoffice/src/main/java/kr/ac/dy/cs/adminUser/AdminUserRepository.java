package kr.ac.dy.cs.adminUser;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

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
        PreparedStatement psmt = null;
        try {
            psmt = connection.prepareStatement(sql);
            psmt.setString(1, adminId);
            ResultSet rs = psmt.executeQuery();

            if (rs.next()) {
                adminUser = AdminUserDto.builder()
                        .adminId(rs.getString("admin_id"))
                        .adminName(rs.getString("admin_name"))
                        .password(rs.getString("password"))
                        .usingYn(rs.getString("using_yn"))
                        .regDt(rs.getTimestamp("reg_dt").toLocalDateTime())
                        .build();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return adminUser;
    }

}
