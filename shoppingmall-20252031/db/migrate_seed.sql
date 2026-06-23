-- ============================================================
-- VISITOR / PURCHASE : MEMBER_ID 타입 정정 + 샘플 데이터
--  - MEMBER.ID 가 VARCHAR(50) 이므로 FK 컬럼 타입을 맞춰준다.
--  - PRODUCT 테이블의 실제 상품/MEMBER 기준으로 샘플 행을 생성한다.
-- ============================================================

-- 1) 기존 FK 제거 (MEMBER 참조)
ALTER TABLE VISITOR  DROP CONSTRAINT IF EXISTS CONSTRAINT_469D;
ALTER TABLE PURCHASE DROP CONSTRAINT IF EXISTS CONSTRAINT_968;

-- 2) MEMBER_ID 타입을 MEMBER.ID(VARCHAR(50)) 와 일치시킴
ALTER TABLE VISITOR  ALTER COLUMN MEMBER_ID VARCHAR(50) NOT NULL;
ALTER TABLE PURCHASE ALTER COLUMN MEMBER_ID VARCHAR(50) NOT NULL;

-- 3) FK 재생성
ALTER TABLE VISITOR  ADD CONSTRAINT FK_VISITOR_MEMBER  FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(ID);
ALTER TABLE PURCHASE ADD CONSTRAINT FK_PURCHASE_MEMBER FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(ID);

-- 4) 기존 샘플 정리
DELETE FROM PURCHASE;
DELETE FROM VISITOR;

-- ============================================================
-- PURCHASE 샘플 (PRICE = 구매시점 단가, TOTAL_AMOUNT = PRICE * QUANTITY)
-- ============================================================
INSERT INTO PURCHASE (PRODUCT_ID, MEMBER_ID, QUANTITY, PRICE, TOTAL_AMOUNT, PURCHASED_AT) VALUES
-- 2026-04
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',   1,  39000,  39000, TIMESTAMP '2026-04-10 11:20:00'),
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop2',  2,  62300, 124600, TIMESTAMP '2026-04-15 14:05:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop',   1,  84000,  84000, TIMESTAMP '2026-04-22 16:40:00'),
-- 2026-05
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop',   1, 119000, 119000, TIMESTAMP '2026-05-03 10:15:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2',  1,  68600,  68600, TIMESTAMP '2026-05-09 13:30:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop',   1, 196000, 196000, TIMESTAMP '2026-05-12 18:00:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop2',  1, 101500, 101500, TIMESTAMP '2026-05-18 12:45:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop',   3,  56250, 168750, TIMESTAMP '2026-05-25 09:50:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop2',  2,  39000,  78000, TIMESTAMP '2026-05-28 20:10:00'),
-- 2026-06
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop',   1,  62300,  62300, TIMESTAMP '2026-06-01 11:00:00'),
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop2',  1, 119000, 119000, TIMESTAMP '2026-06-03 15:20:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop',   2,  84000, 168000, TIMESTAMP '2026-06-05 17:35:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop',   1,  68600,  68600, TIMESTAMP '2026-06-08 10:05:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop2',  1, 101500, 101500, TIMESTAMP '2026-06-10 14:50:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',   3,  39000, 117000, TIMESTAMP '2026-06-12 19:25:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop2',  1, 196000, 196000, TIMESTAMP '2026-06-14 13:10:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop',   2,  56250, 112500, TIMESTAMP '2026-06-15 16:00:00'),
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop2',  1,  62300,  62300, TIMESTAMP '2026-06-17 11:40:00'),
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop',   1, 119000, 119000, TIMESTAMP '2026-06-18 18:20:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop2',  1,  84000,  84000, TIMESTAMP '2026-06-19 12:30:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',   1,  39000,  39000, TIMESTAMP '2026-06-20 10:45:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2',  2,  68600, 137200, TIMESTAMP '2026-06-21 15:55:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop',   1, 101500, 101500, TIMESTAMP '2026-06-21 20:05:00');

-- ============================================================
-- VISITOR 샘플 (구매보다 방문이 많아야 전환율이 의미있음)
-- ============================================================
INSERT INTO VISITOR (PRODUCT_ID, MEMBER_ID, VISITED_AT) VALUES
-- 2026-05
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-05-03 10:10:00'),
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop',  TIMESTAMP '2026-05-03 10:12:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2', TIMESTAMP '2026-05-09 13:25:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop',  TIMESTAMP '2026-05-12 17:55:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop2', TIMESTAMP '2026-05-18 12:40:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop',  TIMESTAMP '2026-05-25 09:45:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop2', TIMESTAMP '2026-05-26 21:00:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop2', TIMESTAMP '2026-05-28 20:05:00'),
-- 2026-06-01
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop',  TIMESTAMP '2026-06-01 10:55:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-06-01 10:58:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop2', TIMESTAMP '2026-06-01 22:10:00'),
-- 2026-06-03
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop2', TIMESTAMP '2026-06-03 15:15:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop',  TIMESTAMP '2026-06-03 19:30:00'),
-- 2026-06-05
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop',  TIMESTAMP '2026-06-05 17:30:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2', TIMESTAMP '2026-06-05 18:00:00'),
-- 2026-06-08
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop',  TIMESTAMP '2026-06-08 10:00:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop',  TIMESTAMP '2026-06-08 10:30:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop2', TIMESTAMP '2026-06-08 14:20:00'),
-- 2026-06-10
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop2', TIMESTAMP '2026-06-10 14:45:00'),
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop',  TIMESTAMP '2026-06-10 16:10:00'),
-- 2026-06-12
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-06-12 19:20:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop2', TIMESTAMP '2026-06-12 20:40:00'),
-- 2026-06-14
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop2', TIMESTAMP '2026-06-14 13:05:00'),
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop',  TIMESTAMP '2026-06-14 18:30:00'),
-- 2026-06-15
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop',  TIMESTAMP '2026-06-15 15:55:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop2', TIMESTAMP '2026-06-15 17:20:00'),
-- 2026-06-17
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop2', TIMESTAMP '2026-06-17 11:35:00'),
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-06-17 13:00:00'),
-- 2026-06-18
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop',  TIMESTAMP '2026-06-18 18:15:00'),
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2', TIMESTAMP '2026-06-18 19:50:00'),
-- 2026-06-19
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop2', TIMESTAMP '2026-06-19 12:25:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop',  TIMESTAMP '2026-06-19 21:15:00'),
-- 2026-06-20
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-06-20 10:40:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop2', TIMESTAMP '2026-06-20 11:10:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop',  TIMESTAMP '2026-06-20 22:30:00'),
-- 2026-06-21
('5c00b159-62c6-4803-97d3-85b5e35f2d3b', 'satcop2', TIMESTAMP '2026-06-21 15:50:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop',  TIMESTAMP '2026-06-21 20:00:00'),
('67c78ae9-0734-4af5-89e3-2247d55e8ff2', 'satcop',  TIMESTAMP '2026-06-21 21:30:00'),
('1fbcd71d-ba16-4a31-af07-57246dbccd5d', 'satcop2', TIMESTAMP '2026-06-21 23:05:00'),
-- 2026-06-22 (오늘, 미구매 방문 다수)
('1cc19d21-1590-4f7c-ade5-94b5a325fddc', 'satcop',  TIMESTAMP '2026-06-22 09:10:00'),
('f80e0145-2020-4b8a-b36d-17189ede2d00', 'satcop2', TIMESTAMP '2026-06-22 09:40:00'),
('5de7176a-1ac4-47de-bd30-a9baeb8cecc0', 'satcop',  TIMESTAMP '2026-06-22 10:25:00'),
('fe08a1c2-b5ec-4ee0-bdbe-b336b0d31fe1', 'satcop2', TIMESTAMP '2026-06-22 11:00:00'),
('ce7c48cd-e699-451e-ae9a-d3c133df3707', 'satcop',  TIMESTAMP '2026-06-22 11:45:00');
