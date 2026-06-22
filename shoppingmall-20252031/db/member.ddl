
-- auto-generated definition
create table MEMBER
(
    ID       CHARACTER VARYING(50) not null primary key,
    NAME     CHARACTER VARYING(20) not null,
    EMAIL    CHARACTER VARYING(50),
    PASSWORD CHARACTER VARYING(50) not null,
    REG_DATE TIMESTAMP
);

INSERT INTO PUBLIC.MEMBER (ID, NAME, EMAIL, PASSWORD, REG_DATE) VALUES ('satcop', '박규태', 'satcop@naver.com', '1234', '2026-05-29 01:07:41.000000');
INSERT INTO PUBLIC.MEMBER (ID, NAME, EMAIL, PASSWORD, REG_DATE) VALUES ('satcop2', '박규태', 'satcop@naver.com', '1234', '2026-05-29 01:07:41.000000');


