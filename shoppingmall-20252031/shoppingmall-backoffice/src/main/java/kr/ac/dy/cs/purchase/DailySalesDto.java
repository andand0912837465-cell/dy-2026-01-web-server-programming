package kr.ac.dy.cs.purchase;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 일별 매출 한 행 */
@Getter
@AllArgsConstructor
public class DailySalesDto {
    private String date;        // yyyy-MM-dd
    private long totalAmount;   // 해당 일 총 매출
    private long count;         // 해당 일 구매 건수
}
