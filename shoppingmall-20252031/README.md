# 20252031 이준성 기능 구현

## DB

- PRODUCT, VISITOR, PURCHASE 테이블 구현
- PURCHASE.MEMBER_ID와 VISITOR.MEMBER_ID는 MEMBER.ID기반 foreign key로, VARCHAR(50)으로 구현

## shoppingmall

- 메인 페이지의 상품 정보를 DB 조회하도록 변경.
- 상품의 상세 페이지 구현.
- 상세 페이지 진입 시 VISITOR 등록 로직 구현.
- 로그인이 문자열로 하드코딩되어 있는 것을 변경하여 MEMBER 기반으로 로그인 가능하도록 구현.

## shoppingmall-backoffice

- 매출 통계 페이지 구현.
  - PURCHASE 테이블 기반으로 매출 통계 출력됨.
- 방문자 분석 페이지 구현.
  - VISITOR 테이블 기반으로 총 방문 수, UV 등의 지표 측정.
- 현재 PURCHASE 테이블은 샘플 데이터 사용 중.