/**
 * 20252031 이준성
 * 방문 이력 관련 비즈니스 로직용 클래스
 */

package kr.ac.dy.cs.visitor;

/**
 * 방문 이력 비즈니스 로직
 */
public class VisitorService {

    private final VisitorRepository visitorRepository = new VisitorRepository();

    /**
     * 상품 상세 페이지 방문 기록.
     * 로그인 회원(memberId)이 있을 때만 적재한다. (비로그인 방문은 기록하지 않음)
     */
    public void recordVisit(String productId, String memberId) {
        if (productId == null || productId.isBlank()) {
            return;
        }
        if (memberId == null || memberId.isBlank()) {
            return;
        }
        visitorRepository.insert(productId, memberId);
    }

}
