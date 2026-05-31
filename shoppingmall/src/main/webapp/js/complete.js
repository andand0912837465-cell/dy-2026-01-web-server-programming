document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const CART_STORAGE_KEY = 'shopmallCart';
    const LAST_ORDER_STORAGE_KEY = 'shopmallLastOrder';

    const wishlistBadge = document.querySelector('#wishlistBadge');
    const cartBadge = document.querySelector('#cartBadge');
    const completeEmpty = document.querySelector('#completeEmpty');
    const completeContent = document.querySelector('#completeContent');
    const completeCustomerName = document.querySelector('#completeCustomerName');
    const completeOrderedAt = document.querySelector('#completeOrderedAt');
    const completeTotal = document.querySelector('#completeTotal');
    const completeItemList = document.querySelector('#completeItemList');

    if (
        !completeEmpty ||
        !completeContent ||
        !completeCustomerName ||
        !completeOrderedAt ||
        !completeTotal ||
        !completeItemList
    ) {
        return;
    }

    const lastOrder = readLastOrder();

    function readLastOrder() {
        try {
            const storedValue = localStorage.getItem(LAST_ORDER_STORAGE_KEY);

            if (!storedValue) {
                return null;
            }

            const parsedValue = JSON.parse(storedValue);

            if (!parsedValue || !Array.isArray(parsedValue.items)) {
                return null;
            }

            return parsedValue;
        } catch (error) {
            return null;
        }
    }

    function formatPrice(price) {
        const numericPrice = Number(price);
        const safePrice = Number.isFinite(numericPrice) ? numericPrice : 0;

        return safePrice.toLocaleString('ko-KR') + '원';
    }

    function formatOrderedAt(value) {
        const date = new Date(value);

        if (Number.isNaN(date.getTime())) {
            return '';
        }

        return date.toLocaleString('ko-KR');
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
                return typeof productId === 'string' && productId.length > 0;
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

    function updateCartBadgeFromCart() {
        if (!cartBadge) {
            return;
        }

        const totalQuantity = readCartQuantity();
        cartBadge.textContent = String(totalQuantity);
        cartBadge.hidden = totalQuantity === 0;
    }

    function updateCartBadgeToEmpty() {
        try {
            localStorage.removeItem(CART_STORAGE_KEY);
        } catch (error) {
            return;
        }

        if (!cartBadge) {
            return;
        }

        cartBadge.textContent = '0';
        cartBadge.hidden = true;
    }

    function createCompleteItem(item) {
        const wrapper = document.createElement('div');
        const nameBox = document.createElement('div');
        const name = document.createElement('strong');
        const meta = document.createElement('span');
        const price = document.createElement('strong');
        const itemPrice = Number(item.price || 0);
        const quantity = Number(item.quantity || 0);
        const safePrice = Number.isFinite(itemPrice) ? Math.max(0, itemPrice) : 0;
        const safeQuantity = Number.isFinite(quantity) ? Math.max(1, Math.floor(quantity)) : 1;

        wrapper.className = 'order-item';
        name.textContent = String(item.name || '');
        meta.textContent = String(item.brand || '') + ' · 수량 ' + safeQuantity + '개';
        price.textContent = formatPrice(safePrice * safeQuantity);

        nameBox.appendChild(name);
        nameBox.appendChild(meta);
        wrapper.appendChild(nameBox);
        wrapper.appendChild(price);
        return wrapper;
    }

    function renderComplete() {
        const hasOrder = lastOrder !== null;

        updateWishlistBadge();
        completeEmpty.hidden = hasOrder;
        completeContent.hidden = !hasOrder;

        if (!hasOrder) {
            updateCartBadgeFromCart();
            return;
        }

        updateCartBadgeToEmpty();

        completeCustomerName.textContent = String(lastOrder.customerName || '고객');
        completeOrderedAt.textContent = formatOrderedAt(lastOrder.orderedAt);
        completeTotal.textContent = formatPrice(lastOrder.total);
        completeItemList.replaceChildren();

        lastOrder.items.forEach(function (item) {
            completeItemList.appendChild(createCompleteItem(item));
        });
    }

    renderComplete();
});
