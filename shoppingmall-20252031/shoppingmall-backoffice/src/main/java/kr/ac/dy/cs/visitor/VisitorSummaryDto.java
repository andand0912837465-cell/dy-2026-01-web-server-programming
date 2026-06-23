package kr.ac.dy.cs.visitor;

import lombok.Getter;

/** 방문자 요약 지표 */
@Getter
public class VisitorSummaryDto {

    private final long totalVisits;        // 총 방문 수
    private final long uniqueVisitors;     // UV (Unique Visitor)
    private final long purchaseCount;      // 구매 건수
    private final double conversionRate;   // 방문 대비 구매 전환율 (%)

    public VisitorSummaryDto(long totalVisits, long uniqueVisitors, long purchaseCount) {
        this.totalVisits = totalVisits;
        this.uniqueVisitors = uniqueVisitors;
        this.purchaseCount = purchaseCount;
        this.conversionRate = totalVisits > 0
                ? (purchaseCount * 100.0) / totalVisits
                : 0.0;
    }
}
