-- 20251266 주혜림
-- PRODUCT_DETAIL, PRODUCT_REVIEW 테이블 생성
-- detail에 예시 상품 하나 추가


CREATE TABLE IF NOT EXISTS PRODUCT_DETAIL (
    PRODUCT_ID VARCHAR(30) PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    BRAND VARCHAR(100) NOT NULL,
    CATEGORY VARCHAR(50),
    ORIGINAL_PRICE INT,
    SALE_PRICE INT,
    DISCOUNT_RATE INT,
    BASIC_RATE DOUBLE,
    OLD_REVIEW_COUNT INT,
    IMAGE_URL VARCHAR(300),
    BADGE VARCHAR(30),
    DETAIL_TEXT VARCHAR(2000),
    DELIVERY_TEXT VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS PRODUCT_REVIEW (
    REVIEW_NO BIGINT AUTO_INCREMENT PRIMARY KEY,
    PRODUCT_ID VARCHAR(30) NOT NULL,
    WRITER VARCHAR(50) NOT NULL,
    SCORE INT NOT NULL,
    CONTENT VARCHAR(1000) NOT NULL,
    REG_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PRODUCT_DETAIL (
                                PRODUCT_ID VARCHAR(50) PRIMARY KEY,
                                NAME VARCHAR(100),
                                BRAND VARCHAR(50),
                                CATEGORY VARCHAR(50),
    ...
);

CREATE TABLE PRODUCT_REVIEW (
                                REVIEW_NO BIGINT AUTO_INCREMENT,
                                PRODUCT_ID VARCHAR(50),
                                WRITER VARCHAR(50),
                                SCORE INT,
                                CONTENT VARCHAR(1000),
                                REG_DATE TIMESTAMP
);

INSERT INTO PRODUCT_DETAIL
(
    PRODUCT_ID,
    NAME,
    BRAND,
    CATEGORY,
    ORIGINAL_PRICE,
    SALE_PRICE,
    DISCOUNT_RATE,
    BASIC_RATE,
    OLD_REVIEW_COUNT,
    IMAGE_URL,
    BADGE,
    DETAIL_TEXT,
    DELIVERY_TEXT
)
VALUES
    (
        'best-0',
        '테스트 상품',
        'SHOPMALL',
        '식품',
        10000,
        8000,
        20,
        4.5,
        0,
        '',
        'BEST',
        '상세 설명 테스트',
        '무료배송'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-0',
        '오버사이즈 코튼 셔츠',
        'BASIC HOUSE',
        '의류',
        59000,
        39000,
        33,
        4.8,
        1245,
        'https://picsum.photos/seed/shirt01/600/600',
        'BEST 1',
        '탄탄한 코튼 소재로 만든 데일리 셔츠입니다.
낙낙한 핏이라 단독으로 입어도 좋고 가볍게 걸쳐도 좋습니다.',
        '평균 배송일은 2~3일입니다. 5만원 이상 구매하면 무료배송입니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-1',
        '슬림핏 데님 팬츠',
        'DENIM CO.',
        '의류',
        89000,
        62300,
        30,
        4.6,
        892,
        'https://picsum.photos/seed/denim02/600/600',
        'BEST 2',
        '다리 라인이 깔끔하게 보이는 슬림핏 데님 팬츠입니다.
스판이 조금 들어가 활동하기 편합니다.',
        '오후 2시 이전 주문은 당일 출고를 목표로 합니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-2',
        '미니멀 크로스백',
        'MUJI STYLE',
        '가방',
        120000,
        84000,
        30,
        4.9,
        2134,
        'https://picsum.photos/seed/bag03/600/600',
        'BEST 3',
        '작지만 지갑, 휴대폰, 이어폰을 넣기 좋은 크로스백입니다.
깔끔한 디자인이라 여러 옷에 잘 어울립니다.',
        '상품 검수 후 출고되며 단순 변심 교환은 7일 안에 가능합니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-3',
        '러닝 스니커즈',
        'ATHLEISURE',
        '신발',
        159000,
        119000,
        25,
        4.7,
        567,
        'https://picsum.photos/seed/shoes04/600/600',
        'SALE',
        '가벼운 착화감의 러닝 스니커즈입니다.
운동할 때나 평소 산책할 때 신기 좋습니다.',
        '신발 박스 훼손 시 교환이 어려울 수 있습니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-4',
        '실크 블라우스',
        'ELEGANT',
        '의류',
        98000,
        68600,
        30,
        4.5,
        423,
        'https://picsum.photos/seed/blouse05/600/600',
        'SALE',
        '은은한 광택이 있는 블라우스입니다.
격식 있는 자리나 출근룩으로 입기 좋습니다.',
        '얇은 소재라 세탁망 사용을 권장합니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-5',
        '가죽 토트백',
        'LEATHER LAB',
        '가방',
        280000,
        196000,
        30,
        4.9,
        1876,
        'https://picsum.photos/seed/tote06/600/600',
        'SALE',
        '넉넉한 수납 공간이 있는 가죽 토트백입니다.
노트북과 책을 넣고 다니기 좋습니다.',
        '가죽 상품은 물과 직사광선을 피해 보관해 주세요.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-6',
        '캐주얼 자켓',
        'URBAN STREET',
        '의류',
        145000,
        101500,
        30,
        4.4,
        312,
        'https://picsum.photos/seed/jacket07/600/600',
        'SALE',
        '간절기에 입기 좋은 캐주얼 자켓입니다.
안감이 있어 저녁에도 가볍게 걸치기 좋습니다.',
        '교환 및 반품 시 구성품을 모두 보내주세요.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'best-7',
        '실버 목걸이',
        'AURUM',
        '액세서리',
        75000,
        56250,
        25,
        4.8,
        945,
        'https://picsum.photos/seed/necklace08/600/600',
        'SALE',
        '데일리로 착용하기 좋은 실버 목걸이입니다.
작은 포인트가 있어 심플한 옷에 잘 어울립니다.',
        '액세서리는 착용 흔적이 있으면 반품이 제한될 수 있습니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'new-0',
        '린넨 원피스',
        'SUMMER LINE',
        '의류',
        78000,
        78000,
        0,
        0.0,
        0,
        'https://picsum.photos/seed/dress11/600/600',
        'NEW',
        '시원한 린넨 원단의 여름 원피스입니다.
허리 라인이 편해서 오래 입어도 부담이 적습니다.',
        '린넨 특성상 작은 구김이 있을 수 있습니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'new-1',
        '체크 셔츠',
        'CASUAL DAY',
        '의류',
        56000,
        56000,
        0,
        0.0,
        0,
        'https://picsum.photos/seed/check12/600/600',
        'NEW',
        '가볍게 입기 좋은 체크 셔츠입니다.
티셔츠 위에 걸치거나 단독으로 입을 수 있습니다.',
        '첫 세탁은 단독 세탁을 권장합니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'new-2',
        '캔버스 스니커즈',
        'DAILY WALK',
        '신발',
        89000,
        89000,
        0,
        0.0,
        0,
        'https://picsum.photos/seed/canvas13/600/600',
        'HOT',
        '매일 신기 좋은 캔버스 스니커즈입니다.
굽이 높지 않아 오래 걸어도 편합니다.',
        '사이즈 교환은 실내 착화 상태에서만 가능합니다.'
    );

INSERT INTO
    PRODUCT_DETAIL
VALUES (
        'new-3',
        '버킷햇',
        'STREET MODE',
        '액세서리',
        35000,
        35000,
        0,
        0.0,
        0,
        'https://picsum.photos/seed/hat14/600/600',
        'NEW',
        '햇빛을 가리기 좋은 데일리 버킷햇입니다.
접어서 가방에 넣기 편한 소재입니다.',
        '형태 유지를 위해 손세탁을 권장합니다.'
    );