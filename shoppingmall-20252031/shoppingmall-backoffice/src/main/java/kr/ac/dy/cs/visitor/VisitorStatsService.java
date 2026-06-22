package kr.ac.dy.cs.visitor;

import java.util.List;

/**
 * 방문자 분석 비즈니스 로직
 */
public class VisitorStatsService {

    private final VisitorStatsRepository repository = new VisitorStatsRepository();

    public VisitorSummaryDto getSummary() {
        return repository.selectSummary();
    }

    public List<DailyVisitDto> getDailyVisits() {
        return repository.selectDailyVisits();
    }

    public List<ProductVisitDto> getProductVisits() {
        return repository.selectProductVisits();
    }
}
