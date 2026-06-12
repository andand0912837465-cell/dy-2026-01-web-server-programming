package kr.ac.dy.cs.order;
//주문 페이지의 Dto
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

    private String productName;

    private int price;

    private int quantity;

    private String status;

    private LocalDateTime orderDate;
}