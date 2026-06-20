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



        String productName = request.getParameter("productName");

        System.out.println("productName = " + productName);
        System.out.println("liked 문자열 = " + request.getParameter("liked"));



        boolean liked =
                Boolean.parseBoolean(request.getParameter("liked"));

        HttpSession session =
                request.getSession();

        ArrayList<String> wishlist =
                (ArrayList<String>)
                        session.getAttribute("wishlist");

        if (wishlist == null) {
            wishlist = new ArrayList<>();
        }

        if (wishlist.contains(productName)) {
            wishlist.remove(productName);
        } else {
            wishlist.add(productName);
        }

        session.setAttribute("wishlist", wishlist);

        //response.sendRedirect("index.jsp");


        System.out.println(wishlist);
        System.out.println("liked = " + liked);

        response.getWriter().print("success");
    }
}