package com.shop.controller;

import com.shop.config.CookieUtil;
import com.shop.entity.Product;
import com.shop.service.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping
    public String list(@RequestParam(required = false) String category,
                       @RequestParam(required = false) String keyword,
                       HttpServletRequest request,
                       Model model) {
        List<Product> products;
        if (keyword != null && !keyword.isBlank()) {
            products = productService.search(keyword);
            model.addAttribute("keyword", keyword);
        } else if (category != null && !category.isBlank()) {
            products = productService.getByCategory(category);
            model.addAttribute("selectedCategory", category);
        } else {
            products = productService.getAllProducts();
        }

        // 최근 본 상품
        List<Long> recentIds = CookieUtil.getRecentProductLongIds(request);
        List<Product> recentProducts = productService.getProductsByIds(recentIds);
        // 쿠키 순서대로 정렬
        recentProducts.sort((a, b) -> recentIds.indexOf(a.getId()) - recentIds.indexOf(b.getId()));

        model.addAttribute("products", products);
        model.addAttribute("recentProducts", recentProducts);
        return "product/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id,
                         HttpServletRequest request,
                         HttpServletResponse response,
                         Model model) {
        return productService.getProduct(id)
                .map(product -> {
                    CookieUtil.addRecentProduct(request, response, id);

                    List<Long> recentIds = CookieUtil.getRecentProductLongIds(request);
                    List<Product> recentProducts = productService.getProductsByIds(recentIds);
                    recentProducts.sort((a, b) -> recentIds.indexOf(a.getId()) - recentIds.indexOf(b.getId()));

                    model.addAttribute("product", product);
                    model.addAttribute("recentProducts", recentProducts);
                    return "product/detail";
                })
                .orElse("redirect:/products");
    }

    @GetMapping("/{id}/buy")
    public String buyPage(@PathVariable Long id,
                          HttpSession session,
                          Model model) {
        return productService.getProduct(id)
                .map(product -> {
                    model.addAttribute("product", product);
                    model.addAttribute("loginEmail", session.getAttribute("loginEmail"));
                    return "product/buy";
                })
                .orElse("redirect:/products");
    }
}
