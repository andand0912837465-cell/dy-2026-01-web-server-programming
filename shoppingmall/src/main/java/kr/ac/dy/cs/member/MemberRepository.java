/**
 * 99999999 박규태
 * 회원테이블에 데이터를 저장하는 기능을 구현한 클래스
 */
package kr.ac.dy.cs.member;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;
import kr.ac.dy.cs.util.SHA256;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * member테이블 데이터 처리
 */
public class MemberRepository {

    /**
     * 회원정보를 리턴(by id, password)
     * 입력받은 userId와 password값에 일치하는 member 테이블의 값을 리턴
     */
    public MemberDto select(String userId, String password) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        /**
         * 20251246 김나우
         * 데이터 베이스 확장에 따라 sql문을 수정하였음.
         */
        String sql = """
            select id, name, email, password, otp_key
            from safe_member
            where id = ? and password = ? and status = 'Y'
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, userId);
            psmt.setString(2, SHA256.hashing(password));

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    member = mapMember(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return member;
    }

    /**
     * member테이블 insert
     */
    public int insert(MemberDto member) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = "insert into safe_member (id, name, email, password, otp_key, reg_date) values (?, ?, ?, ?, ?, now())";

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, member.getUserId());
            psmt.setString(2, member.getUserName());
            psmt.setString(3, member.getEmail());
            psmt.setString(4, SHA256.hashing(member.getPassword()));
            psmt.setString(5, member.getOtp_key());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    /**
     * 20251246 김나우
     * 데이터 저장소 계층(Repository) 확장 (MemberRepository)
     * java에 세션 아이디로 DB를 단건 조회하는 selectById(String userId) 메서드 구현 및 SQL 매핑.
     * 기존 클래스 내부에 확장 구현
     */
    public MemberDto selectById(String userId) {
        MemberDto member = null;
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        // 수정을 위해 필수적인 기본 정보만 명확히 select
        String sql = """
            select id, name, email, password
            from safe_member
            where id = ? and status = 'Y'
        """;

        try (PreparedStatement psmt = connection.prepareStatement(sql)) {
            psmt.setString(1, userId);

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    // 공통 매핑 대신 직접 안전하게 인스턴스를 생성해 바인딩 처리
                    member = new MemberDto();
                    member.setUserId(rs.getString("id"));
                    member.setUserName(rs.getString("name"));
                    member.setEmail(rs.getString("email"));
                    member.setPassword(rs.getString("password"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }

        return member;
    }
    /**
     * 학번: 20251246 / 성명: 김나우
     * 회원 정보 수정 기능을 위한 저장소(Repository) 계층 확장 명세 클래스임.
     * * [결함 방어 및 주요 기능 구조]
     * 1. H2 DB 파일 잠김 방어: 로그인 검증과 정보 수정을 단일 커넥션(Connection) 트랜잭션 내에서 일괄 처리하여 파일 락 충돌을 예방함.
     * 2. 1단계 본인 인증: 입력받은 평문 비밀번호를 SHA-256 방식으로 해싱하여 safe_member 테이블의 암호화 데이터와 우선 대조함.
     * 3. 2단계 안전 UPDATE: 인증 성공 시 동일 커넥션을 유지하며 set name, email 쿼리를 실행해 최신 데이터를 반영함.
     * 4. 행 손상 방어: 문자열 결함 및 인코딩 깨짐으로 인한 DB 레코드 유실을 차단하기 위해 순수 문자열 매핑과 트림(trim) 처리를 보장함.
     * * @param member 변경할 사용자의 식별자(id)와 신규 이름(name), 이메일(email)이 담긴 DTO 객체
     * @param rawPassword 사용자가 본인 인증을 위해 입력한 평문 비밀번호 (1234)
     * @return 검증 및 수정 최종 반영 성공 시 true, 실패 시 false 반환
     */
    // H2 DB 트랜잭션 롤백 결함을 방어하기 위해 명시적 커밋(Commit)을 추가한 로직
    public boolean verifyAndUpdate(MemberDto member, String rawPassword) {
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();
        int affected = 0;

        try {
            // 수동 트랜잭션 모드로 전환하여 데이터 정합성 보장
            connection.setAutoCommit(false);

            // 1단계: 본인 인증 비밀번호 대조
            String verifySql = "select id from safe_member where id = ? and password = ?";
            boolean isPasswordCorrect = false;

            try (PreparedStatement psmt = connection.prepareStatement(verifySql)) {
                psmt.setString(1, member.getUserId());
                psmt.setString(2, SHA256.hashing(rawPassword));
                try (ResultSet rs = psmt.executeQuery()) {
                    if (rs.next()) {
                        isPasswordCorrect = true;
                    }
                }
            }

            // 비밀번호가 틀리면 롤백 후 탈출
            if (!isPasswordCorrect) {
                connection.rollback();
                return false;
            }

            // 2단계: 정보 수정 UPDATE 실행
            String updateSql = "update safe_member set name = ?, email = ? where id = ?";
            try (PreparedStatement psmt = connection.prepareStatement(updateSql)) {
                psmt.setString(1, member.getUserName().trim());
                psmt.setString(2, member.getEmail().trim());
                psmt.setString(3, member.getUserId().trim());

                affected = psmt.executeUpdate();
            }

            // 3단계: 쿼리가 성공적으로 영향을 미쳤다면 명시적으로 완전히 커밋(디스크 저장)
            if (affected > 0) {
                connection.commit();
            } else {
                connection.rollback();
            }

        } catch (SQLException e) {
            try {
                if (connection != null) connection.rollback();
            } catch (SQLException ex) {
                // 롤백 예외 무시
            }
            throw new RuntimeException(e);
        } finally {
            // 안전하게 커넥션 반환
            connector.closeConnection(connection);
        }

        return affected > 0;
    }

    /**
     * 학번: 20251246 / 성명: 김나우
     * 회원 탈퇴 처리를 위한 저장소(Repository) 계층 확장 명세임.
     * * [결함 방어 및 기능 구조]
     * 1. 소프트 딜리트(Soft Delete): 물리적인 DELETE 대신 status 값을 'N'으로 변경하여 데이터 유실 및 참조 무결성 오류를 원천 차단함.
     * 2. 트랜잭션 커밋: 탈퇴 UPDATE 성공 시 즉시 commit을 수행하여 H2 데이터베이스의 롤백 및 세션 잠김 결함을 예방함.
     * @param userId 탈퇴를 진행할 사용자의 세션 로그인 아이디
     * @return 상태 변경 최종 성공 시 true, 실패 시 false 반환
     */
    public boolean withdrawMember(String userId) {
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();
        String sql = "update safe_member set status = 'N' where id = ?";
        int affected = 0;

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psmt = connection.prepareStatement(sql)) {
                psmt.setString(1, userId.trim());
                affected = psmt.executeUpdate();
            }
            if (affected > 0) {
                connection.commit();
            } else {
                connection.rollback();
            }
        } catch (SQLException e) {
            try { if (connection != null) connection.rollback(); } catch (SQLException ex) {}
            throw new RuntimeException(e);
        } finally {
            connector.closeConnection(connection);
        }
        return affected > 0;
    }

    private MemberDto mapMember(ResultSet rs) throws SQLException {
        MemberDto member = new MemberDto();
        member.setUserId(rs.getString("id"));
        member.setUserName(rs.getString("name"));
        member.setEmail(rs.getString("email"));
        member.setPassword(rs.getString("password"));
        member.setOtp_key(rs.getString("otp_key"));
        return member;
    }
}
