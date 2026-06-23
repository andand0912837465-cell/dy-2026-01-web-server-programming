-- auto-generated definition
CREATE TABLE PRODUCT (
    ID         UUID NOT NULL PRIMARY KEY,
    NAME       CHARACTER VARYING(100) NOT NULL,
    PRICE      INTEGER NOT NULL,
    SALE_PRICE INTEGER,
    DATA       CHARACTER VARYING(1000)  -- JSON 문자열 (예: {"brand":"...","image":"..."})
);

INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('1cc19d21-1590-4f7c-ade5-94b5a325fddc', '오버사이즈 코튼 셔츠', 59000, 39000, '{"brand":"BASIC HOUSE","image":"shirt01"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('67c78ae9-0734-4af5-89e3-2247d55e8ff2', '슬림핏 데님 팬츠', 89000, 62300, '{"brand":"DENIM CO.","image":"denim02"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('1fbcd71d-ba16-4a31-af07-57246dbccd5d', '미니멀 크로스백', 120000, 84000, '{"brand":"MUJI STYLE","image":"bag03"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('f80e0145-2020-4b8a-b36d-17189ede2d00', '러닝 스니커즈', 159000, 119000, '{"brand":"ATHLEISURE","image":"shoes04"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('5c00b159-62c6-4803-97d3-85b5e35f2d3b', '실크 블라우스', 98000, 68600, '{"brand":"ELEGANT","image":"blouse05"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', '가죽 토트백', 280000, 196000, '{"brand":"LEATHER LAB","image":"tote06"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('ce7c48cd-e699-451e-ae9a-d3c133df3707', '캐주얼 자켓', 145000, 101500, '{"brand":"URBAN STREET","image":"jacket07"}');
INSERT INTO PRODUCT (ID, NAME, PRICE, SALE_PRICE, DATA) VALUES ('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', '실버 목걸이', 75000, 56250, '{"brand":"AURUM","image":"necklace08"}');
