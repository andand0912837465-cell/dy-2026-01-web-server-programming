/**
 * 20252031 이준성
 * Visitor의 DAO 클래스
 * ID, VISITED_AT은 DEFAULT를 통해 각각 RANDOM_UUID(), LOCALTIMESTAMP로 저장됨.
 */
package kr.ac.dy.cs.visitor;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class VisitorRepository {

    /**
     * 방문 이력 insert
     * @return insert 된 행 수
     */
    public int insert(String productId, String memberId) {

        int affected = 0;

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = " insert into visitor (product_id, member_id) values (?, ?) ";

        try {
            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setString(1, productId);
            psmt.setString(2, memberId);
            affected = psmt.executeUpdate();
        } catch (Exception e) {
            // 존재하지 않는 회원/상품 등 FK 위반 시에도 상세 페이지는 정상 노출되어야 하므로 무시한다.
            e.printStackTrace();
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

}
