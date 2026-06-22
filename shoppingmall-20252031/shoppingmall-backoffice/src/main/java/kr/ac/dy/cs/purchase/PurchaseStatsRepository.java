package kr.ac.dy.cs.purchase;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PURCHASE 테이블 기반 매출 통계 조회
 */
public class PurchaseStatsRepository {

    /** 매출 요약 (구매 건수, 총 판매 수량, 총 매출, 평균 구매 금액) */
    public SalesSummaryDto selectSummary() {
        String sql = """
            SELECT COUNT(*)                         AS cnt,
                   COALESCE(SUM(quantity), 0)       AS qty,
                   COALESCE(SUM(total_amount), 0)   AS amt,
                   COALESCE(ROUND(AVG(total_amount)), 0) AS avg_amt
            FROM purchase
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            if (rs.next()) {
                return new SalesSummaryDto(
                        rs.getLong("cnt"),
                        rs.getLong("qty"),
                        rs.getLong("amt"),
                        rs.getLong("avg_amt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return new SalesSummaryDto(0, 0, 0, 0);
    }

    /** 일별 매출 */
    public List<DailySalesDto> selectDailySales() {
        List<DailySalesDto> list = new ArrayList<>();
        String sql = """
            SELECT FORMATDATETIME(purchased_at, 'yyyy-MM-dd') AS d,
                   SUM(total_amount) AS amt,
                   COUNT(*)          AS cnt
            FROM purchase
            GROUP BY d
            ORDER BY d
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                list.add(new DailySalesDto(rs.getString("d"), rs.getLong("amt"), rs.getLong("cnt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }

    /** 월별 매출 */
    public List<MonthlySalesDto> selectMonthlySales() {
        List<MonthlySalesDto> list = new ArrayList<>();
        String sql = """
            SELECT FORMATDATETIME(purchased_at, 'yyyy-MM') AS m,
                   SUM(total_amount) AS amt,
                   COUNT(*)          AS cnt
            FROM purchase
            GROUP BY m
            ORDER BY m
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                list.add(new MonthlySalesDto(rs.getString("m"), rs.getLong("amt"), rs.getLong("cnt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }

    /** 상품별 매출 + 판매 수량 (매출 내림차순) */
    public List<ProductSalesDto> selectProductSales() {
        List<ProductSalesDto> list = new ArrayList<>();
        String sql = """
            SELECT p.id              AS product_id,
                   p.name            AS product_name,
                   SUM(pu.total_amount) AS amt,
                   SUM(pu.quantity)     AS qty,
                   COUNT(*)             AS cnt
            FROM purchase pu
            JOIN product p ON p.id = pu.product_id
            GROUP BY p.id, p.name
            ORDER BY amt DESC
            """;

        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();
        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                list.add(new ProductSalesDto(
                        rs.getString("product_id"),
                        rs.getString("product_name"),
                        rs.getLong("amt"),
                        rs.getLong("qty"),
                        rs.getLong("cnt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }
}
