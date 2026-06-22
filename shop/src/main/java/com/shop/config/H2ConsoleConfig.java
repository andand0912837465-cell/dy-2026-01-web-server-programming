package com.shop.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class H2ConsoleConfig {

    // H2 콘솔은 내부적으로 iframe을 사용함
    // 브라우저가 X-Frame-Options: DENY 헤더를 보면 iframe 렌더링을 막아버림
    // → /h2-console/** 경로에만 SAMEORIGIN으로 덮어쓰는 필터 등록
    @Bean
    public FilterRegistrationBean<Filter> h2ConsoleHeaderFilter() {
        FilterRegistrationBean<Filter> bean = new FilterRegistrationBean<>();
        bean.setFilter(new Filter() {
            @Override
            public void doFilter(ServletRequest request, ServletResponse response,
                                 FilterChain chain) throws IOException, ServletException {
                HttpServletResponse res = (HttpServletResponse) response;
                res.setHeader("X-Frame-Options", "SAMEORIGIN");
                chain.doFilter(request, response);
            }
        });
        bean.addUrlPatterns("/h2-console/*");
        bean.setOrder(1);
        return bean;
    }
}