document.addEventListener('DOMContentLoaded', function () {
    const CART_STORAGE_KEY = 'shopmallCart';
    const FREE_SHIPPING_MINIMUM = 50000;
    const SHIPPING_FEE = 3000;

    const cartBadge = document.querySelector('#cartBadge');
    const cartEmpty = document.querySelector('#cartEmpty');
    const cartContent = document.querySelector('#cartContent');
    const cartTableBody = document.querySelector('#cartTableBody');
    const cartSubtotal = document.querySelector('#cartSubtotal');
    const cartShipping = document.querySelector('#cartShipping');
    const cartTotal = document.querySelector('#cartTotal');
    const checkoutButton = document.querySelector('#checkoutButton');

    if (!cartEmpty || !cartContent || !cartTableBody || !checkoutButton) {
        return;
    }

    let cartItems = readCartItems();

    function readCartItems() {
        try {
            const storedValue = localStorage.getItem(CART_STORAGE_KEY);

            if (!storedValue) {
                return [];
            }

            const parsedValue = JSON.parse(storedValue);

            if (!Array.isArray(parsedValue)) {
                return [];
            }

            return parsedValue
                .filter(function (item) {
                    return item && typeof item.id === 'string' && item.id.length > 0;
                })
                .map(function (item) {
                    const price = Number(item.price);
                    const quantity = Number(item.quantity);

                    return {
                        id: item.id,
                        name: String(item.name || ''),
                        brand: String(item.brand || ''),
                        price: Number.isFinite(price) ? Math.max(0, price) : 0,
                        image: String(item.image || ''),
                        quantity: Number.isFinite(quantity) ? Math.max(1, Math.floor(quantity)) : 1
                    };
                });
        } catch (error) {
            return [];
        }
    }

    function saveCartItems() {
        try {
            localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(cartItems));
        } catch (error) {
            return;
        }
    }

    function formatPrice(price) {
        return Number(price || 0).toLocaleString('ko-KR') + '원';
    }

    function getTotalQuantity() {
        return cartItems.reduce(function (total, item) {
            return total + item.quantity;
        }, 0);
    }

    function updateCartBadge() {
        if (!cartBadge) {
            return;
        }

        const totalQuantity = getTotalQuantity();
        cartBadge.textContent = String(totalQuantity);
        cartBadge.hidden = totalQuantity === 0;
    }

    function getSubtotal() {
        return cartItems.reduce(function (total, item) {
            return total + item.price * item.quantity;
        }, 0);
    }

    function updateSummary() {
        const subtotal = getSubtotal();
        const shipping = subtotal >= FREE_SHIPPING_MINIMUM ? 0 : SHIPPING_FEE;
        const total = subtotal + shipping;

        cartSubtotal.textContent = formatPrice(subtotal);
        cartShipping.textContent = formatPrice(shipping);
        cartTotal.textContent = formatPrice(total);
    }

    function changeQuantity(productId, amount) {
        const targetItem = cartItems.find(function (item) {
            return item.id === productId;
        });

        if (!targetItem) {
            return;
        }

        targetItem.quantity = Math.max(1, targetItem.quantity + amount);
        saveCartItems();
        renderCart();
    }

    function removeCartItem(productId) {
        cartItems = cartItems.filter(function (item) {
            return item.id !== productId;
        });
        saveCartItems();
        renderCart();
    }

    function createTextCell(text, className) {
        const cell = document.createElement('td');

        if (className) {
            cell.className = className;
        }

        cell.textContent = text;
        return cell;
    }

    function createQuantityControl(item) {
        const wrapper = document.createElement('div');
        const decreaseButton = document.createElement('button');
        const quantityText = document.createElement('span');
        const increaseButton = document.createElement('button');

        wrapper.className = 'qty-control';

        decreaseButton.type = 'button';
        decreaseButton.textContent = '-';
        decreaseButton.disabled = item.quantity <= 1;
        decreaseButton.setAttribute('aria-label', item.name + ' 수량 감소');
        decreaseButton.addEventListener('click', function () {
            changeQuantity(item.id, -1);
        });

        quantityText.textContent = String(item.quantity);

        increaseButton.type = 'button';
        increaseButton.textContent = '+';
        increaseButton.setAttribute('aria-label', item.name + ' 수량 증가');
        increaseButton.addEventListener('click', function () {
            changeQuantity(item.id, 1);
        });

        wrapper.appendChild(decreaseButton);
        wrapper.appendChild(quantityText);
        wrapper.appendChild(increaseButton);
        return wrapper;
    }

    function createProductCell(item) {
        const cell = document.createElement('td');
        const product = document.createElement('div');
        const image = document.createElement('img');
        const textBox = document.createElement('div');
        const brand = document.createElement('div');
        const name = document.createElement('div');

        product.className = 'cart-product';
        image.src = item.image;
        image.alt = item.name;
        image.loading = 'lazy';
        brand.className = 'cart-brand';
        brand.textContent = item.brand;
        name.className = 'cart-name';
        name.textContent = item.name;

        textBox.appendChild(brand);
        textBox.appendChild(name);
        product.appendChild(image);
        product.appendChild(textBox);
        cell.appendChild(product);
        return cell;
    }

    function createQuantityCell(item) {
        const cell = document.createElement('td');
        cell.appendChild(createQuantityControl(item));
        return cell;
    }

    function createRemoveCell(item) {
        const cell = document.createElement('td');
        const button = document.createElement('button');

        button.type = 'button';
        button.className = 'remove-cart-btn';
        button.textContent = '삭제';
        button.setAttribute('aria-label', item.name + ' 삭제');
        button.addEventListener('click', function () {
            removeCartItem(item.id);
        });

        cell.appendChild(button);
        return cell;
    }

    function createCartRow(item) {
        const row = document.createElement('tr');
        const lineTotal = item.price * item.quantity;

        row.appendChild(createProductCell(item));
        row.appendChild(createTextCell(formatPrice(item.price), 'cart-price'));
        row.appendChild(createQuantityCell(item));
        row.appendChild(createTextCell(formatPrice(lineTotal), 'cart-line-total'));
        row.appendChild(createRemoveCell(item));
        return row;
    }

    function renderCart() {
        const isEmpty = cartItems.length === 0;

        cartEmpty.hidden = !isEmpty;
        cartContent.hidden = isEmpty;
        checkoutButton.disabled = isEmpty;
        cartTableBody.replaceChildren();

        if (isEmpty) {
            updateCartBadge();
            return;
        }

        cartItems.forEach(function (item) {
            cartTableBody.appendChild(createCartRow(item));
        });

        updateSummary();
        updateCartBadge();
    }

    checkoutButton.addEventListener('click', function () {
        if (cartItems.length === 0) {
            return;
        }

        window.location.href = '/order/checkout.jsp';
    });

    saveCartItems();
    renderCart();
});
