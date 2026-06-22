/**
 * 20252031 이준성
 * Product의 DAO 클래스
 * DATA 컬럼은 JSON 문자열이므로 Jackson을 통해 파싱한다.
 */
package kr.ac.dy.cs.product;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PRODUCT 테이블 데이터 처리
 */
public class ProductRepository {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    /**
     * 전체 상품 목록 조회
     */
    public List<ProductDto> selectAll() {

        List<ProductDto> products = new ArrayList<>();

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """

        select id, name, price, sale_price, data
        from product

        """;

        try {
            PreparedStatement psmt = connection.prepareStatement(sql);
            ResultSet rs = psmt.executeQuery();

            while (rs.next()) {
                products.add(mapRow(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return products;
    }

    /**
     * 상품 1건 조회 (by id)
     */
    public ProductDto selectById(String id) {

        ProductDto product = null;

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """

        select id, name, price, sale_price, data
        from product
        where id = ?

        """;

        try {
            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setString(1, id);
            ResultSet rs = psmt.executeQuery();

            if (rs.next()) {
                product = mapRow(rs);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return product;
    }

    /**
     * ResultSet 한 행 -> ProductDto 변환
     * DATA(JSON) 컬럼에서 brand, image 값을 추출한다.
     */
    private ProductDto mapRow(ResultSet rs) throws SQLException {
        String data = rs.getString("data");

        String brand = "";
        String image = "";
        if (data != null && !data.isBlank()) {
            try {
                JsonNode node = OBJECT_MAPPER.readTree(data);
                brand = node.path("brand").asText("");
                image = node.path("image").asText("");
            } catch (Exception e) {
                // JSON 형식이 잘못된 경우 brand/image 는 기본값(빈 문자열)으로 둔다.
                e.printStackTrace();
            }
        }

        return ProductDto.builder()
                .id(rs.getString("id"))
                .name(rs.getString("name"))
                .price(rs.getInt("price"))
                .salePrice(rs.getInt("sale_price"))
                .brand(brand)
                .image(image)
                .build();
    }

}
