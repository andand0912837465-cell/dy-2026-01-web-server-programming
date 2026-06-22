package kr.ac.dy.cs.util;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class H2DbConnector implements Connector, FileConnector {

    public void hello() {
        System.out.println("Hello!!");
    }

    @Override
    public Connection getConnection() {

        Connection connection = null;

        try {
            //드라이버 로드
            Class.forName("org.h2.Driver");

            String url = "jdbc:h2:file:C:/Users/junseong06/Desktop/project/dy-2026-01-web-server-programming/shoppingmall-20252031/db/shopingmall";
            String dbUser = "sa";
            String dbPassword = "";

            //커넥션 객체 생성
            connection = DriverManager.getConnection(url, dbUser, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();

        }

        return connection;
    }

    @Override
    public void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public File loadFile() {
        return null;
    }
}
