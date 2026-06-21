/*
 * 20252361 김지연
 * 기능 설명: 서버 주문 검증에 사용하는 SHOPMALL 상품 카탈로그
 */
package kr.ac.dy.cs.order;

import java.util.List;
import java.util.Optional;

public final class ProductCatalog {

    private static final String IMAGE_BASE_URL = "https://picsum.photos/seed/";

    private static final List<Product> PRODUCTS = List.of(
            new Product("best-0", "오버사이즈 코튼 셔츠", "BASIC HOUSE", "의류", 59000, 39000, 33, 4.8, 1245, "shirt01", "BEST 1"),
            new Product("best-1", "슬림핏 데님 팬츠", "DENIM CO.", "의류", 89000, 62300, 30, 4.6, 892, "denim02", "BEST 2"),
            new Product("best-2", "미니멀 크로스백", "MUJI STYLE", "가방", 120000, 84000, 30, 4.9, 2134, "bag03", "BEST 3"),
            new Product("best-3", "러닝 스니커즈", "ATHLEISURE", "신발", 159000, 119000, 25, 4.7, 567, "shoes04", "SALE"),
            new Product("best-4", "실크 블라우스", "ELEGANT", "의류", 98000, 68600, 30, 4.5, 423, "blouse05", "SALE"),
            new Product("best-5", "가죽 토트백", "LEATHER LAB", "가방", 280000, 196000, 30, 4.9, 1876, "tote06", "SALE"),
            new Product("best-6", "캐주얼 자켓", "URBAN STREET", "의류", 145000, 101500, 30, 4.4, 312, "jacket07", "SALE"),
            new Product("best-7", "실버 목걸이", "AURUM", "액세서리", 75000, 56250, 25, 4.8, 945, "necklace08", "SALE"),
            new Product("new-0", "린넨 원피스", "SUMMER LINE", "의류", 78000, 78000, 0, 0.0, 0, "dress11", "NEW"),
            new Product("new-1", "체크 셔츠", "CASUAL DAY", "의류", 56000, 56000, 0, 0.0, 0, "check12", "NEW"),
            new Product("new-2", "캔버스 스니커즈", "DAILY WALK", "신발", 89000, 89000, 0, 0.0, 0, "canvas13", "HOT"),
            new Product("new-3", "버킷햇", "STREET MODE", "액세서리", 35000, 35000, 0, 0.0, 0, "hat14", "NEW")
    );

    private ProductCatalog() {
    }

    public static List<Product> findAll() {
        return PRODUCTS;
    }

    public static Optional<Product> findById(String productId) {
        if (productId == null || productId.trim().isEmpty()) {
            return Optional.empty();
        }

        String trimmedProductId = productId.trim();
        return PRODUCTS.stream()
                .filter(product -> product.getId().equals(trimmedProductId))
                .findFirst();
    }

    public static final class Product {
        private final String id;
        private final String name;
        private final String brand;
        private final String category;
        private final int originalPrice;
        private final int salePrice;
        private final int discountRate;
        private final double rating;
        private final int reviewCount;
        private final String imageSeed;
        private final String label;

        private Product(String id, String name, String brand, String category, int originalPrice, int salePrice,
                        int discountRate, double rating, int reviewCount, String imageSeed, String label) {
            this.id = id;
            this.name = name;
            this.brand = brand;
            this.category = category;
            this.originalPrice = originalPrice;
            this.salePrice = salePrice;
            this.discountRate = discountRate;
            this.rating = rating;
            this.reviewCount = reviewCount;
            this.imageSeed = imageSeed;
            this.label = label;
        }

        public String getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getBrand() {
            return brand;
        }

        public String getCategory() {
            return category;
        }

        public int getOriginalPrice() {
            return originalPrice;
        }

        public int getSalePrice() {
            return salePrice;
        }

        public int getDiscountRate() {
            return discountRate;
        }

        public double getRating() {
            return rating;
        }

        public int getReviewCount() {
            return reviewCount;
        }

        public String getImageUrl() {
            return IMAGE_BASE_URL + imageSeed + "/400/400";
        }

        public String getLabel() {
            return label;
        }

        public boolean isBestProduct() {
            return id.startsWith("best-");
        }
    }
}
