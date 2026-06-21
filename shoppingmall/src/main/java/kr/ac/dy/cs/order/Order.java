/*
 * 20252361 김지연 - 주문 완료 화면에 전달할 주문 정보 관리
 */
package kr.ac.dy.cs.order;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

public final class Order implements Serializable {
    private final String orderNumber;
    private final LocalDateTime orderedAt;
    private final String customerName;
    private final String customerPhone;
    private final String email;
    private final String zipcode;
    private final String address;
    private final String detailAddress;
    private final String requestMemo;
    private final String paymentMethod;
    private final List<OrderItem> items;
    private final int subtotal;
    private final int shippingFee;
    private final int total;

    public Order(String orderNumber, LocalDateTime orderedAt, String customerName, String customerPhone, String email,
                 String zipcode, String address, String detailAddress, String requestMemo, String paymentMethod,
                 List<OrderItem> items, int subtotal, int shippingFee, int total) {
        this.orderNumber = orderNumber;
        this.orderedAt = orderedAt;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.email = email;
        this.zipcode = zipcode;
        this.address = address;
        this.detailAddress = detailAddress;
        this.requestMemo = requestMemo;
        this.paymentMethod = paymentMethod;
        this.items = List.copyOf(items);
        this.subtotal = subtotal;
        this.shippingFee = shippingFee;
        this.total = total;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public LocalDateTime getOrderedAt() {
        return orderedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public String getEmail() {
        return email;
    }

    public String getZipcode() {
        return zipcode;
    }

    public String getAddress() {
        return address;
    }

    public String getDetailAddress() {
        return detailAddress;
    }

    public String getRequestMemo() {
        return requestMemo;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public int getSubtotal() {
        return subtotal;
    }

    public int getShippingFee() {
        return shippingFee;
    }

    public int getTotal() {
        return total;
    }

    public String getFullAddress() {
        if (detailAddress == null || detailAddress.isBlank()) {
            return address;
        }

        return address + " " + detailAddress;
    }
}
