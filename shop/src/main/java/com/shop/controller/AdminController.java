package com.shop.controller;

import com.shop.dto.ProductDto;
import com.shop.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final ProductService productService;

    @GetMapping
    public String adminMain(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "admin/index";
    }

    @GetMapping("/products/new")
    public String newProductForm(Model model) {
        model.addAttribute("productDto", new ProductDto());
        return "admin/product-form";
    }

    @PostMapping("/products/new")
    public String addProduct(@Valid @ModelAttribute ProductDto productDto,
                             BindingResult bindingResult,
                             Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/product-form";
        }
        productService.addProduct(productDto);
        return "redirect:/admin";
    }

    @PostMapping("/products/{id}/delete")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/admin";
    }
}
