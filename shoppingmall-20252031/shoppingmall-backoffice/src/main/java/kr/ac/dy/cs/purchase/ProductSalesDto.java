package kr.ac.dy.cs.purchase;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 상품별 매출/판매수량 한 행 */
@Getter
@AllArgsConstructor
public class ProductSalesDto {
    private String productId;
    private String productName;
    private long totalAmount;   // 상품별 매출
    private long quantity;      // 상품별 판매 수량
    private long count;         // 상품별 구매 건수
}
