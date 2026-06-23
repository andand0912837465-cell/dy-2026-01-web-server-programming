package kr.ac.dy.cs.order;
//주문 페이지의 Dto
/**
 * 20252377 양효재
 * 부분 구현된 주문 상세 항목이 남아 있어서 개선 진행하였다.
 * 관리자 주문 목록과 상세 화면에서 같이 쓸 수 있게
 * 기본 주문 정보와 배송 결제 관련 필드를 추가해 두었다.
 */
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDto {

    private Long orderId;

    private String memberId;

    private String orderNumber;

    private String productId;

    private String productName;

    private int price;

    private int quantity;

    private String status;

    private LocalDateTime orderDate;

    private String receiverName;

    private String receiverPhone;

    private String zipCode;

    private String addressMain;

    private String addressDetail;

    private String paymentMethod;

    private String requestMessage;

    private String cancelReason;

    private String refundReason;

    private int refundAmount;
}
