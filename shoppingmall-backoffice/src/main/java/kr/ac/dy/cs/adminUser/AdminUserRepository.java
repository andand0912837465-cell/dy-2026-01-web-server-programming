package kr.ac.dy.cs.adminUser;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class AdminUserRepository {

    /**
     * 20252377 양효재
     * 관리자 로그인 시 admin_user 테이블이 없어서 500 오류가 나는 문제가 있어서 수정하였다.
     * 로그인이나 등록 전에 테이블을 먼저 만들고,
     * jason2554 계정도 현재 DB에 없으면 같이 들어가도록 보완했다.
     */
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
        try {
            prepareAdminUserTable(connection);

            PreparedStatement psmt = connection.prepareStatement(sql);
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
            psmt.close();
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

        try {
            prepareAdminUserTable(connection);

            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setString(1, adminUser.getAdminId());
            psmt.setString(2, adminUser.getAdminName());
            psmt.setString(3, adminUser.getPassword());
            psmt.setString(4, adminUser.getUsingYn());
            affected = psmt.executeUpdate();
            psmt.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    private void prepareAdminUserTable(Connection connection) throws SQLException {
        Statement stmt = null;
        PreparedStatement psmt = null;

        try {
            stmt = connection.createStatement();
            stmt.executeUpdate("""
                    create table if not exists admin_user (
                        admin_id varchar(50) primary key,
                        admin_name varchar(100) not null,
                        password varchar(100) not null,
                        using_yn varchar(1) default 'Y',
                        reg_dt timestamp default current_timestamp
                    )
                    """);

            psmt = connection.prepareStatement("""
                    merge into admin_user
                    (admin_id, admin_name, password, using_yn, reg_dt)
                    key(admin_id)
                    values (?, ?, ?, ?, current_timestamp)
                    """);
            psmt.setString(1, "jason2554");
            psmt.setString(2, "jason2554");
            psmt.setString(3, "1234@@");
            psmt.setString(4, "Y");
            psmt.executeUpdate();
        } finally {
            if (psmt != null) {
                psmt.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        }
    }
}
