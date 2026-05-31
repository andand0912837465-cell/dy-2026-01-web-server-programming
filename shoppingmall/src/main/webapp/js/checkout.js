document.addEventListener('DOMContentLoaded', function () {
    const CART_STORAGE_KEY = 'shopmallCart';
    const LAST_ORDER_STORAGE_KEY = 'shopmallLastOrder';
    const FREE_SHIPPING_MINIMUM = 50000;
    const SHIPPING_FEE = 3000;

    const cartBadge = document.querySelector('#cartBadge');
    const checkoutEmpty = document.querySelector('#checkoutEmpty');
    const checkoutContent = document.querySelector('#checkoutContent');
    const checkoutForm = document.querySelector('#checkoutForm');
    const checkoutError = document.querySelector('#checkoutError');
    const checkoutItemList = document.querySelector('#checkoutItemList');
    const checkoutSubtotal = document.querySelector('#checkoutSubtotal');
    const checkoutShipping = document.querySelector('#checkoutShipping');
    const checkoutTotal = document.querySelector('#checkoutTotal');

    const customerNameInput = document.querySelector('#customerName');
    const customerPhoneInput = document.querySelector('#customerPhone');
    const zipcodeInput = document.querySelector('#zipcode');
    const addressInput = document.querySelector('#address');
    const detailAddressInput = document.querySelector('#detailAddress');
    const requestMemoInput = document.querySelector('#requestMemo');

    if (!checkoutEmpty || !checkoutContent || !checkoutForm || !checkoutItemList) {
        return;
    }

    const cartItems = readCartItems();

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

    function formatPrice(price) {
        return Number(price || 0).toLocaleString('ko-KR') + '원';
    }

    function getSubtotal() {
        return cartItems.reduce(function (total, item) {
            return total + item.price * item.quantity;
        }, 0);
    }

    function getShipping(subtotal) {
        return subtotal >= FREE_SHIPPING_MINIMUM ? 0 : SHIPPING_FEE;
    }

    function updateCartBadge() {
        if (!cartBadge) {
            return;
        }

        const totalQuantity = cartItems.reduce(function (total, item) {
            return total + item.quantity;
        }, 0);

        cartBadge.textContent = String(totalQuantity);
        cartBadge.hidden = totalQuantity === 0;
    }

    function createOrderItem(item) {
        const wrapper = document.createElement('div');
        const nameBox = document.createElement('div');
        const name = document.createElement('strong');
        const meta = document.createElement('span');
        const price = document.createElement('strong');

        wrapper.className = 'order-item';
        name.textContent = item.name;
        meta.textContent = item.brand + ' · 수량 ' + item.quantity + '개';
        price.textContent = formatPrice(item.price * item.quantity);

        nameBox.appendChild(name);
        nameBox.appendChild(meta);
        wrapper.appendChild(nameBox);
        wrapper.appendChild(price);
        return wrapper;
    }

    function renderCheckout() {
        const isEmpty = cartItems.length === 0;
        const subtotal = getSubtotal();
        const shipping = getShipping(subtotal);

        checkoutEmpty.hidden = !isEmpty;
        checkoutContent.hidden = isEmpty;
        checkoutItemList.replaceChildren();
        updateCartBadge();

        if (isEmpty) {
            return;
        }

        cartItems.forEach(function (item) {
            checkoutItemList.appendChild(createOrderItem(item));
        });

        checkoutSubtotal.textContent = formatPrice(subtotal);
        checkoutShipping.textContent = formatPrice(shipping);
        checkoutTotal.textContent = formatPrice(subtotal + shipping);
    }

    function showFormError(message) {
        checkoutError.textContent = message;
        checkoutError.hidden = false;
    }

    function clearFormError() {
        checkoutError.textContent = '';
        checkoutError.hidden = true;
    }

    function getTrimmedValue(input) {
        return input ? input.value.trim() : '';
    }

    function validateOrderForm() {
        const customerName = getTrimmedValue(customerNameInput);
        const customerPhone = getTrimmedValue(customerPhoneInput);
        const address = getTrimmedValue(addressInput);

        if (customerName === '') {
            showFormError('주문자명을 입력해 주세요.');
            customerNameInput.focus();
            return false;
        }

        if (customerPhone === '') {
            showFormError('연락처를 입력해 주세요.');
            customerPhoneInput.focus();
            return false;
        }

        if (address === '') {
            showFormError('주소를 입력해 주세요.');
            addressInput.focus();
            return false;
        }

        clearFormError();
        return true;
    }

    function saveLastOrder() {
        const subtotal = getSubtotal();
        const shipping = getShipping(subtotal);
        const address = getTrimmedValue(addressInput);
        const detailAddress = getTrimmedValue(detailAddressInput);
        const fullAddress = detailAddress ? address + ' ' + detailAddress : address;
        const orderData = {
            customerName: getTrimmedValue(customerNameInput),
            phone: getTrimmedValue(customerPhoneInput),
            zipcode: getTrimmedValue(zipcodeInput),
            address: fullAddress,
            requestMemo: getTrimmedValue(requestMemoInput),
            items: cartItems,
            subtotal: subtotal,
            shipping: shipping,
            total: subtotal + shipping,
            orderedAt: new Date().toISOString()
        };

        try {
            localStorage.setItem(LAST_ORDER_STORAGE_KEY, JSON.stringify(orderData));
            return true;
        } catch (error) {
            showFormError('주문 정보를 저장하지 못했습니다. 브라우저 저장 공간을 확인해 주세요.');
            return false;
        }
    }

    checkoutForm.addEventListener('submit', function (event) {
        event.preventDefault();

        if (cartItems.length === 0) {
            showFormError('주문할 상품이 없습니다.');
            return;
        }

        if (!validateOrderForm()) {
            return;
        }

        if (!saveLastOrder()) {
            return;
        }

        window.location.href = '/order/complete.jsp';
    });

    renderCheckout();
});
