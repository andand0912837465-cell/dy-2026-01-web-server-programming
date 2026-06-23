package kr.ac.dy.cs.java_20251242;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItem {

    private Long   cartItemId;   // CART_ITEM 기본키
    private Long   cartId;       // 소속 장바구니(CART) 식별자
    private String productId;    // 상품 식별자 (ProductCatalog 의 id, 예: best-0)
    private String productName;  // 상품명
    private String brand;        // 브랜드명
    private int    price;        // 담을 당시 판매가(서버 ProductCatalog 기준 스냅샷)
    private String imageUrl;     // 상품 이미지 URL
    private int    quantity;     // 담은 수량(동일 상품 재담기 시 누적)

    /**
     * 화면 표시용 파생값 : 이 상품 줄의 합계 금액(가격 × 수량)
     */
    public int getLineTotal() {
        return price * quantity;
    }
}
