package com.shop.controller;

import com.shop.config.CookieUtil;
import com.shop.entity.Product;
import com.shop.service.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final ProductService productService;

    @GetMapping("/")
    public String home(HttpServletRequest request, Model model) {
        List<Product> products = productService.getAllProducts();
        List<Long> recentIds = CookieUtil.getRecentProductLongIds(request);
        List<Product> recentProducts = productService.getProductsByIds(recentIds);
        recentProducts.sort((a, b) -> recentIds.indexOf(a.getId()) - recentIds.indexOf(b.getId()));

        model.addAttribute("products", products.stream().limit(8).toList());
        model.addAttribute("recentProducts", recentProducts);
        return "index";
    }
}
