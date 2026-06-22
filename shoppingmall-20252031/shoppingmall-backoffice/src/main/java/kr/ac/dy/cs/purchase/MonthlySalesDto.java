package kr.ac.dy.cs.purchase;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 월별 매출 한 행 */
@Getter
@AllArgsConstructor
public class MonthlySalesDto {
    private String month;       // yyyy-MM
    private long totalAmount;   // 해당 월 총 매출
    private long count;         // 해당 월 구매 건수
}
