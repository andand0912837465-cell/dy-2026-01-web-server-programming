/**
 * 20252374 최은교
 * 쇼핑몰 및 백오피스 시스템 전체에서 1:1 문의글 데이터를 계층 간 전달하는 DTO 클래스임.
 * 문의글 고유 번호, 작성자 계정, 문의 카테고리, 제목, 질문 본문, 관리자 답변 내용, 처리 상태, 등록 일시를 독립된 필드로 캡슐화하여 관리하는 기능을 제공한다.
 * 추가로, 데이터의 조회와 수정을 안전하게 보장하기 위해 각 필드에 대한 Getter 및 Setter 메서드를 제공한다.
 * 상세로는 Lombok 라이브러리의 어노테이션(@Builder, @NoArgsConstructor 등)을 활용하여 객체의 생성 가독성을 높이고 코드 생산성을 향상시키는 기능을 제공한다.
 * 데이터베이스의 BOARD 테이블 레코드 구조와 1:1로 정확하게 대응되어 데이터 전송 시 무결성을 안정적으로 유지하는 기능을 제공한다.
 *
 */

package kr.ac.dy.cs.board;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardDto {
    private int boardNo;          // 게시글 고유 번호
    private String userId;        // 작성자 고유 ID
    private String category;      // 문의 유형 (배송/환불/기타)
    private String title;         // 문의 제목
    private String content;       // 문의 상세 내용
    private String replyContent;  // 관리자 답변 내용
    private String status;        // 처리 상태 (답변대기/답변완료)
    private LocalDateTime regDate;// 문의 접수 일시
}