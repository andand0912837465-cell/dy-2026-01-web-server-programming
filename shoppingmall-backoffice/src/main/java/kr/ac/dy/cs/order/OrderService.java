package kr.ac.dy.cs.order;
// 주문 목록을 가져오고 상태 변경의 성공 여부를 확인하는 코드
/**
 * 20252377 양효재
 * 부분 구현된 주문 관리 서비스가 남아 있어서 개선 진행하였다.
 * 주문 전체 조회와 상세 조회와 상태 흐름 검증을 서비스에 모아서,
 * 관리자 화면에서 주문 처리 로직을 한곳에서 쓰도록 정리했다.
 */
import java.util.List;
import java.util.Map;

public class OrderService {

    private final OrderRepository repository =
            new OrderRepository();

    private static final List<String> ORDER_STATUSES = List.of(
            "결제완료",
            "상품준비중",
            "배송준비중",
            "배송중",
            "배송완료",
            "취소요청",
            "주문취소",
            "환불요청",
            "환불완료"
    );

    private static final Map<String, List<String>> NEXT_STATUS_MAP = Map.of(
            "결제완료", List.of("배송준비중", "취소요청", "주문취소"),
            "상품준비중", List.of("배송중", "주문취소"),
            "배송준비중", List.of("배송중", "주문취소"),
            "배송중", List.of("배송완료", "환불요청"),
            "배송완료", List.of("환불요청"),
            "취소요청", List.of("주문취소"),
            "환불요청", List.of("환불완료")
    );

    public List<OrderDto> getAllOrders(){
        return repository.selectAll();
    }

    public List<OrderDto> getOrders(String memberId){
        return repository.selectByMember(memberId);
    }

    public OrderDto getOrder(Long orderId){
        return repository.selectByOrderId(orderId);
    }

    public List<String> getOrderStatuses(){
        return ORDER_STATUSES;
    }

    public List<String> getNextStatuses(String currentStatus){
        if(currentStatus == null || currentStatus.isBlank()){
            return List.of("결제완료");
        }

        return NEXT_STATUS_MAP.getOrDefault(currentStatus, List.of());
    }

    public boolean changeStatus(
            Long orderId,
            String status){

        if(orderId == null || orderId <= 0){
            return false;
        }

        if(!isValidStatus(status)){
            return false;
        }

        return repository.updateStatus(
                orderId,
                status) > 0;
    }

    public boolean isValidStatus(String status){
        return status != null && ORDER_STATUSES.contains(status);
    }
}
