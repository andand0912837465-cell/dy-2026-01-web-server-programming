package kr.ac.dy.cs.java_20251242;


/**
 * ============================================================================
 * 학번 : 20251242
 * 이름 : 곽미란
 * 파일 : CartService.java
 *
 * 기능 : 장바구니 비즈니스 로직 처리 클래스(Service).
 *        - FR-01 장바구니 담기
 *        - FR-02 장바구니 목록 조회
 *        - FR-03 상품 수량 변경
 *        - FR-04 상품 개별 삭제
 *        - FR-05 장바구니 전체 비우기
 *        - FR-06 장바구니 총 수량 계산
 *        - 상품 합계 금액 계산
 *        - 배송비 계산
 *        - 최종 결제 예정 금액 계산
 *
 * 설명 :
 *        CartRepository를 이용하여 DB와 연동하며,
 *        ProductCatalog의 상품 정보를 활용하여
 *        장바구니 데이터를 관리한다.
 *
 * ============================================================================
 */
import kr.ac.dy.cs.cart.CartItemDto;
import kr.ac.dy.cs.cart.CartRepository;
import kr.ac.dy.cs.order.PriceCalculator;
import kr.ac.dy.cs.order.ProductCatalog;

import java.util.List;
import java.util.Optional;

/**
 * ============================================================================
 * 학번 : 20251242
 * 이름 : 곽미란
 * 파일 : CartService.java
 *
 * 기능 :
 * - DB 기반 장바구니 비즈니스 로직 처리
 * - 상품 담기, 조회, 수량 변경, 삭제, 전체 비우기 기능 제공
 * - 상품 금액, 배송비, 최종 결제 예정 금액 계산
 * - 장바구니 배지에 표시할 총 수량 계산
 *
 * 설명 :
 * Controller(JSP)와 Repository(DB) 사이에서
 * 실제 장바구니 기능을 처리하는 서비스 클래스이다.
 * ============================================================================
 */
public class CartService {

    // DB 접근을 위한 Repository 객체
    private final CartRepository cartRepository;

    public CartService() {
        this.cartRepository = new CartRepository();
    }

    /**
     * 회원의 장바구니 ID를 조회한다.
     * 장바구니가 존재하지 않으면 새로 생성한다.
     */
    public long getOrCreateCartId(String memberId) {
        Long cartId = cartRepository.selectCartId(memberId);

        if (cartId == null) {
            cartId = cartRepository.insertCart(memberId);
        }

        return cartId;
    }

    /**
     * FR-01 장바구니 담기
     *
     * 사용자가 선택한 상품을 DB 장바구니에 저장한다.
     *
     * 처리 내용
     * - ProductCatalog에서 상품 존재 여부 확인
     * - 동일 상품 존재 시 수량 누적
     * - 존재하지 않으면 신규 상품 추가
     * - 최소 수량은 1개로 보정
     */
    public void addItem(String memberId, String productId, int quantity) {

        Optional<ProductCatalog.Product> found =
                ProductCatalog.findById(productId);

        if (found.isEmpty()) {
            return; // 존재하지 않는 상품
        }

        if (quantity < 1) {
            quantity = 1;
        }

        ProductCatalog.Product product = found.get();

        long cartId = getOrCreateCartId(memberId);

        CartItemDto exist =
                cartRepository.selectItem(cartId, productId);

        if (exist != null) {

            // 이미 담긴 상품이면 수량만 증가
            cartRepository.updateQuantity(
                    exist.getCartItemId(),
                    exist.getQuantity() + quantity
            );

        } else {

            // 신규 상품이면 INSERT
            CartItemDto item = CartItemDto.builder()
                    .cartId(cartId)
                    .productId(product.getId())
                    .productName(product.getName())
                    .brand(product.getBrand())
                    .price(product.getSalePrice())
                    .imageUrl(product.getImageUrl())
                    .quantity(quantity)
                    .build();

            cartRepository.insertItem(item);
        }
    }

    /**
     * FR-02 장바구니 목록 조회
     *
     * 로그인한 회원의 장바구니 상품 목록을 반환한다.
     * 장바구니가 없으면 빈 목록을 반환한다.
     */
    public List<CartItemDto> getItems(String memberId) {

        Long cartId = cartRepository.selectCartId(memberId);

        if (cartId == null) {
            return List.of();
        }

        return cartRepository.selectItems(cartId);
    }

    /**
     * FR-03 수량 변경
     *
     * 사용자가 선택한 상품의 수량을 변경한다.
     * 최소 수량은 1개로 제한한다.
     */
    public void changeQuantity(long cartItemId, int quantity) {

        if (quantity < 1) {
            quantity = 1;
        }

        cartRepository.updateQuantity(cartItemId, quantity);
    }

    /**
     * FR-04 상품 삭제
     *
     * 장바구니에 담긴 특정 상품 1개를 삭제한다.
     */
    public void removeItem(long cartItemId) {
        cartRepository.deleteItem(cartItemId);
    }

    /**
     * FR-05 전체 삭제
     *
     * 회원의 장바구니에 담긴 상품을 모두 제거한다.
     */
    public void clear(String memberId) {

        Long cartId = cartRepository.selectCartId(memberId);

        if (cartId != null) {
            cartRepository.deleteAllItems(cartId);
        }
    }

    /**
     * FR-06 장바구니 배지 수량 계산
     *
     * 헤더의 장바구니 아이콘에 표시할
     * 전체 상품 수량을 계산한다.
     */
    public int getTotalQuantity(List<CartItemDto> items) {

        int total = 0;

        for (CartItemDto item : items) {
            total += item.getQuantity();
        }

        return total;
    }

    /**
     * 상품 총 금액 계산
     *
     * 장바구니에 담긴 상품의
     * (가격 × 수량) 합계를 계산한다.
     */
    public int getSubtotal(List<CartItemDto> items) {

        int subtotal = 0;

        for (CartItemDto item : items) {
            subtotal += item.getLineTotal();
        }

        return subtotal;
    }

    /**
     * 배송비 계산
     *
     * 5만원 이상 : 무료배송
     * 5만원 미만 : 3,000원
     *
     * 팀의 PriceCalculator 정책을 재사용한다.
     */
    public int getShippingFee(int subtotal) {

        if (subtotal <= 0) {
            return 0;
        }

        return subtotal >= PriceCalculator.FREE_SHIPPING_THRESHOLD
                ? 0
                : PriceCalculator.DEFAULT_SHIPPING_FEE;
    }

    /**
     * 최종 결제 예정 금액 계산
     *
     * 상품 금액 + 배송비
     */
    public int getTotal(List<CartItemDto> items) {

        int subtotal = getSubtotal(items);

        return subtotal + getShippingFee(subtotal);
    }
}