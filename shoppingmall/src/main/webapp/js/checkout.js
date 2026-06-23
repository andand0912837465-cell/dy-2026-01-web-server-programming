/*
 * 20252361 김지연 - 주문서 필수값 검증과 장바구니 상품 제출값 정리
 */
document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const CART_STORAGE_KEY = 'shopmallCart';
    const FREE_SHIPPING_THRESHOLD = 50000;
    const DEFAULT_SHIPPING_FEE = 3000;

    const wishlistBadge = document.querySelector('#wishlistBadge');
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
    const emailInput = document.querySelector('#email');
    const zipcodeInput = document.querySelector('#zipcode');
    const addressInput = document.querySelector('#address');
    const detailAddressInput = document.querySelector('#detailAddress');
    const requestMemoInput = document.querySelector('#requestMemo');
    const privacyAgreementInput = document.querySelector('#privacyAgreement');

    if (
        !checkoutEmpty ||
        !checkoutContent ||
        !checkoutForm ||
        !checkoutError ||
        !checkoutItemList ||
        !checkoutSubtotal ||
        !checkoutShipping ||
        !checkoutTotal ||
        !customerNameInput ||
        !customerPhoneInput ||
        !emailInput ||
        !zipcodeInput ||
        !addressInput ||
        !detailAddressInput ||
        !privacyAgreementInput
    ) {
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

            const normalizedItems = [];
            parsedValue.forEach(function (item) {
                if (!item || typeof item.id !== 'string' || item.id.trim().length === 0) {
                    return;
                }

                const productId = item.id.trim();
                const price = Number(item.price);
                const quantity = Number(item.quantity);
                const cartItem = {
                    id: productId,
                    name: String(item.name || ''),
                    brand: String(item.brand || ''),
                    price: Number.isFinite(price) ? Math.max(0, price) : 0,
                    image: String(item.image || ''),
                    quantity: Number.isFinite(quantity) ? Math.max(1, Math.floor(quantity)) : 1
                };
                const existingItem = normalizedItems.find(function (savedItem) {
                    return savedItem.id === productId;
                });

                if (existingItem) {
                    existingItem.quantity += cartItem.quantity;
                } else {
                    normalizedItems.push(cartItem);
                }
            });

            return normalizedItems;
        } catch (error) {
            return [];
        }
    }

    function formatPrice(price) {
        const numericPrice = Number(price);
        const safePrice = Number.isFinite(numericPrice) ? numericPrice : 0;

        return safePrice.toLocaleString('ko-KR') + '원';
    }

    function getSubtotal() {
        return cartItems.reduce(function (total, item) {
            return total + item.price * item.quantity;
        }, 0);
    }

    function getShipping(subtotal) {
        if (subtotal <= 0) {
            return 0;
        }

        return subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : DEFAULT_SHIPPING_FEE;
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

    function showFormError(message, target) {
        checkoutError.textContent = message;
        checkoutError.hidden = false;

        if (target && typeof target.focus === 'function') {
            target.focus();
        }
    }

    function clearFormError() {
        checkoutError.textContent = '';
        checkoutError.hidden = true;
    }

    function getTrimmedValue(input) {
        return input ? input.value.trim() : '';
    }

    function normalizePhone(value) {
        const digits = value.replace(/[^0-9]/g, '');
        if (digits.length !== 11) {
            return '';
        }

        return digits.slice(0, 3) + '-' + digits.slice(3, 7) + '-' + digits.slice(7, 11);
    }

    function getSelectedPaymentInput() {
        return checkoutForm.querySelector('input[name="paymentMethod"]:checked');
    }

    function validateOrderForm() {
        const customerName = getTrimmedValue(customerNameInput);
        const customerPhone = getTrimmedValue(customerPhoneInput);
        const normalizedPhone = normalizePhone(customerPhone);
        const email = getTrimmedValue(emailInput);
        const zipcode = getTrimmedValue(zipcodeInput);
        const address = getTrimmedValue(addressInput);
        const detailAddress = getTrimmedValue(detailAddressInput);
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const selectedPayment = getSelectedPaymentInput();

        if (cartItems.length === 0) {
            showFormError('주문할 상품이 없습니다.', checkoutForm);
            return false;
        }
        if (customerName === '') {
            showFormError('주문자명을 입력해 주세요.', customerNameInput);
            return false;
        }
        if (normalizedPhone === '') {
            showFormError('연락처는 010-1234-5678 또는 01012345678 형식으로 입력해 주세요.', customerPhoneInput);
            return false;
        }
        if (!emailPattern.test(email)) {
            showFormError('올바른 이메일 주소를 입력해 주세요.', emailInput);
            return false;
        }
        if (zipcode === '') {
            showFormError('우편번호를 입력해 주세요.', zipcodeInput);
            return false;
        }
        if (address === '') {
            showFormError('기본 주소를 입력해 주세요.', addressInput);
            return false;
        }
        if (detailAddress === '') {
            showFormError('상세 주소를 입력해 주세요.', detailAddressInput);
            return false;
        }
        if (!selectedPayment) {
            showFormError('결제 방법을 선택해 주세요.', checkoutForm.querySelector('input[name="paymentMethod"]'));
            return false;
        }
        if (!privacyAgreementInput.checked) {
            showFormError('개인정보 수집 및 이용에 동의해 주세요.', privacyAgreementInput);
            return false;
        }

        customerPhoneInput.value = normalizedPhone;
        clearFormError();
        return true;
    }

    function appendHiddenInput(name, value) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        input.className = 'cart-hidden-input';
        checkoutForm.appendChild(input);
    }

    function appendCartInputs() {
        checkoutForm.querySelectorAll('.cart-hidden-input').forEach(function (input) {
            input.remove();
        });

        cartItems.forEach(function (item) {
            appendHiddenInput('productId', item.id);
            appendHiddenInput('quantity', String(item.quantity));
        });
    }

    checkoutForm.addEventListener('submit', function (event) {
        if (!validateOrderForm()) {
            event.preventDefault();
            return;
        }

        appendCartInputs();
    });

    updateWishlistBadge();
    renderCheckout();
});
