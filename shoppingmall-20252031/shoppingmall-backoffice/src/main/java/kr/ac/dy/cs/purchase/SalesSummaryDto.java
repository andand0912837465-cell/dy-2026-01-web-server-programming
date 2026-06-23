package kr.ac.dy.cs.purchase;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 매출 요약 지표 */
@Getter
@AllArgsConstructor
public class SalesSummaryDto {
    private long purchaseCount;   // 구매 건수
    private long totalQuantity;   // 총 판매 수량
    private long totalAmount;     // 총 매출
    private long avgAmount;       // 평균 구매 금액 (건당)
}
