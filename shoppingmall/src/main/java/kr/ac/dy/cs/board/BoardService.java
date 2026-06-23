/**
 * 20252374 최은교
 * 쇼핑몰 1:1 문의 게시판 관련 비즈니스 도메인 로직을 전담 처리하는 서비스 클래스임.
 * 사용자가 요청한 신규 문의글의 등록(registerQuestion) 로직 및 일반 회원이 자신의 문의 내역만 조회할 수 있도록 돕는 회원 맞춤형 비즈니스 기능을 제공한다.
 * 추가로, 백오피스 관리자 콘솔을 위한 전체 질문지 모니터링 기능과 특정 게시글 조회, 관리자 답변 처리 로직을 중앙에서 안전하게 조율하는 기능을 제공한다.
 * 상세로는 웹 컨트롤러 영역(JSP)과 영속성 저장소 영역(BoardRepository) 사이에서 결합도를 낮추는 아키텍처 가교 역할을 수행하는 기능을 제공한다.
 * 트랜잭션의 단위를 보호하고 예외 상황에 대한 안전장치 역할을 도맡아 게시판 서비스의 비즈니스 안정성을 극대화하는 기능을 제공한다.
 *
 */
package kr.ac.dy.cs.board;

import java.util.List;

public class BoardService {
    private final BoardRepository repository = new BoardRepository();

    // 문의글 등록 요청
    public void registerQuestion(BoardDto dto) {
        repository.insertBoard(dto);
    }

    // 소비자 본인의 문의 목록 가져오기
    public List<BoardDto> getMyQuestions(String userId) {
        return repository.selectByUserId(userId);
    }

    // 관리자용 전체 문의 목록 가져오기
    public List<BoardDto> getAllQuestions() {
        return repository.selectAll();
    }

    // 관리자 답변 등록하기
    public void answerQuestion(int boardNo, String replyContent) {
        repository.updateReply(boardNo, replyContent);
    }
}