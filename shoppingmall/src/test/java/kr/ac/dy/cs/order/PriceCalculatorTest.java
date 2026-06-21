/*
 * 20252361 김지연
 * 기능 설명: 배송비 경계값과 주문 금액 계산 단위 테스트
 */
package kr.ac.dy.cs.order;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class PriceCalculatorTest {
    private final PriceCalculator calculator = new PriceCalculator();

    @Test
    void 빈_목록은_상품금액과_배송비가_0원이다() {
        assertEquals(0, calculator.calculateSubtotal(List.of()));
        assertEquals(0, calculator.calculateShippingFee(0));
        assertEquals(0, calculator.calculateTotal(List.of()));
    }

    @Test
    void 상품_1개의_상품금액을_계산한다() {
        List<OrderItem> items = List.of(new OrderItem("best-0", "셔츠", "BASIC", 39000, 1));

        assertEquals(39000, calculator.calculateSubtotal(items));
    }

    @Test
    void 여러_상품의_상품금액을_계산한다() {
        List<OrderItem> items = List.of(
                new OrderItem("best-0", "셔츠", "BASIC", 39000, 2),
                new OrderItem("new-3", "버킷햇", "STREET", 35000, 1)
        );

        assertEquals(113000, calculator.calculateSubtotal(items));
    }

    @Test
    void 상품금액_49999원은_배송비_3000원이다() {
        assertEquals(3000, calculator.calculateShippingFee(49999));
    }

    @Test
    void 상품금액_50000원은_배송비_무료이다() {
        assertEquals(0, calculator.calculateShippingFee(50000));
    }

    @Test
    void 상품금액_50001원은_배송비_무료이다() {
        assertEquals(0, calculator.calculateShippingFee(50001));
    }

    @Test
    void 최종_금액은_상품금액과_배송비를_합산한다() {
        List<OrderItem> items = List.of(new OrderItem("new-3", "버킷햇", "STREET", 35000, 1));

        assertEquals(38000, calculator.calculateTotal(items));
    }

    @Test
    void 잘못된_수량은_예외가_발생한다() {
        assertThrows(IllegalArgumentException.class,
                () -> new OrderItem("best-0", "셔츠", "BASIC", 39000, 0));
    }
}
