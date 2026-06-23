package com.shop.dto;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ProductDto {

    @NotBlank(message = "상품명을 입력해주세요")
    private String name;

    @NotBlank(message = "브랜드를 입력해주세요")
    private String brand;

    @NotNull(message = "가격을 입력해주세요")
    @Min(value = 0, message = "가격은 0원 이상이어야 합니다")
    private Integer price;

    private String description;

    private String imageUrl;

    @NotBlank(message = "카테고리를 선택해주세요")
    private String category;

    @NotNull(message = "재고를 입력해주세요")
    @Min(value = 0, message = "재고는 0개 이상이어야 합니다")
    private Integer stock;
}
