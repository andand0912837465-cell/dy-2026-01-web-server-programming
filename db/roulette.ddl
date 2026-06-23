/*
20251261 장문기
쇼핑몰 룰렛 이벤트 결과 저장 테이블
*/

create table roulette
(
    id bigint auto_increment primary key,
    user_id varchar(50) not null,
    point int not null,
    play_date date not null

);
