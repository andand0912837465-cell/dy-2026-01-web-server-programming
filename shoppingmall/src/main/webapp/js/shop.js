document.addEventListener('DOMContentLoaded', function () {
    const WISHLIST_STORAGE_KEY = 'shopmallWishlist';
    const searchInput = document.querySelector('#search');
    const searchButton = document.querySelector('.search-box button');
    const sortSelect = document.querySelector('#productSort');
    const emptyMessage = document.querySelector('#productEmptyMessage');
    const wishlistBadge = document.querySelector('#wishlistBadge');
    const navLinks = Array.from(document.querySelectorAll('nav a'));
    const categoryItems = Array.from(document.querySelectorAll('.category-grid .cat-item'));
    const productGrids = Array.from(document.querySelectorAll('.product-grid'));
    const productCards = Array.from(document.querySelectorAll('.product-card'));
    const likeButtons = Array.from(document.querySelectorAll('.like-btn'));

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

    function toggleWishlist(button) {
        const card = button.closest('.product-card');

        if (!card || !card.dataset.id) {
            return;
        }

        const productId = card.dataset.id;
        const isLiked = wishlistIds.includes(productId);

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
        const firstPrice = Number(firstCard.dataset.price || 0);
        const secondPrice = Number(secondCard.dataset.price || 0);
        const firstRate = Number(firstCard.dataset.rate || 0);
        const secondRate = Number(secondCard.dataset.rate || 0);
        const firstIndex = Number(firstCard.dataset.originalIndex || 0);
        const secondIndex = Number(secondCard.dataset.originalIndex || 0);

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
    likeButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            event.stopPropagation();
            toggleWishlist(button);
        });
    });

    restoreWishlistState();
    applyProductView();
});
