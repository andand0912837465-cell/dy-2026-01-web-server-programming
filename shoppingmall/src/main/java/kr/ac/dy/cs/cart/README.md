# 🛒 서버 DB 기반 장바구니 기능 (20231553 김성민)

> 2026학년도 1학기 웹서버프로그래밍 / SHOPMALL 쇼핑몰(`shoppingmall` 모듈) 추가 구현
>
> 기존 **브라우저 localStorage 장바구니**를 **서버 H2 데이터베이스 기반 장바구니**로 전환한 기능입니다.

---

## 1. 개요

| 항목 | 내용 |
|------|------|
| 작성자 | 20231553 김성민 |
| 대상 모듈 | `shoppingmall` (Servlet/JSP + H2 JDBC) |
| 구현 주제 | 회원별 장바구니를 서버 DB(CART / CART_ITEM)에 저장·관리 |
| 핵심 효과 | 기기·브라우저가 바뀌어도 로그인 회원의 장바구니가 그대로 유지됨 |

기존 localStorage 방식은 기기·브라우저가 바뀌면 담은 상품이 사라지고 서버에서 데이터를 활용할 수 없었습니다.
본 기능은 장바구니 데이터의 **원천(source of truth)을 서버 DB로 이전**하여 이 문제를 해결합니다.

---

## 2. ⚠️ 작업 원칙 — 다른 팀원 코드 보존

본 기능은 **팀원이 작성한 기존 파일을 단 한 줄도 수정/삭제하지 않았습니다.**

- 모든 신규 소스는 **새로 만든 폴더 2개** 안에만 작성했습니다.
- 모든 소스 상단에 `학번 20231553 / 이름 김성민` + 기능 설명 주석을 달았습니다.
- 기존 자산(`ProductCatalog`, `PriceCalculator`, `H2DbConnector`, `SessionUtils`, `css/main.css` 등)은 **수정 없이 호출(재사용)만** 했습니다.
- `git status` 기준 변경 없이 신규(untracked) 항목만 추가됩니다.

---

## 3. 폴더 / 파일 구조 (신규 생성분만)

```
shoppingmall/src/main/
├── java/kr/ac/dy/cs/cart/            ← (신규) Java 패키지 폴더
│   ├── CartItemDto.java              장바구니 상품 1건 DTO (소계 파생값 제공)
│   ├── CartRepository.java           CART / CART_ITEM SQL (PreparedStatement), 테이블 자동 생성
│   └── CartService.java              담기/수량/삭제/합계·배송비 비즈니스 로직
│
└── webapp/cart_20231553/            ← (신규) JSP 폴더
    ├── shop.jsp                      상품 목록(담기 진입 화면)
    ├── cart.jsp                      장바구니 조회 화면 (서버 렌더링)
    ├── addCart.jsp                   FR-01 담기 처리
    ├── updateQty.jsp                 FR-03 수량 변경 처리
    ├── removeItem.jsp                FR-04 개별 삭제 처리
    ├── clearCart.jsp                 FR-05 전체 비우기 처리
    ├── cart_tables.ddl               CART / CART_ITEM 테이블 DDL(참고용)
    └── README.md                     본 문서
```

---

## 4. 기능 요구사항 (FR) / 비기능 요구사항 (NFR)

### 기능 요구사항
| ID | 기능 | 설명 |
|----|------|------|
| FR-01 | 장바구니 담기 | 상품 추가, 동일 상품이면 수량 누적 |
| FR-02 | 장바구니 조회 | 목록 + 상품합계 + 배송비 + 결제예정금액 표시 |
| FR-03 | 수량 변경 | 상품 수량 +/- (최소 1) |
| FR-04 | 상품 삭제 | 개별 상품 삭제 |
| FR-05 | 전체 비우기 | 장바구니의 모든 상품 삭제 |
| FR-06 | 개수 배지 | 헤더 장바구니 아이콘에 담긴 총 수량 표시 |

### 비기능 요구사항
| ID | 내용 | 구현 |
|----|------|------|
| NFR-01 | SQL Injection 방지 | 모든 SQL을 `PreparedStatement` 로 작성 |
| NFR-02 | 커넥션 자원 반납 | `finally` 의 `closeResources()` 로 반드시 반납 |
| NFR-03 | 비로그인 접근 제어 | 미로그인 시 `/auth/login.jsp` 로 리다이렉트 |
| NFR-04 | 가격 위·변조 방지 | 가격은 클라이언트 입력이 아닌 서버 `ProductCatalog` 값을 신뢰 |
| NFR-05 | 기존 디자인 유지 | 공유 `css/main.css` 클래스를 재사용 |

---

## 5. 데이터베이스 설계

```
MEMBER(기존) 1 ── 0..1 CART 1 ── * CART_ITEM
```

### CART (회원당 활성 장바구니 1개)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| CART_ID | BIGINT (PK, AUTO) | 장바구니 식별자 |
| MEMBER_ID | VARCHAR(50) | 소유 회원(로그인 ID) |
| REG_DATE / MOD_DATE | TIMESTAMP | 생성/수정 일시 |

### CART_ITEM (담긴 상품)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| CART_ITEM_ID | BIGINT (PK, AUTO) | 상품 항목 식별자 |
| CART_ID | BIGINT | 소속 CART |
| PRODUCT_ID | VARCHAR(50) | 상품 식별자 (예: best-0) |
| PRODUCT_NAME / BRAND / IMAGE_URL | VARCHAR | 상품 정보(스냅샷) |
| PRICE | INT | 담을 당시 판매가(서버 기준) |
| QUANTITY | INT | 담은 수량 |

> 📌 `CartRepository` 가 최초 실행 시 `CREATE TABLE IF NOT EXISTS` 로 위 두 테이블을 **자동 생성**하므로,
> 별도로 DDL을 실행하지 않아도 바로 동작합니다. (`cart_tables.ddl` 은 참고/수동 생성용)

---

## 6. 계층 구조 및 주요 메서드

```
[View]  cart_20231553/*.jsp   요청 수신, 로그인 확인, 결과 화면 출력
   ↓
[Service]  CartService        합계·배송비 계산, 담기 중복 처리, 서버 가격 신뢰
   ↓
[Repository]  CartRepository  PreparedStatement 기반 CART/CART_ITEM CRUD
   ↓
[Util(기존)]  H2DbConnector, SessionUtils, ProductCatalog, PriceCalculator (재사용)
```

### CartService 핵심 메서드
| 메서드 | 역할 |
|--------|------|
| `getOrCreateCartId(memberId)` | 회원 장바구니 ID 확보(없으면 생성) |
| `addItem(memberId, productId, qty)` | FR-01 담기 (ProductCatalog로 서버 가격 신뢰, 중복 시 수량+) |
| `getItems(memberId)` | FR-02 목록 조회 |
| `changeQuantity(cartItemId, qty)` | FR-03 수량 변경(최소 1) |
| `removeItem(cartItemId)` | FR-04 개별 삭제 |
| `clear(memberId)` | FR-05 전체 비우기 |
| `getTotalQuantity / getSubtotal / getShippingFee / getTotal` | FR-06 배지·합계·배송비·결제예정금액 |

> 배송비 정책은 팀의 `PriceCalculator` 상수(5만원 이상 무료, 미만 3,000원)를 재사용합니다.

---

## 7. 처리 흐름

```
[상품 목록] shop.jsp ─(장바구니 담기 POST)→ addCart.jsp
     1) 로그인 확인 (미로그인 → /auth/login.jsp)
     2) productId, qty 수신
     3) CartService.addItem() : 서버 가격으로 담기 (중복이면 수량 누적)
     4) cart.jsp 로 리다이렉트
            │
            ▼
[장바구니] cart.jsp  (서버 DB 조회 후 표 렌더링)
     · 수량 +/- → updateQty.jsp
     · 개별 삭제 → removeItem.jsp
     · 전체 비우기 → clearCart.jsp
     · 상품합계 / 배송비 / 결제예정금액 표시
```

---

## 8. 실행 방법

### 사전 조건
1. **Tomcat 10.1 이상** 사용 (본 프로젝트는 `jakarta.servlet` 기반 → Tomcat 9 불가)
2. IntelliJ 에서 `shoppingmall` 을 **Maven 프로젝트로 임포트** (의존성/아티팩트 자동 구성)
3. Run 구성 ▸ Deployment ▸ **Application context = `/`** 로 설정

### 접속 및 사용
1. Tomcat 실행 후 회원가입 → 가입 성공 화면의 QR/텍스트 키를 **Google Authenticator** 에 등록
2. 로그인(ID/비밀번호) → OTP 6자리 입력 → 로그인 완료
3. 브라우저에서 아래 주소로 접속
   ```
   http://localhost:<포트>/cart_20231553/shop.jsp
   ```
4. 상품 담기 → 장바구니에서 수량 변경 / 삭제 / 전체 비우기 확인

---

## 9. 재사용한 기존 자산 (수정하지 않고 호출만)

| 자산 | 용도 |
|------|------|
| `kr.ac.dy.cs.util.H2DbConnector` | H2 DB 커넥션 획득/반납 |
| `kr.ac.dy.cs.util.SessionUtils` | 로그인 여부 판별(`loginId` 세션) |
| `kr.ac.dy.cs.order.ProductCatalog` | 서버 상품 목록 / 신뢰 가격 |
| `kr.ac.dy.cs.order.PriceCalculator` | 배송비 정책 상수 |
| `webapp/css/main.css` | 화면 스타일(디자인 유지) |
