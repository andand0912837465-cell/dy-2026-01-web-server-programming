/*
 * ============================================================================
 *  학번 : 20231553
 *  이름 : 김성민
 *  파일 : CartService.java
 *  기능 : 장바구니 비즈니스 로직 담당 클래스.
 *         - 화면(JSP)과 데이터(CartRepository) 사이에서 장바구니 처리 규칙을 수행한다.
 *         - 담을 때 가격/상품정보는 클라이언트 입력이 아닌 서버의 ProductCatalog 값을
 *           신뢰하여 사용한다(가격 위·변조 방지, NFR-04).
 *         [제공 기능]
 *           getOrCreateCartId : 회원 장바구니 ID 확보(없으면 생성)
 *           addItem           : FR-01 담기(동일 상품이면 수량 누적, 신규면 INSERT)
 *           getItems          : FR-02 장바구니 목록 조회
 *           changeQuantity    : FR-03 수량 변경(최소 1 보장)
 *           removeItem        : FR-04 개별 삭제
 *           clear             : FR-05 전체 비우기
 *           getTotalQuantity  : FR-06 배지용 총 수량
 *           getSubtotal       : 상품 합계 금액(서버 계산)
 *           getShippingFee    : 배송비(5만원 이상 무료, 미만 3,000원)
 *           getTotal          : 결제 예정 금액(상품 합계 + 배송비)
 *  ※ 김성민(20231553)이 추가한 신규 소스이며 기존 팀원 코드는 수정하지 않았다.
 *    배송비 기준 금액은 팀의 PriceCalculator 상수를 그대로 재사용한다.
 * ============================================================================
 */
package kr.ac.dy.cs.cart;

import kr.ac.dy.cs.order.PriceCalculator;
import kr.ac.dy.cs.order.ProductCatalog;

import java.util.List;
import java.util.Optional;

public class CartService {

    private final CartRepository cartRepository;

    public CartService() {
        this.cartRepository = new CartRepository();
    }

    /**
     * 회원의 장바구니 ID 를 확보한다. 없으면 새로 생성한다.
     */
    public long getOrCreateCartId(String memberId) {
        Long cartId = cartRepository.selectCartId(memberId);
        if (cartId == null) {
            cartId = cartRepository.insertCart(memberId);
        }
        return cartId;
    }

    /**
     * FR-01 장바구니 담기.
     * - 상품 정보(이름/브랜드/가격/이미지)는 서버 ProductCatalog 에서 조회해 신뢰한다.
     * - 카탈로그에 없는 상품이면 담지 않는다.
     * - 동일 상품이 이미 있으면 수량만 누적, 없으면 새로 INSERT.
     */
    public void addItem(String memberId, String productId, int quantity) {
        Optional<ProductCatalog.Product> found = ProductCatalog.findById(productId);
        if (found.isEmpty()) {
            return; // 존재하지 않는 상품은 무시
        }
        if (quantity < 1) {
            quantity = 1;
        }

        ProductCatalog.Product product = found.get();
        long cartId = getOrCreateCartId(memberId);

        CartItemDto exist = cartRepository.selectItem(cartId, productId);
        if (exist != null) {
            // 이미 담긴 상품 → 기존 수량 + 신규 수량
            cartRepository.updateQuantity(exist.getCartItemId(), exist.getQuantity() + quantity);
        } else {
            // 신규 상품 → 서버 가격으로 INSERT
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
     * FR-02 장바구니 목록 조회. 장바구니가 없는 회원이면 빈 목록을 반환한다.
     */
    public List<CartItemDto> getItems(String memberId) {
        Long cartId = cartRepository.selectCartId(memberId);
        if (cartId == null) {
            return List.of();
        }
        return cartRepository.selectItems(cartId);
    }

    /**
     * FR-03 수량 변경. 최소 수량은 1 로 보정한다.
     */
    public void changeQuantity(long cartItemId, int quantity) {
        if (quantity < 1) {
            quantity = 1;
        }
        cartRepository.updateQuantity(cartItemId, quantity);
    }

    /**
     * FR-04 장바구니 상품 개별 삭제.
     */
    public void removeItem(long cartItemId) {
        cartRepository.deleteItem(cartItemId);
    }

    /**
     * FR-05 장바구니 전체 비우기.
     */
    public void clear(String memberId) {
        Long cartId = cartRepository.selectCartId(memberId);
        if (cartId != null) {
            cartRepository.deleteAllItems(cartId);
        }
    }

    /**
     * FR-06 헤더 배지에 표시할 장바구니 총 수량.
     */
    public int getTotalQuantity(List<CartItemDto> items) {
        int total = 0;
        for (CartItemDto item : items) {
            total += item.getQuantity();
        }
        return total;
    }

    /**
     * 상품 합계 금액(서버 저장값 기준으로 계산).
     */
    public int getSubtotal(List<CartItemDto> items) {
        int subtotal = 0;
        for (CartItemDto item : items) {
            subtotal += item.getLineTotal();
        }
        return subtotal;
    }

    /**
     * 배송비 계산 : 팀의 PriceCalculator 기준(5만원 이상 무료, 미만 3,000원)을 재사용.
     */
    public int getShippingFee(int subtotal) {
        if (subtotal <= 0) {
            return 0;
        }
        return subtotal >= PriceCalculator.FREE_SHIPPING_THRESHOLD ? 0 : PriceCalculator.DEFAULT_SHIPPING_FEE;
    }

    /**
     * 결제 예정 금액 = 상품 합계 + 배송비.
     */
    public int getTotal(List<CartItemDto> items) {
        int subtotal = getSubtotal(items);
        return subtotal + getShippingFee(subtotal);
    }
}
