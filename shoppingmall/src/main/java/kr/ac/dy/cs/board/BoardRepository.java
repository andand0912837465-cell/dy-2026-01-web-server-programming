/**
 * 20252374 최은교
 * 쇼핑몰 데이터베이스의 BOARD 테이블에 직접 접근하여 CRUD 연산을 수행하는 데이터 액세스(Repository) 클래스임.
 * 사용자가 입력한 문의 정보를 DB에 새롭게 저장(INSERT)하고, 로그인한 회원 본인의 아이디로 작성된 글만 필터링하여 목록을 가져오는 기능을 제공한다.
 * 추가로, 백오피스 시스템과의 데이터베이스 공유 및 확장성을 고려하여 전체 목록 조회(selectAll) 및 관리자 답변 등록(updateReply) 메서드를 공통으로 포함하여 관리하는 기능을 제공한다.
 * 상세로는 H2 데이터베이스 커넥션을 안전하게 수립하고 PreparedStatement 기반의 SQL문을 실행하여 SQL 인젝션 공격을 예방하는 보안 기능을 제공한다.
 * 쿼리 수행 후 ResultSet 결과를 Java 객체 구조에 맞게 매핑하여 반환하고, 가용 자원을 역순으로 안전하게 닫아주는 자원 관리 기능을 제공한다.
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

    // [기능 1] 소비자가 작성한 문의 글을 DB에 저장 (INSERT)
    public void insertBoard(BoardDto dto) {
        String sql = "INSERT INTO BOARD (user_id, category, title, content) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUserId());
            pstmt.setString(2, dto.getCategory());
            pstmt.setString(3, dto.getTitle());
            pstmt.setString(4, dto.getContent());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    // [기능 2] 전체 문의 글 목록 조회 (백오피스 최신순 모니터링용)
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

    // [기능 3] 특정 소비자가 작성한 글만 필터링 조회 (쇼핑몰 로그인 회원용)
    public List<BoardDto> selectByUserId(String userId) {
        String sql = "SELECT * FROM BOARD WHERE user_id = ? ORDER BY board_no DESC";
        List<BoardDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = connector.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
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

    // [기능 4] 백오피스에서 관리자가 답변을 등록하고 상태 변경 (UPDATE)
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

    // 🔥 [새로 추가된 기능 5] 특정 글 번호로 단 한 개의 글 상세 조회 (상세보기용)
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

    // 자원 해제 공통 메서드
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) connector.closeConnection(conn); } catch (Exception e) {}
    }
}