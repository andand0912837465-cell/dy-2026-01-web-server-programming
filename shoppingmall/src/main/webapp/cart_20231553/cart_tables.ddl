-- ============================================================================
--  학번 : 20231553
--  이름 : 김성민
--  파일 : cart_tables.ddl
--  기능 : 'DB 기반 장바구니' 기능용 테이블(CART, CART_ITEM) 생성 스크립트.
--         ※ CartRepository 가 최초 실행 시 CREATE TABLE IF NOT EXISTS 로 자동 생성하므로
--           본 스크립트를 수동 실행하지 않아도 동작하지만, 테이블 구조 참고/수동 생성을 위해 함께 제공한다.
-- ============================================================================

-- 장바구니 (회원당 활성 1개)
CREATE TABLE IF NOT EXISTS CART (
    CART_ID    BIGINT AUTO_INCREMENT PRIMARY KEY,
    MEMBER_ID  VARCHAR(50) NOT NULL,            -- MEMBER.ID 참조(로그인 ID)
    REG_DATE   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MOD_DATE   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 장바구니에 담긴 상품
CREATE TABLE IF NOT EXISTS CART_ITEM (
    CART_ITEM_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    CART_ID      BIGINT       NOT NULL,         -- CART.CART_ID 참조
    PRODUCT_ID   VARCHAR(50)  NOT NULL,         -- 상품 식별자(예: best-0)
    PRODUCT_NAME VARCHAR(200) NOT NULL,
    BRAND        VARCHAR(100),
    PRICE        INT          NOT NULL,
    IMAGE_URL    VARCHAR(500),
    QUANTITY     INT          NOT NULL DEFAULT 1,
    REG_DATE     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
