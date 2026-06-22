package kr.ac.dy.cs.product;

import java.util.ArrayList;
import java.util.List;

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
}
