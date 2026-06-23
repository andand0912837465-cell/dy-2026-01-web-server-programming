package kr.ac.dy.cs.product;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * 20252377 양효재
 * 부분 구현된 상품 관리 기능이 남아 있어서 개선 진행하였다.
 * 기존 조회와 리뷰 삭제만 있던 구조에 상품 등록과 수정과 삭제를 추가해서,
 * 백오피스 상품 관리 화면에서 실제 CRUD가 되도록 정리했다.
 * 부분 구현된 재고 관리 항목이 남아 있어서 개선 진행하였다.
 * 상품 등록과 수정과 목록 조회에 재고 컬럼을 같이 연결해서,
 * 백오피스에서 재고 수량까지 직접 관리할 수 있게 보완했다.
 */
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
                       P.BASIC_RATE, P.OLD_REVIEW_COUNT, P.IMAGE_URL, P.STOCK,
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
                       P.BASIC_RATE, P.OLD_REVIEW_COUNT, P.IMAGE_URL, P.STOCK,
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

    public int insertProduct(ProductDto product) {
        String sql = """
                INSERT INTO PRODUCT_DETAIL
                (PRODUCT_ID, NAME, BRAND, CATEGORY, ORIGINAL_PRICE, SALE_PRICE,
                 DISCOUNT_RATE, BASIC_RATE, OLD_REVIEW_COUNT, IMAGE_URL, STOCK,
                 BADGE, DETAIL_TEXT, DELIVERY_TEXT)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            bindProduct(pstmt, product);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return 0;
    }

    public int updateProduct(ProductDto product) {
        String sql = """
                UPDATE PRODUCT_DETAIL
                SET NAME = ?, BRAND = ?, CATEGORY = ?, ORIGINAL_PRICE = ?, SALE_PRICE = ?,
                    DISCOUNT_RATE = ?, BASIC_RATE = ?, OLD_REVIEW_COUNT = ?, IMAGE_URL = ?,
                    STOCK = ?, BADGE = ?, DETAIL_TEXT = ?, DELIVERY_TEXT = ?
                WHERE PRODUCT_ID = ?
                """;

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            createTables(conn);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getBrand());
            pstmt.setString(3, product.getCategory());
            pstmt.setInt(4, product.getOriginalPrice());
            pstmt.setInt(5, product.getSalePrice());
            pstmt.setInt(6, product.getDiscountRate());
            pstmt.setDouble(7, product.getBasicRate());
            pstmt.setInt(8, product.getOldReviewCount());
            pstmt.setString(9, product.getImageUrl());
            pstmt.setInt(10, product.getStock());
            pstmt.setString(11, product.getBadge());
            pstmt.setString(12, product.getDetailText());
            pstmt.setString(13, product.getDeliveryText());
            pstmt.setString(14, product.getProductId());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return 0;
    }

    public int deleteProduct(String productId) {
        Connection conn = null;
        PreparedStatement reviewStmt = null;
        PreparedStatement productStmt = null;

        try {
            conn = connector.getConnection();
            createTables(conn);
            conn.setAutoCommit(false);

            reviewStmt = conn.prepareStatement("DELETE FROM PRODUCT_REVIEW WHERE PRODUCT_ID = ?");
            reviewStmt.setString(1, productId);
            reviewStmt.executeUpdate();

            productStmt = conn.prepareStatement("DELETE FROM PRODUCT_DETAIL WHERE PRODUCT_ID = ?");
            productStmt.setString(1, productId);
            int affected = productStmt.executeUpdate();

            conn.commit();
            return affected;
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ignore) {
            }
            e.printStackTrace();
        } finally {
            try { if (reviewStmt != null) reviewStmt.close(); } catch (Exception e) {}
            try { if (productStmt != null) productStmt.close(); } catch (Exception e) {}
            connector.closeConnection(conn);
        }
        return 0;
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
        product.setStock(rs.getInt("STOCK"));
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
                        STOCK INT DEFAULT 0,
                        BADGE VARCHAR(30),
                        DETAIL_TEXT VARCHAR(2000),
                        DELIVERY_TEXT VARCHAR(1000)
                    )
                    """);
            stmt.executeUpdate("ALTER TABLE PRODUCT_DETAIL ADD COLUMN IF NOT EXISTS STOCK INT DEFAULT 0");
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

    private void bindProduct(PreparedStatement pstmt, ProductDto product) throws Exception {
        pstmt.setString(1, product.getProductId());
        pstmt.setString(2, product.getName());
        pstmt.setString(3, product.getBrand());
        pstmt.setString(4, product.getCategory());
        pstmt.setInt(5, product.getOriginalPrice());
        pstmt.setInt(6, product.getSalePrice());
        pstmt.setInt(7, product.getDiscountRate());
        pstmt.setDouble(8, product.getBasicRate());
        pstmt.setInt(9, product.getOldReviewCount());
        pstmt.setString(10, product.getImageUrl());
        pstmt.setInt(11, product.getStock());
        pstmt.setString(12, product.getBadge());
        pstmt.setString(13, product.getDetailText());
        pstmt.setString(14, product.getDeliveryText());
    }

    private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) connector.closeConnection(conn); } catch (Exception e) {}
    }
}
