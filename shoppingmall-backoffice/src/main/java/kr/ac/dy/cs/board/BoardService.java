/**
 * 20252374 최은교
 * 백오피스 시스템의 1:1 문의 관리 비즈니스 로직을 처리하는 서비스 클래스임.
 * 관리자가 백오피스 웹 화면에서 요청한 전체 문의글 목록 조회 요청 및 특정 문의글 상세 조회 비즈니스 로직을 조율하는 기능을 제공한다.
 * 추가로, 관리자가 특정 고객 문의에 입력한 답변 내용을 검증하고 이를 데이터베이스에 최종 반영하도록 처리하는 기능을 제공한다.
 * 상세로는 백오피스 컨트롤러(JSP)와 데이터 액세스 계층(BoardRepository) 사이에서 가교 역할을 수행하며 관리자 기능에 특화된 비즈니스 규칙을 적용하는 기능을 제공한다.
 * 예외 상황이나 부적절한 데이터 유입을 방지하여 백오피스 관리 시스템의 신뢰성과 데이터의 트랜잭션 안정성을 높이는 기능을 제공한다.
 *
 */

package kr.ac.dy.cs.board;

import java.util.List;

public class BoardService {
    private final BoardRepository repository = new BoardRepository();

    // 관리자용 전체 문의 목록 가져오기
    public List<BoardDto> getAllQuestions() {
        return repository.selectAll();
    }

    // 관리자 답변 등록하기
    public void answerQuestion(int boardNo, String replyContent) {
        repository.updateReply(boardNo, replyContent);
    }

    // 특정 문의글의 상세 내용 가져오기
    public BoardDto getQuestionDetail(int boardNo) {
        return repository.selectByBoardNo(boardNo);
    }
}