-- 안전하게 비밀번호를 저장할 수 있고, otp 시크릿 키를 저장할 수 있는 테이블을 만듬.
create table safe_member (
     id varchar(50) primary key not null ,
     name varchar(20) not null ,
     email varchar(50) ,
     password varchar(256) not null ,
     otp_key varchar(50) ,
     reg_date timestamp
);

-- 기존 데이터를 바뀐 테이블에 이식함.
insert into safe_member (id, name, email, password, reg_date, otp_key)
values ( 'satcop', '박규태', 'satcop@naver.com',
         '204621a0da1f80078b73508045e3278cb9dd6c3796ed2baf390c07294576ad79',
         parsedatetime('2026-05-29 01:07:41', 'yyyy-MM-dd HH:mm:ss'),
         'YQOFKWKIMUK2DYJQ');

insert into safe_member (id, name, email, password, reg_date, otp_key)
values ( 'satcop2', '박규태', 'satcop@naver.com',
         '204621a0da1f80078b73508045e3278cb9dd6c3796ed2baf390c07294576ad79',
         parsedatetime('2026-05-29 01:07:41', 'yyyy-MM-dd HH:mm:ss'),
         'RWQSZ76D6OUYHX4X');