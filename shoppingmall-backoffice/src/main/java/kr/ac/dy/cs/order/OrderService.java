package kr.ac.dy.cs.order;
// 주문 목록을 가져오고 상태 변경의 성공 여부를 확인하는 코드
import java.util.List;

public class OrderService {

    private final OrderRepository repository =
            new OrderRepository();

    public List<OrderDto> getOrders(String memberId){
        return repository.selectByMember(memberId);
    }

    public boolean changeStatus(
            Long orderId,
            String status){

        return repository.updateStatus(
                orderId,
                status) > 0;
    }
}