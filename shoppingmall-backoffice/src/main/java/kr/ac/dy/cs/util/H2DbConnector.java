package kr.ac.dy.cs.util;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class H2DbConnector implements Connector, FileConnector {

    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final String DB_NAME = "shopingmall";
    private static final String DB_DIR = "db";

    public void hello() {
        System.out.println("Hello!!");
    }

    @Override
    public Connection getConnection() {
        try {
            Class.forName("org.h2.Driver");
            String dbUrl = resolveDbUrl();
            try {
                return DriverManager.getConnection(dbUrl, DB_USER, DB_PASSWORD);
            } catch (SQLException firstException) {
                if (dbUrl.contains(";AUTO_SERVER=TRUE")) {
                    return DriverManager.getConnection(dbUrl.replace(";AUTO_SERVER=TRUE", ""), DB_USER, DB_PASSWORD);
                }
                throw firstException;
            }
        } catch (Exception e) {
            throw new RuntimeException("H2 데이터베이스 연결에 실패했습니다.", e);
        }
    }

    /**
     * 20252377 양효재
     * 백오피스 실행 위치에 따라 빈 H2 파일이 새로 생기는 문제가 있어서 수정하였다.
     * user.dir만 보지 않고 실제 db 파일이 있는 경로를 먼저 찾아서,
     * 톰캣이나 IDE 실행 위치가 달라도 같은 shopingmall DB를 보도록 보완했다.
     */
    private String resolveDbUrl() {
        String configuredPath = System.getProperty("shopmall.db.path");
        if (configuredPath == null || configuredPath.isBlank()) {
            configuredPath = System.getenv("SHOPMALL_DB_PATH");
        }

        if (configuredPath != null && !configuredPath.isBlank()) {
            return toH2Url(Paths.get(configuredPath));
        }

        Path existingDbPath = findExistingDbPath();
        if (existingDbPath != null) {
            return toH2Url(existingDbPath);
        }

        Path fallbackDbPath = findFallbackDbPath();
        return toH2Url(fallbackDbPath);
    }

    private Path findExistingDbPath() {
        for (Path seed : collectSeedPaths()) {
            for (Path candidate : expandCandidatePaths(seed)) {
                if (hasExistingDbFile(candidate)) {
                    return candidate;
                }
            }
        }

        return null;
    }

    private Path findFallbackDbPath() {
        List<Path> seeds = collectSeedPaths();

        for (Path seed : seeds) {
            for (Path candidate : expandCandidatePaths(seed)) {
                Path parent = candidate.getParent();
                if (parent != null && Files.exists(parent)) {
                    return candidate;
                }
            }
        }

        Path workingDirectory = Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        return workingDirectory.resolve(DB_DIR).resolve(DB_NAME);
    }

    private List<Path> collectSeedPaths() {
        Set<Path> seeds = new LinkedHashSet<>();

        seeds.add(Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize());

        try {
            URL location = H2DbConnector.class.getProtectionDomain().getCodeSource().getLocation();
            if (location != null) {
                URI uri = location.toURI();
                Path classPath = Paths.get(uri).toAbsolutePath().normalize();
                seeds.add(Files.isDirectory(classPath) ? classPath : classPath.getParent());
            }
        } catch (Exception ignore) {
        }

        return new ArrayList<>(seeds);
    }

    private List<Path> expandCandidatePaths(Path seed) {
        List<Path> candidates = new ArrayList<>();
        Path current = seed;

        for (int depth = 0; current != null && depth < 8; depth++) {
            candidates.add(current.resolve(DB_DIR).resolve(DB_NAME));
            current = current.getParent();
        }

        return candidates;
    }

    private boolean hasExistingDbFile(Path dbPath) {
        return Files.exists(Paths.get(dbPath.toString() + ".mv.db"))
                || Files.exists(Paths.get(dbPath.toString() + ".h2.db"));
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
