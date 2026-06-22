package com.shop.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class CookieUtil {

    public static final String RECENT_VIEWED = "recentViewed";
    private static final int MAX_RECENT = 8;
    private static final String SEP = "|"; // 콤마 대신 파이프 사용

    public static void addRecentProduct(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Long productId) {
        LinkedList<String> ids = new LinkedList<>(getRecentProductIds(request));
        String idStr = String.valueOf(productId);
        ids.remove(idStr);
        ids.addFirst(idStr);
        if (ids.size() > MAX_RECENT) {
            ids.removeLast();
        }
        // URL 인코딩으로 쿠키 허용 문자 외 값 방지
        String raw = String.join(SEP, ids);
        String encoded = URLEncoder.encode(raw, StandardCharsets.UTF_8);
        Cookie cookie = new Cookie(RECENT_VIEWED, encoded);
        cookie.setPath("/");
        cookie.setMaxAge(60 * 60 * 24 * 7); // 7일
        cookie.setHttpOnly(false);
        response.addCookie(cookie);
    }

    public static List<String> getRecentProductIds(HttpServletRequest request) {
        if (request.getCookies() == null) return new ArrayList<>();
        return Arrays.stream(request.getCookies())
                .filter(c -> RECENT_VIEWED.equals(c.getName()))
                .findFirst()
                .map(c -> {
                    String decoded = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8);
                    return Arrays.asList(decoded.split("\\|"));
                })
                .orElse(new ArrayList<>());
    }

    public static List<Long> getRecentProductLongIds(HttpServletRequest request) {
        return getRecentProductIds(request).stream()
                .filter(s -> !s.isBlank())
                .map(s -> {
                    try { return Long.parseLong(s); }
                    catch (NumberFormatException e) { return null; }
                })
                .filter(id -> id != null)
                .collect(Collectors.toList());
    }
}