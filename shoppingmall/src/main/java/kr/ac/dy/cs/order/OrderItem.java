/*
 * 20252361 김지연 - 서버에서 검증한 주문 상품 금액과 수량 관리
 */
package kr.ac.dy.cs.order;

import java.io.Serializable;

public final class OrderItem implements Serializable {
    private final String productId;
    private final String productName;
    private final String brand;
    private final int unitPrice;
    private final int quantity;

    public OrderItem(String productId, String productName, String brand, int unitPrice, int quantity) {
        if (productId == null || productId.trim().isEmpty()) {
            throw new IllegalArgumentException("상품 ID가 없습니다.");
        }
        if (unitPrice < 0) {
            throw new IllegalArgumentException("상품 가격이 올바르지 않습니다.");
        }
        if (quantity < 1) {
            throw new IllegalArgumentException("수량은 1개 이상이어야 합니다.");
        }

        this.productId = productId;
        this.productName = productName == null ? "" : productName;
        this.brand = brand == null ? "" : brand;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
    }

    public String getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public String getBrand() {
        return brand;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getLineTotal() {
        return unitPrice * quantity;
    }
}
