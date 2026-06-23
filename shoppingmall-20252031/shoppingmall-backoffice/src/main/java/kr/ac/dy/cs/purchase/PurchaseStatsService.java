package kr.ac.dy.cs.purchase;

import java.util.List;

/**
 * 매출 통계 비즈니스 로직
 */
public class PurchaseStatsService {

    private final PurchaseStatsRepository repository = new PurchaseStatsRepository();

    public SalesSummaryDto getSummary() {
        return repository.selectSummary();
    }

    public List<DailySalesDto> getDailySales() {
        return repository.selectDailySales();
    }

    public List<MonthlySalesDto> getMonthlySales() {
        return repository.selectMonthlySales();
    }

    public List<ProductSalesDto> getProductSales() {
        return repository.selectProductSales();
    }
}
