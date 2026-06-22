package kr.ac.dy.cs.visitor;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 일별 방문 한 행 */
@Getter
@AllArgsConstructor
public class DailyVisitDto {
    private String date;             // yyyy-MM-dd
    private long visits;             // 방문 수
    private long uniqueVisitors;     // 해당 일 UV
}
