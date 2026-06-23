/*
 * ============================================================================
 *  학번 : 20231553
 *  이름 : 김성민
 *  파일 : CartRepository.java
 *  기능 : 장바구니(CART) / 장바구니 상품(CART_ITEM) 테이블에 대한 데이터 접근(SQL) 담당 클래스.
 *         - 모든 SQL 은 PreparedStatement 로 작성하여 SQL Injection 을 방지한다. (NFR-01)
 *         - DB 커넥션/자원은 finally 의 closeResources() 로 반드시 반납한다. (NFR-02)
 *         - 기존 BoardRepository 와 동일한 H2 JDBC 규약(H2DbConnector 필드 사용)을 따른다.
 *         - 최초 1회 ensureTables() 로 CART / CART_ITEM 테이블이 없으면 자동 생성하여,
 *           별도 DDL 실행 없이도 기능이 동작하도록 한다. (CREATE TABLE IF NOT EXISTS)
 *  ※ 김성민(20231553)이 추가한 신규 소스이며 기존 팀원 코드는 수정하지 않았다.
 * ============================================================================
 */
package kr.ac.dy.cs.cart;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CartRepository {

    private final H2DbConnector connector = new H2DbConnector();

    public CartRepository() {
        ensureTables();
    }

    /**
     * CART / CART_ITEM 테이블이 없으면 생성한다(있으면 무시).
     */
    private void ensureTables() {
        String createCart = """
                CREATE TABLE IF NOT EXISTS CART (
                    CART_ID   BIGINT AUTO_INCREMENT PRIMARY KEY,
                    MEMBER_ID VARCHAR(50) NOT NULL,
                    REG_DATE  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    MOD_DATE  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
                """;
        String createCartItem = """
                CREATE TABLE IF NOT EXISTS CART_ITEM (
                    CART_ITEM_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
                    CART_ID      BIGINT       NOT NULL,
                    PRODUCT_ID   VARCHAR(50)  NOT NULL,
                    PRODUCT_NAME VARCHAR(200) NOT NULL,
                    BRAND        VARCHAR(100),
                    PRICE        INT          NOT NULL,
                    IMAGE_URL    VARCHAR(500),
                    QUANTITY     INT          NOT NULL DEFAULT 1,
                    REG_DATE     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
                """;
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        try {
            conn = connector.getConnection();
            pstmt1 = conn.prepareStatement(createCart);
            pstmt1.executeUpdate();
            pstmt2 = conn.prepareStatement(createCartItem);
            pstmt2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt2 != null) pstmt2.close(); } catch (Exception e) {}
            closeResources(conn, pstmt1, null);
        }
    }

    /**
     * 회원(memberId)이 소유한 장바구니의 CART_ID 를 조회한다.
     * @return 장바구니가 있으면 CART_ID, 없으면 null
     */
    public Long selectCartId(String memberId) {
        String sql = "SELECT cart_id FROM CART WHERE member_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("cart_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 회원(memberId)의 장바구니를 새로 생성하고, 자동 생성된 CART_ID 를 반환한다.
     */
    public Long insertCart(String memberId) {
        String sql = "INSERT INTO CART (member_id, reg_date, mod_date) VALUES (?, now(), now())";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, memberId);
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 특정 장바구니(cartId)에 동일 상품(productId)이 이미 담겨 있는지 조회한다.
     * @return 담겨 있으면 해당 CartItemDto, 없으면 null
     */
    public CartItemDto selectItem(long cartId, String productId) {
        String sql = """
                SELECT cart_item_id, cart_id, product_id, product_name,
                       brand, price, image_url, quantity
                FROM CART_ITEM
                WHERE cart_id = ? AND product_id = ?
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, cartId);
            pstmt.setString(2, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 장바구니에 상품 1건을 추가(INSERT)한다.
     */
    public int insertItem(CartItemDto item) {
        String sql = """
                INSERT INTO CART_ITEM
                    (cart_id, product_id, product_name, brand, price, image_url, quantity, reg_date)
                VALUES (?, ?, ?, ?, ?, ?, ?, now())
                """;
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, item.getCartId());
            pstmt.setString(2, item.getProductId());
            pstmt.setString(3, item.getProductName());
            pstmt.setString(4, item.getBrand());
            pstmt.setInt(5, item.getPrice());
            pstmt.setString(6, item.getImageUrl());
            pstmt.setInt(7, item.getQuantity());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return 0;
    }

    /**
     * 장바구니 상품(cartItemId)의 수량을 변경한다.
     */
    public int updateQuantity(long cartItemId, int quantity) {
        String sql = "UPDATE CART_ITEM SET quantity = ? WHERE cart_item_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setLong(2, cartItemId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return 0;
    }

    /**
     * 특정 장바구니(cartId)에 담긴 상품 목록을 조회한다.
     */
    public List<CartItemDto> selectItems(long cartId) {
        String sql = """
                SELECT cart_item_id, cart_id, product_id, product_name,
                       brand, price, image_url, quantity
                FROM CART_ITEM
                WHERE cart_id = ?
                ORDER BY cart_item_id
                """;
        List<CartItemDto> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, cartId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                items.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return items;
    }

    /**
     * 장바구니 상품(cartItemId)을 개별 삭제한다.
     */
    public int deleteItem(long cartItemId) {
        String sql = "DELETE FROM CART_ITEM WHERE cart_item_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, cartItemId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return 0;
    }

    /**
     * 특정 장바구니(cartId)의 모든 상품을 삭제(전체 비우기)한다.
     */
    public int deleteAllItems(long cartId) {
        String sql = "DELETE FROM CART_ITEM WHERE cart_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, cartId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return 0;
    }

    /**
     * ResultSet 한 행을 CartItemDto 로 변환하는 내부 공통 메서드.
     */
    private CartItemDto mapRow(ResultSet rs) throws Exception {
        return CartItemDto.builder()
                .cartItemId(rs.getLong("cart_item_id"))
                .cartId(rs.getLong("cart_id"))
                .productId(rs.getString("product_id"))
                .productName(rs.getString("product_name"))
                .brand(rs.getString("brand"))
                .price(rs.getInt("price"))
                .imageUrl(rs.getString("image_url"))
                .quantity(rs.getInt("quantity"))
                .build();
    }

    /**
     * 자원 해제 공통 메서드 (기존 BoardRepository 규약과 동일).
     */
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) connector.closeConnection(conn); } catch (Exception e) {}
    }
}
