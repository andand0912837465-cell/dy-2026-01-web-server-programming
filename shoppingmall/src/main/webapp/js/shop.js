document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const CART_STORAGE_KEY = 'shopmallCart';
    const searchInput = document.querySelector('#search');
    const searchButton = document.querySelector('.search-box button');
    const sortSelect = document.querySelector('#productSort');
    const emptyMessage = document.querySelector('#productEmptyMessage');
    const wishlistBadge = document.querySelector('#wishlistBadge');
    const cartBadge = document.querySelector('#cartBadge');
    const navLinks = Array.from(document.querySelectorAll('nav a'));
    const categoryItems = Array.from(document.querySelectorAll('.category-grid .cat-item'));
    const productGrids = Array.from(document.querySelectorAll('.product-grid'));
    const productCards = Array.from(document.querySelectorAll('.product-card'));
    const likeButtons = Array.from(document.querySelectorAll('.like-btn'));
    const addCartButtons = Array.from(document.querySelectorAll('.add-cart-btn'));

   /* if (!searchInput || !sortSelect || productCards.length === 0) {
        return;
    } */

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
    let wishlistIds = readWishlistIds();

    productCards.forEach(function (card, index) {
        card.dataset.originalIndex = String(index);
    });

    function normalizeText(value) {
        return (value || '').trim().toLowerCase();
    }

    function getCategoryValue(label) {
        const trimmedLabel = (label || '').trim();
        return categoryMap[trimmedLabel] || trimmedLabel;
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
                return typeof productId === 'string' && productId.length > 0;
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

    function getProductDataFromCard(card) {
        const price = Number(card.dataset.price);

        return {
            id: card.dataset.id,
            name: card.dataset.name,
            brand: card.dataset.brand,
            price: Number.isFinite(price) ? Math.max(0, price) : 0,
            image: card.dataset.image,
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
        button.setAttribute('aria-pressed', String(isLiked));
        button.setAttribute('aria-label', isLiked ? '찜 해제' : '찜');
    }

    function updateWishlistCount() {
        if (!wishlistBadge) {
            return;
        }

        const wishlistCount = wishlistIds.length;
        wishlistBadge.textContent = String(wishlistCount);
        wishlistBadge.hidden = wishlistCount === 0;
    }

    function restoreWishlistState() {
        const productIdSet = new Set(productCards.map(function (card) {
            return card.dataset.id;
        }));

        wishlistIds = wishlistIds.filter(function (productId) {
            return productIdSet.has(productId);
        });

        likeButtons.forEach(function (button) {
            const card = button.closest('.product-card');
            const productId = card ? card.dataset.id : '';
            updateWishlistButton(button, wishlistIds.includes(productId));
        });

        saveWishlistIds();
        updateWishlistCount();
    }

    /* 20252358최윤서
    함수 내부 수정
    하트를 클릭했을때 wishlist 주소(서블릿)으로 상품 정보와 찜 상태를 전송하는 코드 추가
    */
    function toggleWishlist(button) {
        console.log("toggle 실행");

        const card = button.closest('.product-card');

        if (!card || !card.dataset.id) {
            return;
        }

        const productId = card.dataset.id;

        const isLiked = wishlistIds.includes(productId);

        console.log("wishlistIds =", wishlistIds);
        console.log("productId =", productId);
        console.log("isLiked =", isLiked);

        if (isLiked) {
            wishlistIds = wishlistIds.filter(function (savedProductId) {
                return savedProductId !== productId;
            });
        } else {
            wishlistIds.push(productId);
        }

        saveWishlistIds();
        updateWishlistButton(button, !isLiked);
        updateWishlistCount();

        const productName = card.dataset.name;

        console.log("shop.js 수정본 실행");

        console.log(
            "body = ",
            "productName=" + encodeURIComponent(productName)
            + "&liked=" + (!isLiked)
        );

        fetch("wishlist", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body:
                "productName=" + encodeURIComponent(productName)
                + "&liked=" + (!isLiked)
        })
            .then(response => response.text())
            .then(data => {

                console.log(data);
                //찜 목록 페이지일 경우, 찜 해제 시 해당 상품 카드를 화면에서 즉시 삭제
                if (window.location.pathname.includes("wishlist.jsp")) {
                    if (isLiked) { // 기존에 찜 상태였다가 해제된 경우
                        card.remove(); // 화면에서 상품 카드 제거
                // 만약 모든 카드가 지워졌다면 '찜한 상품이 없습니다' 안내를 위해 새로고침
                        const remainingCards = document.querySelectorAll('.product-grid .product-card');
                        if (remainingCards.length === 0) {
                            location.reload();
                        }
                    }
                }

            })
            .catch(error => console.error(error));
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

    function getSafeNumber(value) {
        const number = Number(value);

        return Number.isFinite(number) ? number : 0;
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
            const cardsInGrid = Array.from(grid.querySelectorAll('.product-card'));
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

    if(searchInput){

        searchInput.addEventListener('input', applyProductView);

    }
    if(searchInput){

        searchInput.addEventListener('keydown', function (event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                applyProductView();
            }
        });

    }



    if (searchButton) {
        searchButton.addEventListener('click', function (event) {
            event.preventDefault();
            applyProductView();
            searchInput.focus();
        });
    }

    sortSelect.addEventListener('change', applyProductView);
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
    updateCartCount();
    applyProductView();
});