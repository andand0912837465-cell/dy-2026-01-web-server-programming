package kr.ac.dy.cs.visitor;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * VISITOR 테이블 기반 방문자 분석 조회
 */
public class VisitorStatsRepository {

    /** 방문자 요약 (총 방문 수, UV, 구매 건수 → 전환율 계산) */
    public VisitorSummaryDto selectSummary() {
        long totalVisits = 0;
        long uniqueVisitors = 0;
        long purchaseCount = 0;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try {
            String visitSql = "SELECT COUNT(*) AS visits, COUNT(DISTINCT member_id) AS uv FROM visitor";
            try (PreparedStatement psmt = conn.prepareStatement(visitSql);
                 ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    totalVisits = rs.getLong("visits");
                    uniqueVisitors = rs.getLong("uv");
                }
            }

            try (PreparedStatement psmt = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM purchase");
                 ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    purchaseCount = rs.getLong("cnt");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }

        return new VisitorSummaryDto(totalVisits, uniqueVisitors, purchaseCount);
    }

    /** 일별 방문 수 (+ 일별 UV) */
    public List<DailyVisitDto> selectDailyVisits() {
        List<DailyVisitDto> list = new ArrayList<>();
        String sql = """
            SELECT FORMATDATETIME(visited_at, 'yyyy-MM-dd') AS d,
                   COUNT(*)                  AS visits,
                   COUNT(DISTINCT member_id) AS uv
            FROM visitor
            GROUP BY d
            ORDER BY d
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                list.add(new DailyVisitDto(rs.getString("d"), rs.getLong("visits"), rs.getLong("uv")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }

    /** 상품별 방문 수 (+ 상품별 UV), 방문 수 내림차순 */
    public List<ProductVisitDto> selectProductVisits() {
        List<ProductVisitDto> list = new ArrayList<>();
        String sql = """
            SELECT p.id   AS product_id,
                   p.name AS product_name,
                   COUNT(*)                   AS visits,
                   COUNT(DISTINCT v.member_id) AS uv
            FROM visitor v
            JOIN product p ON p.id = v.product_id
            GROUP BY p.id, p.name
            ORDER BY visits DESC
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                list.add(new ProductVisitDto(
                        rs.getString("product_id"),
                        rs.getString("product_name"),
                        rs.getLong("visits"),
                        rs.getLong("uv")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }
}
