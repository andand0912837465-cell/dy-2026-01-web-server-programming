-- 주문 내역 테이블 생성

-- 기존 잘못된 테이블이 있다면 삭제
DROP TABLE IF EXISTS ORDERS CASCADE;

CREATE TABLE ORDERS
(
    ORDER_ID     BIGINT AUTO_INCREMENT PRIMARY KEY, -- 주문 고유 번호 (자동으로 1, 2, 3... 증가)
    MEMBER_ID    CHARACTER VARYING(50) NOT NULL,    -- 주문한 회원 ID ('satcop'이 들어갈 자리)
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE        INT NOT NULL,
    QUANTITY     INT NOT NULL,
    STATUS       VARCHAR(20) NOT NULL,
    ORDER_DATE   TIMESTAMP,

    -- ORDERS의 MEMBER_ID가 MEMBER 테이블의 ID를 참조하도록 외래키 설정
    CONSTRAINT FK_ORDER_MEMBER
        FOREIGN KEY (MEMBER_ID)
            REFERENCES MEMBER(ID)
);

-- 첫 번째 주문 (게이밍 마우스)
INSERT INTO ORDERS
(MEMBER_ID, PRODUCT_NAME, PRICE, QUANTITY, STATUS, ORDER_DATE)
VALUES
    ('satcop', '게이밍 마우스', 50000, 1, '결제완료', NOW());

-- 두 번째 주문 (키보드) - 이제 같은 'satcop' 유저가 주문해도 에러가 나지 않습니다!
INSERT INTO ORDERS
(MEMBER_ID, PRODUCT_NAME, PRICE, QUANTITY, STATUS, ORDER_DATE)
VALUES
    ('satcop', '키보드', 120000, 2, '배송중', NOW());


SELECT
    O.ORDER_ID,
    M.NAME AS 회원이름,
    O.MEMBER_ID AS 회원ID,
    O.PRODUCT_NAME AS 상품명,
    O.PRICE AS 가격,
    O.STATUS AS 배송상태
FROM ORDERS O
         JOIN MEMBER M ON O.MEMBER_ID = M.ID;