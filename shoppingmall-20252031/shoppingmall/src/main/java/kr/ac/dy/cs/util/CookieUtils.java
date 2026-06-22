package kr.ac.dy.cs.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtils {

    /**
     * 쿠키추가
     */
    public static void add(HttpServletResponse response, String key, String value) {
        Cookie cookie = new Cookie(key, value);
        response.addCookie(cookie);
    }

    public static void remove(HttpServletResponse response, String key) {
        Cookie cookie = new Cookie(key, "");
        cookie.setMaxAge(-1);
        response.addCookie(cookie);
    }

    public static void addSaveId(HttpServletResponse response, String id) {
        add(response, "saveId", id);
    }

    public static void removeSaveId(HttpServletResponse response) {
        remove(response, "saveId");
    }


}
