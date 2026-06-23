/**
 * 20252374 최은교
 * 백오피스 시스템의 1:1 문의글 데이터를 전달하는 DTO 클래스임.
 * 관리자가 조회하고 답변을 달아야 하는 문의글의 번호, 회원아이디, 카테고리, 제목, 내용, 답변내용, 상태 등을 하나의 객체로 관리하는 기능을 제공한다.
 * 추가로, 백오피스 화면(JSP)과 데이터베이스 계층 사이에서 관리자 답변 데이터를 안전하게 캡슐화하여 전송하는 기능을 제공한다.
 * 상세로는 BOARD 테이블의 구조와 매칭되어 관리자가 입력한 답변을 정확하게 매핑하는 기능을 제공한다.
 *
 */

package kr.ac.dy.cs.board;

import java.time.LocalDateTime;

public class BoardDto {
    private int boardNo;
    private String userId;
    private String category;
    private String title;
    private String content;
    private String replyContent;
    private String status;
    private LocalDateTime regDate;

    public BoardDto() {}

    public BoardDto(int boardNo, String userId, String category, String title, String content, String replyContent, String status, LocalDateTime regDate) {
        this.boardNo = boardNo;
        this.userId = userId;
        this.category = category;
        this.title = title;
        this.content = content;
        this.replyContent = replyContent;
        this.status = status;
        this.regDate = regDate;
    }

    public int getBoardNo() { return boardNo; }
    public String getUserId() { return userId; }
    public String getCategory() { return category; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public String getReplyContent() { return replyContent; }
    public String getStatus() { return status; }
    public LocalDateTime getRegDate() { return regDate; }

    public static Builder builder() { return new Builder(); }

    public static class Builder {
        private int boardNo;
        private String userId;
        private String category;
        private String title;
        private String content;
        private String replyContent;
        private String status;
        private LocalDateTime regDate;

        public Builder boardNo(int boardNo) { this.boardNo = boardNo; return this; }
        public Builder userId(String userId) { this.userId = userId; return this; }
        public Builder category(String category) { this.category = category; return this; }
        public Builder title(String title) { this.title = title; return this; }
        public Builder content(String content) { this.content = content; return this; }
        public Builder replyContent(String replyContent) { this.replyContent = replyContent; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder regDate(LocalDateTime regDate) { this.regDate = regDate; return this; }

        public BoardDto build() {
            return new BoardDto(boardNo, userId, category, title, content, replyContent, status, regDate);
        }
    }
}