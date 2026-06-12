/**
 * 99999999 박규태
 * 회원테이블에 데이터를 저장하는 기능을 구현한 클래스
 *
 */
package kr.ac.dy.cs.member;


import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.FileConnector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;

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

        //드라이버 로드, 커넥션객체 생성
        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """ 
        
        select id, name, email, password 
        from member 
        where id = ? and password = ? 
        
        """;

        try {
            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setString(1, userId);
            psmt.setString(2, password);

            ResultSet rs =  psmt.executeQuery();

            if (rs.next()) {
                member = new MemberDto();
                member.setUserId(rs.getString("id"));
                member.setUserName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setPassword(rs.getString("password"));
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

        //DB에 insert
        //Driver로딩

        int affected = 0;
        try {
            Connector connector = new H2DbConnector();
            Connection connection = connector.getConnection();

            String sql = " insert into member (id, name, email, password, reg_date) values (?, ?, ?, ?, now()) ";
            //스테이트먼트 객체 생성
            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setString(1, member.getUserId());
            psmt.setString(2, member.getUserName());
            psmt.setString(3, member.getEmail());
            psmt.setString(4, member.getPassword());
            //실행
            affected = psmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return affected;
    }

}
