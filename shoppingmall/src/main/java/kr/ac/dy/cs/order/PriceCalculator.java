/*
 * 20252361 김지연 - 주문 상품 금액, 배송비, 최종 결제 금액 계산
 */
package kr.ac.dy.cs.order;

import java.util.List;

public final class PriceCalculator {
    public static final int FREE_SHIPPING_THRESHOLD = 50000;
    public static final int DEFAULT_SHIPPING_FEE = 3000;

    public int calculateSubtotal(List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            return 0;
        }

        return items.stream()
                .mapToInt(this::calculateLineTotal)
                .sum();
    }

    public int calculateLineTotal(OrderItem item) {
        validateItem(item);
        return item.getUnitPrice() * item.getQuantity();
    }

    public int calculateShippingFee(int subtotal) {
        if (subtotal <= 0) {
            return 0;
        }

        return subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : DEFAULT_SHIPPING_FEE;
    }

    public int calculateTotal(List<OrderItem> items) {
        int subtotal = calculateSubtotal(items);
        return subtotal + calculateShippingFee(subtotal);
    }

    private void validateItem(OrderItem item) {
        if (item == null) {
            throw new IllegalArgumentException("주문 상품 정보가 없습니다.");
        }
        if (item.getUnitPrice() < 0) {
            throw new IllegalArgumentException("상품 가격이 올바르지 않습니다.");
        }
        if (item.getQuantity() < 1) {
            throw new IllegalArgumentException("수량은 1개 이상이어야 합니다.");
        }
    }
}
