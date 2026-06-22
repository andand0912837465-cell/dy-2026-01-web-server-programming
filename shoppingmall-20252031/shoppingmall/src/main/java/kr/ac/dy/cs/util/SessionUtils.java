package kr.ac.dy.cs.util;

import jakarta.servlet.http.HttpSession;

public class SessionUtils {

    /**
     * 로그인 여부?
     */
    public static boolean isLoginYn(HttpSession session) {
        return session != null && session.getAttribute("loginId") != null;
    }

}
