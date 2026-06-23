package kr.ac.dy.cs.visitor;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 상품별 방문 한 행 */
@Getter
@AllArgsConstructor
public class ProductVisitDto {
    private String productId;
    private String productName;
    private long visits;             // 방문 수
    private long uniqueVisitors;     // 상품별 UV
}
