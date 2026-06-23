package com.shop.service;

import com.shop.dto.ProductDto;
import com.shop.entity.Product;
import com.shop.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;

    @Transactional
    public Product addProduct(ProductDto dto) {
        Product product = Product.builder()
                .name(dto.getName())
                .brand(dto.getBrand())
                .price(dto.getPrice())
                .description(dto.getDescription())
                .imageUrl(dto.getImageUrl())
                .category(dto.getCategory())
                .stock(dto.getStock())
                .build();
        return productRepository.save(product);
    }

    public List<Product> getAllProducts() {
        return productRepository.findAllByOrderByCreatedAtDesc();
    }

    public Optional<Product> getProduct(Long id) {
        return productRepository.findById(id);
    }

    public List<Product> getByCategory(String category) {
        return productRepository.findByCategory(category);
    }

    public List<Product> search(String keyword) {
        return productRepository.findByNameContainingIgnoreCase(keyword);
    }

    @Transactional
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    public List<Product> getProductsByIds(List<Long> ids) {
        return productRepository.findAllById(ids);
    }
}
