/*
 * 20252361 김지연
 * 기능 설명: 주문 완료 후 장바구니 초기화와 상단 배지 상태 갱신
 */
document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const CART_STORAGE_KEY = 'shopmallCart';

    const wishlistBadge = document.querySelector('#wishlistBadge');
    const cartBadge = document.querySelector('#cartBadge');
    const isOrderComplete = document.body && document.body.dataset.orderComplete === 'true';

    function readWishlistCount() {
        try {
            const storedValue = localStorage.getItem(WISHLIST_STORAGE_KEY);
            if (!storedValue) {
                return 0;
            }

            const parsedValue = JSON.parse(storedValue);
            if (!Array.isArray(parsedValue)) {
                return 0;
            }

            const validProductIds = parsedValue.filter(function (productId) {
                return typeof productId === 'string' && productId.trim().length > 0;
            });

            return new Set(validProductIds).size;
        } catch (error) {
            return 0;
        }
    }

    function updateWishlistBadge() {
        if (!wishlistBadge) {
            return;
        }

        const wishlistCount = readWishlistCount();
        wishlistBadge.textContent = String(wishlistCount);
        wishlistBadge.hidden = wishlistCount === 0;
    }

    function readCartQuantity() {
        try {
            const storedValue = localStorage.getItem(CART_STORAGE_KEY);
            if (!storedValue) {
                return 0;
            }

            const parsedValue = JSON.parse(storedValue);
            if (!Array.isArray(parsedValue)) {
                return 0;
            }

            return parsedValue.reduce(function (total, item) {
                const quantity = item ? Number(item.quantity) : 0;
                return total + (Number.isFinite(quantity) ? Math.max(1, Math.floor(quantity)) : 0);
            }, 0);
        } catch (error) {
            return 0;
        }
    }

    function updateCartBadge(totalQuantity) {
        if (!cartBadge) {
            return;
        }

        cartBadge.textContent = String(totalQuantity);
        cartBadge.hidden = totalQuantity === 0;
    }

    if (isOrderComplete) {
        try {
            localStorage.removeItem(CART_STORAGE_KEY);
        } catch (error) {
            return;
        }
        updateCartBadge(0);
    } else {
        updateCartBadge(readCartQuantity());
    }

    updateWishlistBadge();
});
