
document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const CART_STORAGE_KEY = 'shopmallCart';


    const contextPath = document.body ? (document.body.dataset.contextPath || '') : '';
    const wishlistBadge = document.querySelector('#wishlistBadge');
    const cartBadge = document.querySelector('#cartBadge');
    const likeButtons = Array.from(document.querySelectorAll('.like-btn'));
    const addCartButtons = Array.from(document.querySelectorAll('.add-cart-btn'));
    const allProductCards = Array.from(document.querySelectorAll('.product-card'));
    const wishlistEmptyMessage = document.querySelector('#wishlistEmptyMessage');

    let wishlistIds = readWishlistIds();

    function buildContextUrl(path) {
        return contextPath + path;
    }

    function normalizeText(value) {
        return (value || '').trim().toLowerCase();
    }

    function readWishlistIds() {
        try {
            const storedValue = localStorage.getItem(WISHLIST_STORAGE_KEY);
            if (!storedValue) {
                return [];
            }

            const parsedValue = JSON.parse(storedValue);
            if (!Array.isArray(parsedValue)) {
                return [];
            }

            const validProductIds = parsedValue.filter(function (productId) {
                return typeof productId === 'string' && productId.trim().length > 0;
            }).map(function (productId) {
                return productId.trim();
            });

            return Array.from(new Set(validProductIds));
        } catch (error) {
            return [];
        }
    }

    function saveWishlistIds() {
        try {
            localStorage.setItem(WISHLIST_STORAGE_KEY, JSON.stringify(wishlistIds));
        } catch (error) {
            return;
        }
    }

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

    function saveCartItems(cartItems) {
        try {
            localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(cartItems));
        } catch (error) {
            return;
        }
    }

    function updateCartCount() {
        if (!cartBadge) {
            return;
        }

        const totalQuantity = readCartItems().reduce(function (total, item) {
            return total + item.quantity;
        }, 0);

        cartBadge.textContent = String(totalQuantity);
        cartBadge.hidden = totalQuantity === 0;
    }

    function updateWishlistCount() {
        if (!wishlistBadge) {
            return;
        }

        const wishlistCount = wishlistIds.length;
        wishlistBadge.textContent = String(wishlistCount);
        wishlistBadge.hidden = wishlistCount === 0;
    }

    function getSafeNumber(value) {
        const number = Number(value);
        return Number.isFinite(number) ? number : 0;
    }

    function getProductDataFromCard(card) {
        const price = Number(card.dataset.price);

        return {
            id: String(card.dataset.id || ''),
            name: String(card.dataset.name || ''),
            brand: String(card.dataset.brand || ''),
            price: Number.isFinite(price) ? Math.max(0, price) : 0,
            image: String(card.dataset.image || ''),
            quantity: 1
        };
    }

    function getCartToast() {
        let toast = document.querySelector('#cartToast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'cartToast';
            toast.className = 'cart-toast';
            toast.setAttribute('role', 'status');
            toast.setAttribute('aria-live', 'polite');
            toast.hidden = true;
            document.body.appendChild(toast);
        }

        return toast;
    }

    function showCartMessage(message) {
        const toast = getCartToast();
        window.clearTimeout(showCartMessage.timerId);
        toast.textContent = message;
        toast.hidden = false;

        showCartMessage.timerId = window.setTimeout(function () {
            toast.hidden = true;
        }, 1800);
    }

    function addProductToCart(button) {
        const card = button.closest('.product-card');
        if (!card || !card.dataset.id) {
            return;
        }

        const product = getProductDataFromCard(card);
        const cartItems = readCartItems();
        const existingItem = cartItems.find(function (item) {
            return item.id === product.id;
        });

        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cartItems.push(product);
        }

        saveCartItems(cartItems);
        updateCartCount();
        showCartMessage(product.name + ' 상품을 장바구니에 담았습니다.');
    }

    function updateWishlistButton(button, isLiked) {
        button.textContent = isLiked ? '♥' : '♡';
        button.classList.toggle('active', isLiked);
        button.classList.toggle('wish-page-active', isLiked && Boolean(button.closest('.wishlist-product-card')));
        button.setAttribute('aria-pressed', String(isLiked));
        button.setAttribute('aria-label', isLiked ? '찜 해제' : '찜');
    }

    function restoreWishlistState() {
        likeButtons.forEach(function (button) {
            const card = button.closest('.product-card');
            const productId = card ? card.dataset.id : '';
            updateWishlistButton(button, wishlistIds.includes(productId));
        });

        updateWishlistCount();
    }

    function renderWishlistPage() {
        const wishlistCards = Array.from(document.querySelectorAll('.wishlist-product-card'));
        if (wishlistCards.length === 0) {
            return;
        }

        let visibleCount = 0;
        wishlistCards.forEach(function (card) {
            const productId = card.dataset.id || '';
            const isLiked = wishlistIds.includes(productId);
            card.hidden = !isLiked;

            if (isLiked) {
                visibleCount += 1;
            }
        });

        if (wishlistEmptyMessage) {
            wishlistEmptyMessage.hidden = visibleCount > 0;
        }
    }

    /* 20252358최윤서
    함수 내부 수정
    하트를 클릭했을때 wishlist 주소(서블릿)으로 상품 정보와 찜 상태를 전송하는 코드 추가
    */
    function syncWishlistToServer(product, liked) {
        // [Action 1] 서버 세션에서 상품 추가/제거 요청
        const body = new URLSearchParams();
        body.set('productId', product.id);
        body.set('productName', product.name);
        body.set('liked', String(liked));

        fetch(buildContextUrl('/wishlist'), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: body.toString()
        }).catch(function (error) {
            console.error(error);
        });
    }

    function toggleWishlist(button) {
        const card = button.closest('.product-card');
        if (!card || !card.dataset.id) {
            return;
        }

        const product = getProductDataFromCard(card);
        const isLiked = wishlistIds.includes(product.id);

        if (isLiked) {
            wishlistIds = wishlistIds.filter(function (savedProductId) {
                return savedProductId !== product.id;
            });
        } else {
            wishlistIds = Array.from(new Set(wishlistIds.concat(product.id)));
        }

        // [Action 2] 브라우저 LocalStorage에서도 추가/삭제 (메인 페이지 하트 동기화용)
        saveWishlistIds();
        updateWishlistButton(button, !isLiked);
        // [Action 3] 헤더 찜 배지 숫자 동기화 변경
        updateWishlistCount();
        // [Action 4] 찜 목록 페이지에서는 해당 상품 카드를 즉시 표시/숨김 처리
        // [Action 5] 모든 찜 상품이 사라지면 '찜한 상품이 없습니다' 안내 표시
        renderWishlistPage();
        syncWishlistToServer(product, !isLiked);
    }

    function initCommonShoppingFeatures() {
        likeButtons.forEach(function (button) {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();
                toggleWishlist(button);
            });
        });

        addCartButtons.forEach(function (button) {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();
                addProductToCart(button);
            });
        });

        restoreWishlistState();
        renderWishlistPage();
        updateCartCount();
    }

    function initProductSearchFeatures() {
        const searchInput = document.querySelector('#search');
        const searchButton = document.querySelector('.search-box button');
        const sortSelect = document.querySelector('#productSort');
        const emptyMessage = document.querySelector('#productEmptyMessage');
        const navLinks = Array.from(document.querySelectorAll('nav a'));
        const categoryItems = Array.from(document.querySelectorAll('.category-grid .cat-item'));
        const productGrids = Array.from(document.querySelectorAll('.product-grid'));
        const productCards = allProductCards.filter(function (card) {
            return !card.classList.contains('wishlist-product-card');
        });

        if (!searchInput || !sortSelect || productCards.length === 0) {
            return;
        }

        const categoryMap = {
            '전체': '전체',
            '여성의류': '의류',
            '남성의류': '의류',
            '여성패션': '의류',
            '남성패션': '의류',
            '신발': '신발',
            '가방': '가방',
            '액세서리': '액세서리',
            '뷰티': '뷰티',
            '디지털': '디지털',
            '스포츠': '스포츠'
        };

        let selectedCategory = '전체';
        let selectedNavLabel = '전체';

        productCards.forEach(function (card, index) {
            card.dataset.originalIndex = String(index);
        });

        function getCategoryValue(label) {
            const trimmedLabel = (label || '').trim();
            return categoryMap[trimmedLabel] || trimmedLabel;
        }

        function findNavLabelByCategory(category) {
            if (category === '전체') {
                return '전체';
            }

            const matchedLink = navLinks.find(function (link) {
                return getCategoryValue(link.textContent) === category;
            });

            return matchedLink ? matchedLink.textContent.trim() : '';
        }

        function updateActiveNav() {
            navLinks.forEach(function (link) {
                const item = link.closest('li');
                if (!item) {
                    return;
                }

                item.classList.toggle('active', link.textContent.trim() === selectedNavLabel);
            });
        }

        function updateActiveCategoryIcons() {
            categoryItems.forEach(function (item) {
                const label = item.dataset.categoryName || item.textContent;
                item.classList.toggle(
                    'active',
                    selectedCategory !== '전체' && getCategoryValue(label) === selectedCategory
                );
            });
        }

        function isMatchedProduct(card, searchKeyword) {
            const name = normalizeText(card.dataset.name);
            const brand = normalizeText(card.dataset.brand);
            const category = card.dataset.category || '';
            const matchedKeyword = searchKeyword === '' || name.includes(searchKeyword) || brand.includes(searchKeyword);
            const matchedCategory = selectedCategory === '전체' || category === selectedCategory;

            return matchedKeyword && matchedCategory;
        }

        function compareProducts(firstCard, secondCard, sortValue) {
            const firstPrice = getSafeNumber(firstCard.dataset.price);
            const secondPrice = getSafeNumber(secondCard.dataset.price);
            const firstRate = getSafeNumber(firstCard.dataset.rate);
            const secondRate = getSafeNumber(secondCard.dataset.rate);
            const firstIndex = getSafeNumber(firstCard.dataset.originalIndex);
            const secondIndex = getSafeNumber(secondCard.dataset.originalIndex);

            if (sortValue === 'price-low') {
                return firstPrice - secondPrice || firstIndex - secondIndex;
            }
            if (sortValue === 'price-high') {
                return secondPrice - firstPrice || firstIndex - secondIndex;
            }
            if (sortValue === 'rate-high') {
                return secondRate - firstRate || firstIndex - secondIndex;
            }

            return firstIndex - secondIndex;
        }

        function sortProductCards(sortValue) {
            productGrids.forEach(function (grid) {
                const cardsInGrid = Array.from(grid.querySelectorAll('.product-card'))
                    .filter(function (card) {
                        return !card.classList.contains('wishlist-product-card');
                    });

                cardsInGrid
                    .sort(function (firstCard, secondCard) {
                        return compareProducts(firstCard, secondCard, sortValue);
                    })
                    .forEach(function (card) {
                        grid.appendChild(card);
                    });
            });
        }

        function applyProductView() {
            const searchKeyword = normalizeText(searchInput.value);
            const sortValue = sortSelect.value;
            let visibleCount = 0;

            sortProductCards(sortValue);

            productCards.forEach(function (card) {
                const matched = isMatchedProduct(card, searchKeyword);
                card.hidden = !matched;

                if (matched) {
                    visibleCount += 1;
                }
            });

            updateActiveNav();
            updateActiveCategoryIcons();

            if (emptyMessage) {
                emptyMessage.hidden = visibleCount > 0;
                emptyMessage.textContent = visibleCount > 0 ? '' : '검색 결과가 없습니다';
            }
        }

        navLinks.forEach(function (link) {
            link.addEventListener('click', function (event) {
                event.preventDefault();

                selectedNavLabel = link.textContent.trim();
                selectedCategory = getCategoryValue(selectedNavLabel);
                applyProductView();
            });
        });

        categoryItems.forEach(function (item) {
            function selectCategoryFromIcon() {
                const label = item.dataset.categoryName || item.textContent;
                selectedCategory = getCategoryValue(label);
                selectedNavLabel = findNavLabelByCategory(selectedCategory);
                applyProductView();
            }

            item.addEventListener('click', selectCategoryFromIcon);
            item.addEventListener('keydown', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    selectCategoryFromIcon();
                }
            });
        });

        searchInput.addEventListener('input', applyProductView);
        searchInput.addEventListener('keydown', function (event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                applyProductView();
            }
        });

        if (searchButton) {
            searchButton.addEventListener('click', function (event) {
                event.preventDefault();
                applyProductView();
                searchInput.focus();
            });
        }

        sortSelect.addEventListener('change', applyProductView);
        applyProductView();
    }

    initCommonShoppingFeatures();
    initProductSearchFeatures();
});
