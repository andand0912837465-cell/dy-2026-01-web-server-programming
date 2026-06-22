package kr.ac.dy.cs.notice;

import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoticeRepository {

    public List<NoticeDto> selectAll() {
        List<NoticeDto> list = new ArrayList<>();
        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();

        String sql = "SELECT id, title, content, writer, file_name, file_origin_name, reg_date, mod_date FROM notice ORDER BY id DESC";

        try (PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {
            while (rs.next()) {
                NoticeDto dto = new NoticeDto();
                dto.setId(rs.getLong("id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setWriter(rs.getString("writer"));
                dto.setFileName(rs.getString("file_name"));
                dto.setFileOriginName(rs.getString("file_origin_name"));
                Timestamp regDate = rs.getTimestamp("reg_date");
                if (regDate != null) dto.setRegDate(regDate.toLocalDateTime());
                Timestamp modDate = rs.getTimestamp("mod_date");
                if (modDate != null) dto.setModDate(modDate.toLocalDateTime());
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return list;
    }

    public NoticeDto selectById(Long id) {
        NoticeDto dto = null;
        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();

        String sql = "SELECT id, title, content, writer, file_name, file_origin_name, reg_date, mod_date FROM notice WHERE id = ?";

        try (PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setLong(1, id);
            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    dto = new NoticeDto();
                    dto.setId(rs.getLong("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setContent(rs.getString("content"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setFileName(rs.getString("file_name"));
                    dto.setFileOriginName(rs.getString("file_origin_name"));
                    Timestamp regDate = rs.getTimestamp("reg_date");
                    if (regDate != null) dto.setRegDate(regDate.toLocalDateTime());
                    Timestamp modDate = rs.getTimestamp("mod_date");
                    if (modDate != null) dto.setModDate(modDate.toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return dto;
    }

    public int insert(NoticeDto dto) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();

        String sql = "INSERT INTO notice (title, content, writer, file_name, file_origin_name, reg_date, mod_date) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";

        try (PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setString(1, dto.getTitle());
            psmt.setString(2, dto.getContent());
            psmt.setString(3, dto.getWriter());
            psmt.setString(4, dto.getFileName());
            psmt.setString(5, dto.getFileOriginName());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return affected;
    }

    public int update(NoticeDto dto) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();

        String sql = "UPDATE notice SET title = ?, content = ?, file_name = ?, file_origin_name = ?, mod_date = NOW() WHERE id = ?";

        try (PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setString(1, dto.getTitle());
            psmt.setString(2, dto.getContent());
            psmt.setString(3, dto.getFileName());
            psmt.setString(4, dto.getFileOriginName());
            psmt.setLong(5, dto.getId());
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return affected;
    }

    public int delete(Long id) {
        int affected = 0;
        Connector connector = new H2DbConnector();
        Connection conn = connector.getConnection();

        String sql = "DELETE FROM notice WHERE id = ?";

        try (PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setLong(1, id);
            affected = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            connector.closeConnection(conn);
        }
        return affected;
    }
}
