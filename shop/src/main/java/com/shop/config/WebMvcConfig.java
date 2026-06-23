package com.shop.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
                .addPathPatterns("/products/*/buy", "/cart/**", "/mypage/**", "/admin/**")
                .excludePathPatterns("/auth/**", "/", "/products", "/products/*",
                        "/css/**", "/js/**", "/images/**", "/h2-console/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**").addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/js/**").addResourceLocations("classpath:/static/js/");
    }

    // H2 콘솔은 iframe을 사용하는데, 브라우저가 X-Frame-Options 때문에 막음
    // → SAMEORIGIN 허용 헤더 추가
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/h2-console/**").allowedOrigins("*");
    }
}