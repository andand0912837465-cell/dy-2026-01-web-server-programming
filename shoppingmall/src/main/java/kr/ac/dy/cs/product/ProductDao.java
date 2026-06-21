/**
    20252364 강한서

    product 테이블의 데이터를 조회하는 DAO 클래스이다.
    H2 데이터베이스에 연결하여 상품 목록 전체 조회와 상품 번호를 이용한
    상품 상세 조회 기능을 쳐리한다.
    findAll() 메소드를 통해 등록된 모든 상품 목록을 조회한다.
    findById(int id) 메소드를 통해 특정 상품의 상세 정보를 조회한다.
    조회된 ResultSet 데이터를 ProductDto 객체로 변환하여 JSP에 전달한다.
 */
package kr.ac.dy.cs.product;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    private final H2DbConnector connector = new H2DbConnector();

    public List<ProductDto> findAll() {
        List<ProductDto> products = new ArrayList<>();

        String sql = "SELECT id, name, brand, price, description, image_url " +
                     "FROM product ORDER BY id DESC";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                products.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    public ProductDto findById(int id) {
        String sql = "SELECT id, name, brand, price, description, image_url " +
                     "FROM product WHERE id = ?";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private ProductDto mapRow(ResultSet rs) throws Exception {
        ProductDto product = new ProductDto();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setBrand(rs.getString("brand"));
        product.setPrice(rs.getInt("price"));
        product.setDescription(rs.getString("description"));
        product.setImageUrl(rs.getString("image_url"));
        return product;
    }
}
