// 20251258 김상범
// H2 데이터베이스 연결을 관리하고 DB 파일 경로를 자동 탐색하는 유틸리티 클래스
package kr.ac.dy.cs.quizmaster.util;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;

public class QuizH2DbConnector {

    public Connection getConnection() {
        try {
            Class.forName("org.h2.Driver");
            return DriverManager.getConnection(resolveDbUrl(), "sa", "");
        } catch (Exception e) {
            throw new RuntimeException("H2 DB 연결 실패", e);
        }
    }

    private String resolveDbUrl() {
        String configuredPath = System.getProperty("quizmaster.db.path");
        if (configuredPath != null && !configuredPath.isBlank()) {
            return toH2Url(Paths.get(configuredPath));
        }

        configuredPath = System.getenv("QUIZMASTER_DB_PATH");
        if (configuredPath != null && !configuredPath.isBlank()) {
            return toH2Url(Paths.get(configuredPath));
        }

        Path workingDir = Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        Path projectDir = findProjectRoot(workingDir);
        if (projectDir != null) {
            Path dataDir = projectDir.resolve("data");
            if (Files.exists(dataDir)) {
                return toH2Url(dataDir.resolve("quizmaster"));
            }
            Path dbDir = projectDir.resolve("db");
            if (Files.exists(dbDir)) {
                return toH2Url(dbDir.resolve("quizmaster"));
            }
        }

        Path[] candidates = {
                workingDir.resolve("../data/quizmaster"),
                workingDir.resolve("data/quizmaster"),
                workingDir.resolve("../db/quizmaster"),
                workingDir.resolve("db/quizmaster")
        };
        for (Path candidate : candidates) {
            Path parent = candidate.getParent();
            if (parent != null && Files.exists(parent)) {
                return toH2Url(candidate);
            }
        }
        return toH2Url(candidates[0]);
    }

    private Path findProjectRoot(Path start) {
        Path current = start.toAbsolutePath().normalize();
        while (current != null) {
            if (Files.exists(current.resolve("quiz-master/pom.xml"))
                    || Files.exists(current.resolve("pom.xml"))) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

    private String toH2Url(Path dbPath) {
        return "jdbc:h2:file:" + dbPath.toAbsolutePath().normalize() + ";AUTO_SERVER=TRUE";
    }
}
