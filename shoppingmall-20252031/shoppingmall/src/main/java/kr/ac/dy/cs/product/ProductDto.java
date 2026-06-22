/**
 * 20252031 이준성
 * 상품 정보 DTO 클래스임.
 */
package kr.ac.dy.cs.product;

import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ProductDto {

    private String id;          // PRODUCT.ID (UUID)
    private String name;        // PRODUCT.NAME
    private int price;          // PRODUCT.PRICE (원가)
    private int salePrice;      // PRODUCT.SALE_PRICE (판매가)

    // PRODUCT.DATA (JSON) 에서 파싱
    private String brand;
    private String image;

    /**
     * 할인율(%) 계산 - 원가 대비 판매가 기준
     */
    public int getDiscountRate() {
        if (price <= 0 || salePrice <= 0 || salePrice >= price) {
            return 0;
        }
        return (int) Math.round((price - salePrice) * 100.0 / price);
    }

}
