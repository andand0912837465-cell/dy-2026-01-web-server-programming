package kr.ac.dy.cs.util;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class H2DbConnector implements Connector, FileConnector {

    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";

    public void hello() {
        System.out.println("Hello!!");
    }

    @Override
    public Connection getConnection() {
        try {
            Class.forName("org.h2.Driver");
            return DriverManager.getConnection(resolveDbUrl(), DB_USER, DB_PASSWORD);
        } catch (Exception e) {
            throw new RuntimeException("H2 데이터베이스 연결에 실패했습니다.", e);
        }
    }

    private String resolveDbUrl() {
        String configuredPath = System.getProperty("shopmall.db.path");
        if (configuredPath == null || configuredPath.isBlank()) {
            configuredPath = System.getenv("SHOPMALL_DB_PATH");
        }

        if (configuredPath != null && !configuredPath.isBlank()) {
            return toH2Url(Paths.get(configuredPath));
        }

        Path workingDirectory = Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        Path[] candidates = {
                workingDirectory.resolve("db/shopingmall"),
                workingDirectory.resolve("../db/shopingmall")
        };

        for (Path candidate : candidates) {
            Path parent = candidate.getParent();
            if (parent != null && Files.exists(parent)) {
                return toH2Url(candidate);
            }
        }

        return toH2Url(candidates[0]);
    }

    private String toH2Url(Path dbPath) {
        return "jdbc:h2:file:" + dbPath.toAbsolutePath().normalize() + ";AUTO_SERVER=TRUE";
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