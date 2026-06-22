/*
 * ============================================================================
 *  학번 : 20231553
 *  이름 : 김성민
 *  파일 : CartItemDto.java
 *  기능 : 장바구니에 담긴 상품 1건의 정보를 담는 DTO(Data Transfer Object) 클래스.
 *         - CART_ITEM 테이블의 한 행(상품식별자/상품명/브랜드/가격/이미지/수량)을 표현한다.
 *         - 화면 표시용 파생값으로 소계(getLineTotal = 가격 × 수량)를 제공한다.
 *         - 기존 BoardDto/MemberDto 와 동일하게 Lombok 으로 게터/세터/빌더를 생성한다.
 *  ※ 본 클래스는 김성민(20231553)이 추가한 'DB 기반 장바구니' 기능 전용 신규 소스이며,
 *    다른 팀원이 작성한 기존 파일은 일절 수정하지 않았다.
 * ============================================================================
 */
package kr.ac.dy.cs.cart;

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
public class CartItemDto {

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
