/*
 * 20252361 김지연 - productId 기준 찜 추가/해제 요청 처리
 */
package kr.ac.dy.cs;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

/*20252358최윤서
화면에서 보내온 신호를 받아서 세션에 유지되는 데이터를 직접 갱신하는 주요 역할
사용자가 어떤 상품을 클릭했는지 데이터 읽음, 찜 목록 리스트 생성, 리스트에 상품을 추가하거나 지워버림 등*/

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String productId = trim(request.getParameter("productId"));
        String productName = trim(request.getParameter("productName"));
        String likedValue = trim(request.getParameter("liked"));

        if (productId.isEmpty() || likedValue.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("invalid request");
            return;
        }

        boolean liked = Boolean.parseBoolean(likedValue);
        HttpSession session = request.getSession();

        ArrayList<String> wishlist = getStringList(session, "wishlist");
        ArrayList<String> wishlistNames = getStringList(session, "wishlistProductNames");

        if (liked) {
            if (!wishlist.contains(productId)) {
                wishlist.add(productId);
                wishlistNames.add(productName);
            }
        } else {
            int index = wishlist.indexOf(productId);
            if (index >= 0) {
                wishlist.remove(index);
                if (index < wishlistNames.size()) {
                    wishlistNames.remove(index);
                }
            }
        }

        session.setAttribute("wishlist", wishlist);
        session.setAttribute("wishlistProductNames", wishlistNames);
        response.getWriter().print("success");
    }

    @SuppressWarnings("unchecked")
    private ArrayList<String> getStringList(HttpSession session, String attributeName) {
        Object value = session.getAttribute(attributeName);
        if (value instanceof ArrayList<?>) {
            return (ArrayList<String>) value;
        }

        return new ArrayList<>();
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
