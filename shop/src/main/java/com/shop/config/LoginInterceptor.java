package com.shop.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginEmail") == null) {
            String requestURI = request.getRequestURI();
            response.sendRedirect("/auth/login?redirectUri=" + requestURI + "&alert=login");
            return false;
        }
        return true;
    }
}
