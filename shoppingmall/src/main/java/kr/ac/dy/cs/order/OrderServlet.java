/*
 * 20252361 김지연 - 주문 제출값 검증, 중복 수량 합산, 금액 재계산, 주문 완료 세션 처리
 */
package kr.ac.dy.cs.order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

@WebServlet("/order/submit")
public class OrderServlet extends HttpServlet {
    public static final String SESSION_ORDER_KEY = "shopmallLastOrder";

    private static final Pattern PHONE_PATTERN = Pattern.compile("^010-?\\d{4}-?\\d{4}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Set<String> PAYMENT_METHODS = Set.of("card", "bank", "simple");
    private static final int MAX_QUANTITY = 99;

    private final PriceCalculator priceCalculator = new PriceCalculator();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Map<String, String> formValues = readFormValues(request);
        String errorMessage = validateCustomer(formValues);
        List<OrderItem> orderItems = List.of();

        if (errorMessage == null) {
            try {
                orderItems = readOrderItems(request);
            } catch (IllegalArgumentException exception) {
                errorMessage = exception.getMessage();
            }
        }

        if (errorMessage != null) {
            request.setAttribute("checkoutError", errorMessage);
            request.setAttribute("checkoutFormValues", formValues);
            request.getRequestDispatcher("/order/checkout.jsp").forward(request, response);
            return;
        }

        int subtotal = priceCalculator.calculateSubtotal(orderItems);
        int shippingFee = priceCalculator.calculateShippingFee(subtotal);
        int total = subtotal + shippingFee;

        Order order = new Order(
                createOrderNumber(),
                LocalDateTime.now(),
                formValues.get("customerName"),
                normalizePhone(formValues.get("customerPhone")),
                formValues.get("email"),
                formValues.get("zipcode"),
                formValues.get("address"),
                formValues.get("detailAddress"),
                formValues.get("requestMemo"),
                formValues.get("paymentMethod"),
                orderItems,
                subtotal,
                shippingFee,
                total
        );

        request.getSession().setAttribute(SESSION_ORDER_KEY, order);
        response.sendRedirect(request.getContextPath() + "/order/complete.jsp");
    }

    private Map<String, String> readFormValues(HttpServletRequest request) {
        Map<String, String> values = new HashMap<>();
        values.put("customerName", trim(request.getParameter("customerName")));
        values.put("customerPhone", trim(request.getParameter("customerPhone")));
        values.put("email", trim(request.getParameter("email")));
        values.put("zipcode", trim(request.getParameter("zipcode")));
        values.put("address", trim(request.getParameter("address")));
        values.put("detailAddress", trim(request.getParameter("detailAddress")));
        values.put("requestMemo", trim(request.getParameter("requestMemo")));
        values.put("paymentMethod", trim(request.getParameter("paymentMethod")));
        values.put("privacyAgreement", trim(request.getParameter("privacyAgreement")));
        return values;
    }

    private String validateCustomer(Map<String, String> values) {
        if (values.get("customerName").isBlank()) {
            return "주문자명을 입력해 주세요.";
        }
        if (!PHONE_PATTERN.matcher(values.get("customerPhone")).matches()) {
            return "연락처는 010-1234-5678 또는 01012345678 형식으로 입력해 주세요.";
        }
        if (!EMAIL_PATTERN.matcher(values.get("email")).matches()) {
            return "올바른 이메일 주소를 입력해 주세요.";
        }
        if (values.get("zipcode").isBlank()) {
            return "우편번호를 입력해 주세요.";
        }
        if (values.get("address").isBlank()) {
            return "기본 주소를 입력해 주세요.";
        }
        if (values.get("detailAddress").isBlank()) {
            return "상세 주소를 입력해 주세요.";
        }
        if (!PAYMENT_METHODS.contains(values.get("paymentMethod"))) {
            return "결제 방법을 다시 선택해 주세요.";
        }
        if (!"Y".equals(values.get("privacyAgreement"))) {
            return "개인정보 수집 및 이용에 동의해 주세요.";
        }

        return null;
    }

    private List<OrderItem> readOrderItems(HttpServletRequest request) {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");

        if (productIds == null || quantities == null || productIds.length == 0) {
            throw new IllegalArgumentException("주문할 상품이 없습니다.");
        }
        if (productIds.length != quantities.length) {
            throw new IllegalArgumentException("주문 상품 정보가 올바르지 않습니다.");
        }

        Map<String, Integer> quantityByProductId = new LinkedHashMap<>();
        for (int i = 0; i < productIds.length; i++) {
            String productId = trim(productIds[i]);
            int quantity = parseQuantity(quantities[i]);
            int mergedQuantity = quantityByProductId.getOrDefault(productId, 0) + quantity;
            if (mergedQuantity > MAX_QUANTITY) {
                throw new IllegalArgumentException("상품 수량은 1개 이상 99개 이하로 입력해 주세요.");
            }

            quantityByProductId.put(productId, mergedQuantity);
        }

        List<OrderItem> items = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : quantityByProductId.entrySet()) {
            ProductCatalog.Product product = ProductCatalog.findById(entry.getKey())
                    .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 상품이 포함되어 있습니다."));

            items.add(new OrderItem(product.getId(), product.getName(), product.getBrand(), product.getSalePrice(), entry.getValue()));
        }

        return items;
    }

    private int parseQuantity(String value) {
        try {
            int quantity = Integer.parseInt(trim(value));
            if (quantity < 1 || quantity > MAX_QUANTITY) {
                throw new IllegalArgumentException("상품 수량은 1개 이상 99개 이하로 입력해 주세요.");
            }
            return quantity;
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("상품 수량이 올바르지 않습니다.");
        }
    }

    private String normalizePhone(String phone) {
        String digits = phone.replaceAll("[^0-9]", "");
        return digits.substring(0, 3) + "-" + digits.substring(3, 7) + "-" + digits.substring(7, 11);
    }

    private String createOrderNumber() {
        return "ORD-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
