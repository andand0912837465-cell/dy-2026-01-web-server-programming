
-- 관리자정보
-- 관리자아이디, 관리자이름, 비밀번호, 사용여부

create table admin_user
(
    admin_id varchar(50) primary key not null,
    admin_name varchar(20) not null,
    password varchar(255) not null,
    using_yn char(1) not null,
    reg_dt datetime
);


insert into admin_user (admin_id, admin_name, password, using_yn, reg_dt)  values ( 'admin', '관리자', '1234', 'y', now() );


