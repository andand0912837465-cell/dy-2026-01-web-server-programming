/**
    20252364 강한서

    review 테이블의 데이터를 처리하는 DAO 클래스이다.
    상품 상세 페이지에서 리뷰 목록을 조회하고, 로그인한 사용자가 작성한 리뷰를
    등록하거나 삭제하는 기능을 담당한다.


    상품 번호를 기준으로 해당 상품의 리뷰 목록을 조회한다.
    로그인한 사용자의 아이디로 리뷰를 등록한다.
    리뷰 번호와 작성자 아이디를 확인하여 본인이 작성한 리뷰만 삭제할 수 있도록 한다.
    조회된 ResultSet 데이터를 ReviewDto 객체로 변환하여 JSP에 전달한다.
 */
package kr.ac.dy.cs.review;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDao {
    private final H2DbConnector connector = new H2DbConnector();

    public List<ReviewDto> findByProductId(int productId) {
        List<ReviewDto> reviews = new ArrayList<>();

        String sql = "SELECT id, product_id, writer_id, rating, content, created_at " +
                     "FROM review WHERE product_id = ? ORDER BY id DESC";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public void insertReview(int productId, String writerId, int rating, String content) {
        String sql = "INSERT INTO review (product_id, writer_id, rating, content) VALUES (?, ?, ?, ?)";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);
            pstmt.setString(2, writerId);
            pstmt.setInt(3, rating);
            pstmt.setString(4, content);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ReviewDto findById(int reviewId) {
        String sql = "SELECT id, product_id, writer_id, rating, content, created_at " +
                     "FROM review WHERE id = ?";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);

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

    public boolean deleteReview(int reviewId, String loginId) {
        String sql = "DELETE FROM review WHERE id = ? AND writer_id = ?";

        try (Connection conn = connector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);
            pstmt.setString(2, loginId);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private ReviewDto mapRow(ResultSet rs) throws Exception {
        ReviewDto review = new ReviewDto();
        review.setId(rs.getInt("id"));
        review.setProductId(rs.getInt("product_id"));
        review.setWriterId(rs.getString("writer_id"));
        review.setRating(rs.getInt("rating"));
        review.setContent(rs.getString("content"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        return review;
    }
}
