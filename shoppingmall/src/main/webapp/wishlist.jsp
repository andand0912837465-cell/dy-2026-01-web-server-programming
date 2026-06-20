<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<!-- 20252358최윤서
찜 목록 구현
찜한 상품들을 모아서 볼 수 있는 화면+찜 목록에서 찜 해제 가능
찜한 상품이 없을 때 찜 목록 들어가면 찜한 상품이 없다고 안내
메인으로 가는 링크도 넣음 -->
<html>
<head>
    <title>찜 목록</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        /* 찜 목록에서는 무조건 하트가 채워진 빨간색 상태로 시작하도록 강제 설정 */
        .product-grid .like-btn.wish-page-active {
            background: #ff6b6b;
            color: #fff;
            box-shadow: 0 6px 14px rgba(255,107,107,0.28);
        }
    </style>
</head>
<body>

<div class="container" style="margin-top: 48px;">
    <h1>찜 목록</h1>
    <p style="margin-bottom: 24px;"><a href="index.jsp">← 메인으로 가기</a></p>

    <%
        ArrayList<String> wishlist = (ArrayList<String>) session.getAttribute("wishlist");
        if(wishlist == null){
            wishlist = new ArrayList<>();
        }

        if(wishlist.isEmpty()){
    %>
    <div class="product-empty">찜한 상품이 없습니다.</div>
    <%
    } else {
        // 인기 상품 데이터
        Object[][] bestProducts = {
                {"오버사이즈 코튼 셔츠", "BASIC HOUSE", 59000, 39000, 33, 4.8, 1245, "shirt01"},
                {"슬림핏 데님 팬츠", "DENIM CO.", 89000, 62300, 30, 4.6, 892, "denim02"},
                {"미니멀 크로스백", "MUJI STYLE", 120000, 84000, 30, 4.9, 2134, "bag03"},
                {"러닝 스니커즈", "ATHLEISURE", 159000, 119000, 25, 4.7, 567, "shoes04"},
                {"실크 블라우스", "ELEGANT", 98000, 68600, 30, 4.5, 423, "blouse05"},
                {"가죽 토트백", "LEATHER LAB", 280000, 196000, 30, 4.9, 1876, "tote06"},
                {"캐주얼 자켓", "URBAN STREET", 145000, 101500, 30, 4.4, 312, "jacket07"},
                {"실버 목걸이", "AURUM", 75000, 56250, 25, 4.8, 945, "necklace08"}
        };
    %>
    <div class="product-grid">
        <%
            for (int i = 0; i < bestProducts.length; i++) {
                Object[] p = bestProducts[i];
                String productName = (String)p[0];
                String productId = "best-" + i; // 메인과 ID 체계 통일

                if(!wishlist.contains(productName)){
                    continue;
                }

                String productBrand = (String)p[1];
                int originalPrice = (Integer)p[2];
                int salePrice = (Integer)p[3];
                int discount = (Integer)p[4];
                double rating = (Double)p[5];
                int review = (Integer)p[6];
                String productImage = "https://picsum.photos/seed/" + p[7] + "/400/500";
        %>
        <div class="product-card"
             data-id="<%= productId %>"
             data-name="<%= productName %>"
             data-brand="<%= productBrand %>"
             data-price="<%= salePrice %>"
             data-rate="<%= rating %>"
             data-image="<%= productImage %>"
             data-category="의류">

            <div class="product-img">
                <img src="<%= productImage %>">
                <button type="button" class="like-btn wish-page-active" onclick="removeWishItem(this, '<%= productName %>', '<%= productId %>')">♥</button>
            </div>

            <div class="product-info">
                <div class="product-brand"><%= productBrand %></div>
                <div class="product-name"><%= productName %></div>
                <div class="product-price">
                    <span class="discount"><%= discount %>%</span>
                    <span class="price"><%= String.format("%,d", salePrice) %>원</span>
                    <span class="original"><%= String.format("%,d", originalPrice) %>원</span>
                </div>
                <div class="product-rate">
                    ★ <%= rating %> · 리뷰 <%= review %>
                </div>
                <button type="button" class="add-cart-btn">장바구니 담기</button>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>
</div>

<script src="js/shop.js"></script>

<script>
    function removeWishItem(button, productName, productId) {
        // [Action 1] 서버 세션에서 상품 제거 요청
        fetch("wishlist", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "productName=" + encodeURIComponent(productName) + "&liked=false"
        })
            .then(response => response.text())
            .then(data => {
                // [Action 2] 브라우저 LocalStorage에서도 삭제 (메인 페이지 하트 해제 동기화용)
                const storageKey = 'shopmallWishlist';
                let localIds = [];
                try {
                    localIds = JSON.parse(localStorage.getItem(storageKey)) || [];
                } catch(e) {}

                localIds = localIds.filter(id => id !== productId);
                localStorage.setItem(storageKey, JSON.stringify(localIds));

                // [Action 3] 헤더 찜 배지 숫자 동기화 변경
                const badge = document.querySelector('#wishlistBadge');
                if(badge) {
                    badge.textContent = localIds.length;
                    if(localIds.length === 0) badge.hidden = true;
                }

                // [Action 4] 화면에서 해당 상품 카드 즉시 제거 (새로고침 없음)
                const card = button.closest('.product-card');
                if (card) {
                    card.remove();
                }

                // [Action 5] 만약 찜 목록의 모든 상품이 사라졌다면 '찜한 상품이 없습니다' 멘트를 띄우기 위해 리로드
                const remainingCards = document.querySelectorAll('.product-grid .product-card');
                if (remainingCards.length === 0) {
                    location.reload();
                }
            })
            .catch(error => console.error("오류 발생:", error));
    }
</script>
</body>
</html>