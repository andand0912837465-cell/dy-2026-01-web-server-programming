package kr.ac.dy.cs.product;

import java.util.ArrayList;
import java.util.List;

/**
 * 20252377 양효재
 * 부분 구현된 상품 관리 서비스가 남아 있어서 개선 진행하였다.
 * 상품 목록 조회 위주였던 구조를 보완해서 등록과 수정과 삭제 요청도
 * 같은 서비스 계층에서 검증하고 처리하도록 맞춰 두었다.
 * 부분 구현된 재고 관리 항목이 남아 있어서 개선 진행하였다.
 * 서비스 검증 단계에서도 재고 값이 음수가 되지 않게 확인해서,
 * 백오피스에서 잘못된 재고 수량이 저장되지 않도록 보완했다.
 */
public class ProductService {

    private final ProductRepository productRepository = new ProductRepository();

    public List<ProductDto> getProducts() {
        return productRepository.selectAll();
    }

    public ProductDto getProduct(String productId) {
        if (productId == null || productId.isBlank()) {
            return null;
        }

        return productRepository.selectById(productId);
    }

    public List<ProductReviewDto> getReviews(String productId) {
        if (productId == null || productId.isBlank()) {
            return new ArrayList<>();
        }

        return productRepository.selectReviews(productId);
    }

    public boolean deleteReview(long reviewNo, String productId) {
        if (reviewNo <= 0) {
            return false;
        }

        if (productId == null || productId.isBlank()) {
            return false;
        }

        return productRepository.deleteReview(reviewNo, productId) > 0;
    }

    public boolean createProduct(ProductDto product) {
        if (!isValidProduct(product) || getProduct(product.getProductId()) != null) {
            return false;
        }
        return productRepository.insertProduct(product) > 0;
    }

    public boolean updateProduct(ProductDto product) {
        if (!isValidProduct(product)) {
            return false;
        }
        return productRepository.updateProduct(product) > 0;
    }

    public boolean deleteProduct(String productId) {
        if (productId == null || productId.isBlank()) {
            return false;
        }
        return productRepository.deleteProduct(productId.trim()) > 0;
    }

    private boolean isValidProduct(ProductDto product) {
        if (product == null) {
            return false;
        }
        if (product.getProductId() == null || product.getProductId().isBlank()) {
            return false;
        }
        if (product.getName() == null || product.getName().isBlank()) {
            return false;
        }
        if (product.getBrand() == null || product.getBrand().isBlank()) {
            return false;
        }
        return product.getOriginalPrice() >= 0
                && product.getSalePrice() >= 0
                && product.getStock() >= 0;
    }
}
