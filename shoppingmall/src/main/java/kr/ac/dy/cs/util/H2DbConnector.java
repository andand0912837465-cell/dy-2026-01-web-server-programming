package kr.ac.dy.cs.util;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class H2DbConnector implements Connector, FileConnector {

    public void hello() {
        System.out.println("Hello!!");
    }

    @Override
    public Connection getConnection() {

        Connection connection = null;

        try {
            Class.forName("org.h2.Driver");

            String url = "jdbc:h2:C:/Work/shoppingmall/db/shoppingmall";
            String dbUser = "sa";
            String dbPassword = "";

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