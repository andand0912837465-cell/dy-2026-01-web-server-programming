// 20251258 김상범
// schema.sql 파일을 읽어 데이터베이스 테이블과 초기 데이터를 생성하는 초기화 클래스
package kr.ac.dy.cs.quizmaster.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.stream.Collectors;

public class DatabaseInitializer {

    public void initialize() {
        try (Connection conn = new QuizH2DbConnector().getConnection();
             Statement stmt = conn.createStatement()) {

            InputStream in = getClass().getClassLoader().getResourceAsStream("schema.sql");
            if (in == null) {
                System.out.println("[QuizMaster] schema.sql not found, skipping initialization.");
                return;
            }
            String sql = new BufferedReader(new InputStreamReader(in))
                    .lines().collect(Collectors.joining("\n"));

            for (String statement : sql.split(";")) {
                String trimmed = statement.trim();
                if (!trimmed.isEmpty()) {
                    stmt.execute(trimmed);
                }
            }
            System.out.println("[QuizMaster] Database initialized successfully.");
        } catch (Exception e) {
            System.out.println("[QuizMaster] Database initialization skipped (tables may already exist): " + e.getMessage());
        }
    }
}
