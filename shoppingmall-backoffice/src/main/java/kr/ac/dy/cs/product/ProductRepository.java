package kr.ac.dy.cs.product;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {

    private final H2DbConnector connector = new H2DbConnector();

    public List<ProductDto> selectAll() {
        List<ProductDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = """
                SELECT P.PRODUCT_ID, P.NAME, P.BRAND, P.CATEGORY,
                       P.ORIGINAL_PRICE, P.SALE_PRICE, P.DISCOUNT_RATE,
                       P.BASIC_RATE, P.OLD_REVIEW_COUNT, P.IMAGE_URL,
                       P.BADGE, P.DETAIL_TEXT, P.DELIVERY_TEXT,
                       COALESCE(R.REVIEW_COUNT, 0) AS NEW_REVIEW_COUNT,
                       R.AVG_SCORE
                FROM PRODUCT_DETAIL P
                LEFT JOIN (
                    SELECT PRODUCT_ID, COUNT(*) AS REVIEW_COUNT, AVG(SCORE) AS AVG_SCORE
                    FROM PRODUCT_REVIEW
                    GROUP BY PRODUCT_ID
                ) R ON P.PRODUCT_ID = R.PRODUCT_ID
                ORDER BY P.PRODUCT_ID
                """;

        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return list;
    }

    public ProductDto selectById(String productId) {
        ProductDto product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = """
                SELECT P.PRODUCT_ID, P.NAME, P.BRAND, P.CATEGORY,
                       P.ORIGINAL_PRICE, P.SALE_PRICE, P.DISCOUNT_RATE,
                       P.BASIC_RATE, P.OLD_REVIEW_COUNT, P.IMAGE_URL,
                       P.BADGE, P.DETAIL_TEXT, P.DELIVERY_TEXT,
                       COALESCE(R.REVIEW_COUNT, 0) AS NEW_REVIEW_COUNT,
                       R.AVG_SCORE
                FROM PRODUCT_DETAIL P
                LEFT JOIN (
                    SELECT PRODUCT_ID, COUNT(*) AS REVIEW_COUNT, AVG(SCORE) AS AVG_SCORE
                    FROM PRODUCT_REVIEW
                    GROUP BY PRODUCT_ID
                ) R ON P.PRODUCT_ID = R.PRODUCT_ID
                WHERE P.PRODUCT_ID = ?
                """;

        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                product = mapProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return product;
    }

    public List<ProductReviewDto> selectReviews(String productId) {
        List<ProductReviewDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = """
                SELECT REVIEW_NO, PRODUCT_ID, WRITER, SCORE, CONTENT, REG_DATE
                FROM PRODUCT_REVIEW
                WHERE PRODUCT_ID = ?
                ORDER BY REVIEW_NO DESC
                """;

        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ProductReviewDto review = new ProductReviewDto();
                review.setReviewNo(rs.getLong("REVIEW_NO"));
                review.setProductId(rs.getString("PRODUCT_ID"));
                review.setWriter(rs.getString("WRITER"));
                review.setScore(rs.getInt("SCORE"));
                review.setContent(rs.getString("CONTENT"));

                Timestamp regDate = rs.getTimestamp("REG_DATE");
                if (regDate != null) {
                    review.setRegDate(regDate.toLocalDateTime());
                }

                list.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }

        return list;
    }

    public int deleteReview(long reviewNo, String productId) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "DELETE FROM PRODUCT_REVIEW WHERE REVIEW_NO = ? AND PRODUCT_ID = ?";

        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewNo);
            pstmt.setString(2, productId);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }

        return result;
    }

    private ProductDto mapProduct(ResultSet rs) throws Exception {
        ProductDto product = new ProductDto();
        int newReviewCount = rs.getInt("NEW_REVIEW_COUNT");
        double averageScore = rs.getDouble("BASIC_RATE");

        if (newReviewCount > 0) {
            averageScore = rs.getDouble("AVG_SCORE");
        }

        product.setProductId(rs.getString("PRODUCT_ID"));
        product.setName(rs.getString("NAME"));
        product.setBrand(rs.getString("BRAND"));
        product.setCategory(rs.getString("CATEGORY"));
        product.setOriginalPrice(rs.getInt("ORIGINAL_PRICE"));
        product.setSalePrice(rs.getInt("SALE_PRICE"));
        product.setDiscountRate(rs.getInt("DISCOUNT_RATE"));
        product.setBasicRate(rs.getDouble("BASIC_RATE"));
        product.setOldReviewCount(rs.getInt("OLD_REVIEW_COUNT"));
        product.setImageUrl(rs.getString("IMAGE_URL"));
        product.setBadge(rs.getString("BADGE"));
        product.setDetailText(rs.getString("DETAIL_TEXT"));
        product.setDeliveryText(rs.getString("DELIVERY_TEXT"));
        product.setReviewCount(rs.getInt("OLD_REVIEW_COUNT") + newReviewCount);
        product.setNewReviewCount(newReviewCount);
        product.setAverageScore(averageScore);

        return product;
    }

    private void createTables(Connection conn) throws Exception {
        Statement stmt = null;

        try {
            stmt = conn.createStatement();
            stmt.executeUpdate("""
                    CREATE TABLE IF NOT EXISTS PRODUCT_DETAIL (
                        PRODUCT_ID VARCHAR(30) PRIMARY KEY,
                        NAME VARCHAR(100) NOT NULL,
                        BRAND VARCHAR(100) NOT NULL,
                        CATEGORY VARCHAR(50),
                        ORIGINAL_PRICE INT,
                        SALE_PRICE INT,
                        DISCOUNT_RATE INT,
                        BASIC_RATE DOUBLE,
                        OLD_REVIEW_COUNT INT,
                        IMAGE_URL VARCHAR(300),
                        BADGE VARCHAR(30),
                        DETAIL_TEXT VARCHAR(2000),
                        DELIVERY_TEXT VARCHAR(1000)
                    )
                    """);
            stmt.executeUpdate("""
                    CREATE TABLE IF NOT EXISTS PRODUCT_REVIEW (
                        REVIEW_NO BIGINT AUTO_INCREMENT PRIMARY KEY,
                        PRODUCT_ID VARCHAR(30) NOT NULL,
                        WRITER VARCHAR(50) NOT NULL,
                        SCORE INT NOT NULL,
                        CONTENT VARCHAR(1000) NOT NULL,
                        REG_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                    """);
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        }
    }

    private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) connector.closeConnection(conn); } catch (Exception e) {}
    }
}
