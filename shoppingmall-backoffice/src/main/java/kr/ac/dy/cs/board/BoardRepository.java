/**
 * 20252374 최은교
 * 백오피스 시스템의 1:1 문의 관리 데이터베이스 접근을 처리하는 레포지토리 클래스임.
 * 데이터베이스에 직접 접근하여 관리자가 확인해야 할 전체 문의글 목록을 최신순으로 긁어오고, 특정 문의글의 상세 내용을 조회하는 기능을 제공한다.
 * 추가로, 백오피스 관리자가 화면에서 입력한 답변 텍스트를 기반으로 데이터베이스의 reply_content를 수정하고, 상태를 '답변완료'로 업데이트하는 기능을 제공한다.
 * 상세로는 H2 데이터베이스와의 커넥션을 수립하고, PreparedStatement를 이용하여 관리자 전용 SQL 쿼리(SELECT, UPDATE)를 안정적으로 실행하는 기능을 제공한다.
 * 데이터베이스 작업 완료 후 Connection, PreparedStatement, ResultSet 등의 자원을 안전하게 해제하여 시스템의 안정성을 유지하는 기능을 제공한다.
 *
 */

package kr.ac.dy.cs.board;

import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BoardRepository {
    private final H2DbConnector connector = new H2DbConnector();

    // 관리자용 전체 문의 글 목록 조회 (최신순)
    public List<BoardDto> selectAll() {
        String sql = "SELECT * FROM BOARD ORDER BY board_no DESC";
        List<BoardDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDto dto = BoardDto.builder()
                        .boardNo(rs.getInt("board_no"))
                        .userId(rs.getString("user_id"))
                        .category(rs.getString("category"))
                        .title(rs.getString("title"))
                        .content(rs.getString("content"))
                        .replyContent(rs.getString("reply_content"))
                        .status(rs.getString("status"))
                        .regDate(rs.getTimestamp("reg_date").toLocalDateTime())
                        .build();
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return list;
    }

    // 특정 글 번호로 단 한 개의 글 상세 조회 (답변 페이지 전용)
    public BoardDto selectByBoardNo(int boardNo) {
        String sql = "SELECT * FROM BOARD WHERE board_no = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardNo);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return BoardDto.builder()
                        .boardNo(rs.getInt("board_no"))
                        .userId(rs.getString("user_id"))
                        .category(rs.getString("category"))
                        .title(rs.getString("title"))
                        .content(rs.getString("content"))
                        .replyContent(rs.getString("reply_content"))
                        .status(rs.getString("status"))
                        .regDate(rs.getTimestamp("reg_date").toLocalDateTime())
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    // 관리자가 답변을 등록하고 상태 변경 (UPDATE)
    public void updateReply(int boardNo, String replyContent) {
        String sql = "UPDATE BOARD SET reply_content = ?, status = '답변완료' WHERE board_no = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, replyContent);
            pstmt.setInt(2, boardNo);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) connector.closeConnection(conn); } catch (Exception e) {}
    }
}