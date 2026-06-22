# 장바구니(Cart) 기능 구현 계획서 (20231553-김성민)

> **과목** : 2026학년도 1학기 웹서버프로그래밍
> **프로젝트** : SHOPMALL 쇼핑몰 (`shoppingmall`)
> **구현 주제** : 브라우저(localStorage) 기반 장바구니를 **서버 DB 기반 장바구니**로 전환
> **작성일** : 2026-06-11

---

## 1. 과제 개요

### 1.1 목적
현재 SHOPMALL 쇼핑몰의 장바구니는 **브라우저 `localStorage`에만 데이터를 저장**하고 있어, 기기·브라우저가 바뀌면 담아둔 상품이 사라지고 서버에서 장바구니 데이터를 활용할 수 없다. 본 과제에서는 장바구니 정보를 **H2 데이터베이스에 저장·관리**하도록 전환하여, 로그인한 회원이 어디서 접속하든 동일한 장바구니를 유지할 수 있도록 한다.

> 본 계획서는 **장바구니 기능 구현**에 범위를 한정한다. 주문(결제)·관리자 연동은 후속 과제(7장 향후 확장)로 분리한다.

### 1.2 범위
- 장바구니 **담기**(상품 추가, 동일 상품은 수량 증가)
- 장바구니 **조회**(목록 + 합계 금액 + 배송비 계산)
- 장바구니 **수량 변경**(증가/감소)
- 장바구니 **상품 삭제** 및 **전체 비우기**
- 장바구니 **개수 배지** 표시(헤더 아이콘)
- 기존 화면(JSP/CSS) 디자인은 유지하고, **데이터 계층만 추가·전환**한다.

### 1.3 적용 모듈
| 모듈 | 역할 | 본 과제 변경 여부 |
|------|------|------------------|
| `shoppingmall` | 고객용 쇼핑몰 (Servlet/JSP + H2 JDBC) | ✅ 변경 대상 |
| `shoppingmall-backoffice` | 관리자 백오피스 | ➖ 변경 없음 |
| `shoppingmall-cs` | 고객센터/배송 (Spring Boot) | ➖ 변경 없음 |
| `shooppingmall-memo` | 학습용 메모 (Spring Boot) | ➖ 변경 없음 |

---

## 2. 현행 시스템 분석

### 2.1 현재 장바구니 처리 흐름
```
[상품 페이지] index.jsp ─(장바구니 담기 클릭)→ js/shop.js
        │  localStorage["shopmallCart"] 에 JSON 배열로 저장
        ▼
[장바구니] cart/cart.jsp + js/cart.js
        │  localStorage 읽어 표 렌더링
        │  수량 변경(+/-)·삭제도 localStorage 직접 수정
        ▼
[주문서] order/checkout.jsp (이후 단계, 본 과제 범위 밖)
```

### 2.2 현재 장바구니 데이터 구조 (localStorage)
`js/cart.js`가 사용하는 항목 1건의 형태는 다음과 같다.
```json
{
  "id": "best-0",
  "name": "오버사이즈 코튼 셔츠",
  "brand": "BASIC HOUSE",
  "price": 39000,
  "image": "https://picsum.photos/seed/shirt01/400/400",
  "quantity": 2
}
```
- 배송비 정책 상수: `FREE_SHIPPING_MINIMUM = 50000`(5만원 이상 무료), `SHIPPING_FEE = 3000`.
- 본 과제는 위 구조를 그대로 **DB 컬럼으로 옮긴다**.

### 2.3 문제점
| 구분 | 현재 상태 | 문제점 |
|------|-----------|--------|
| 저장 위치 | 브라우저 `localStorage` | 서버에 장바구니 데이터가 남지 않음 |
| 기기 간 동기화 | 불가 | 다른 PC/브라우저에서 담은 상품 유실 |
| 데이터 신뢰성 | 클라이언트 임의 수정 가능 | 가격·수량 위변조 위험 |
| 활용성 | 불가 | 서버에서 인기 상품·재고 등 분석 불가 |

### 2.4 기존 코드 자산 (재사용 대상)
- **DB 접속**: `kr.ac.dy.cs.util.H2DbConnector` (JDBC Connection 획득/반납)
- **계층 패턴**: `Repository`(SQL) → `Service`(비즈니스) → `JSP`(화면) — `MemberRepository`, `NoticeRepository`에서 확립됨
- **DTO**: Lombok `@Data`/`@Builder` (`MemberDto`, `NoticeDto`)
- **세션 인증**: `SessionUtils.isLoginYn(session)`, `session.getAttribute("loginId")`
- 본 과제는 위 패턴을 **그대로 따라** `cart` 도메인을 추가한다.

---

## 3. 구현 목표 및 요구사항

### 3.1 기능 요구사항 (FR)
| ID | 요구사항 | 설명 |
|----|----------|------|
| FR-01 | 장바구니 담기 | 상품을 장바구니에 추가. 동일 상품이 이미 있으면 **수량만 증가** |
| FR-02 | 장바구니 조회 | 로그인 회원의 장바구니 목록·상품합계·배송비·결제예정금액 표시 |
| FR-03 | 수량 변경 | 장바구니 상품 수량 +/- (최소 1) |
| FR-04 | 상품 삭제 | 장바구니에서 개별 상품 삭제 |
| FR-05 | 전체 비우기 | 장바구니의 모든 상품 삭제 |
| FR-06 | 개수 배지 | 헤더 장바구니 아이콘에 담긴 총 수량 표시 |

### 3.2 비기능 요구사항 (NFR)
| ID | 요구사항 |
|----|----------|
| NFR-01 | 모든 SQL은 `PreparedStatement`로 작성하여 SQL Injection 방지 |
| NFR-02 | DB 커넥션은 `try ~ finally`에서 반드시 `closeConnection()`으로 반납 |
| NFR-03 | 비로그인 사용자가 장바구니 접근 시 로그인 페이지로 유도 |
| NFR-04 | 가격은 서버에 저장된 값을 신뢰(합계는 서버에서 계산) |
| NFR-05 | 기존 화면(JSP/CSS) 레이아웃·디자인은 변경하지 않음 |

---

## 4. 데이터베이스 설계

### 4.1 ERD (개념도)
```
MEMBER(기존) 1 ──── 0..1 CART 1 ──── * CART_ITEM
   │ id(PK)              cart_id(PK)      cart_item_id(PK)
```
- `MEMBER` 1명은 활성 `CART`를 0~1개 가진다.
- `CART` 1개는 `CART_ITEM`(담긴 상품)을 여러 개 가진다.

### 4.2 테이블 정의 (DDL)
```sql
-- 장바구니 (회원당 활성 1개)
CREATE TABLE CART (
    CART_ID    BIGINT AUTO_INCREMENT PRIMARY KEY,
    MEMBER_ID  VARCHAR(50) NOT NULL,            -- MEMBER.ID 참조
    REG_DATE   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MOD_DATE   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 장바구니에 담긴 상품
CREATE TABLE CART_ITEM (
    CART_ITEM_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    CART_ID      BIGINT       NOT NULL,         -- CART.CART_ID 참조
    PRODUCT_ID   VARCHAR(50)  NOT NULL,         -- 상품 식별자(예: best-0)
    PRODUCT_NAME VARCHAR(200) NOT NULL,
    BRAND        VARCHAR(100),
    PRICE        INT          NOT NULL,
    IMAGE_URL    VARCHAR(500),
    QUANTITY     INT          NOT NULL DEFAULT 1,
    REG_DATE     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4.3 주요 컬럼 설명
| 컬럼 | 의미 |
|------|------|
| `CART.MEMBER_ID` | 장바구니 소유 회원(로그인 ID) |
| `CART_ITEM.PRODUCT_ID` | 상품 식별자(현재 화면의 `data-id` 값) |
| `CART_ITEM.PRICE` | 담을 당시 판매가(스냅샷) |
| `CART_ITEM.QUANTITY` | 담은 수량(동일 상품 재담기 시 누적) |

---

## 5. 시스템 설계

### 5.1 패키지 / 파일 구조 (신규·변경)
```
shoppingmall/src/main/
├── java/kr/ac/dy/cs/cart/
│   ├── CartItemDto.java     (신규) 장바구니 상품 DTO
│   ├── CartRepository.java  (신규) CART / CART_ITEM SQL
│   └── CartService.java     (신규) 장바구니 비즈니스 로직
└── webapp/cart/
    ├── cart.jsp             (변경) JS→서버 데이터 렌더링
    ├── addCart.jsp          (신규) 담기 처리
    ├── updateQty.jsp        (신규) 수량 변경 처리
    ├── removeItem.jsp       (신규) 개별 삭제 처리
    └── clearCart.jsp        (신규) 전체 비우기 처리
```

### 5.2 계층 책임
| 계층 | 클래스/파일 | 책임 |
|------|-------------|------|
| View | `cart/*.jsp` | 요청 파라미터 수신, 세션 확인, 결과 화면 출력 |
| Service | `CartService` | 합계·배송비 계산, 담기 시 중복 처리, 화면 ↔ DB 변환 |
| Repository | `CartRepository` | `PreparedStatement` 기반 CART/CART_ITEM CRUD |
| Util(기존) | `H2DbConnector`, `SessionUtils` | DB 커넥션, 로그인 판별 |

### 5.3 DTO 설계 (CartItemDto)
```java
@Data
@Builder
public class CartItemDto {
    private Long   cartItemId;
    private Long   cartId;
    private String productId;
    private String productName;
    private String brand;
    private int    price;
    private String imageUrl;
    private int    quantity;
    // 화면 표시용 파생값
    public int getLineTotal() { return price * quantity; }
}
```

### 5.4 핵심 클래스 명세 (메서드 시그니처)
```java
// CartRepository : SQL 담당
public class CartRepository {
    Long   selectCartId(String memberId);                 // 회원 장바구니 조회
    Long   insertCart(String memberId);                   // 장바구니 생성
    CartItemDto selectItem(long cartId, String productId);// 동일 상품 존재 확인
    int    insertItem(CartItemDto item);                  // 상품 추가
    int    updateQuantity(long cartItemId, int quantity); // 수량 변경
    List<CartItemDto> selectItems(long cartId);           // 목록 조회
    int    deleteItem(long cartItemId);                   // 개별 삭제
    int    deleteAllItems(long cartId);                   // 전체 비우기
}

// CartService : 비즈니스 로직
public class CartService {
    long getOrCreateCartId(String memberId);              // 장바구니 ID 확보
    void addItem(String memberId, CartItemDto item);      // FR-01 (있으면 수량+)
    List<CartItemDto> getItems(String memberId);          // FR-02
    void changeQuantity(long cartItemId, int quantity);   // FR-03
    void removeItem(long cartItemId);                     // FR-04
    void clear(String memberId);                          // FR-05
    int  getTotalQuantity(List<CartItemDto> items);       // FR-06 배지 수량
    int  getSubtotal(List<CartItemDto> items);            // 상품 합계
    int  getShippingFee(int subtotal);                    // 5만↑ 무료, 미만 3,000
    int  getTotal(List<CartItemDto> items);               // 결제예정금액
}
```

### 5.5 담기(중복 처리) 로직 — FR-01
```java
// CartService.addItem() 의사코드
long cartId = getOrCreateCartId(memberId);          // 없으면 CART 생성
CartItemDto exist = cartRepository.selectItem(cartId, item.getProductId());
if (exist != null) {
    // 이미 담긴 상품 → 수량 누적
    cartRepository.updateQuantity(exist.getCartItemId(),
                                  exist.getQuantity() + item.getQuantity());
} else {
    // 신규 → INSERT
    item.setCartId(cartId);
    cartRepository.insertItem(item);
}
```

### 5.6 배송비 계산 로직
```java
public int getShippingFee(int subtotal) {
    final int FREE_MIN = 50000;   // 기존 JS 상수와 동일
    final int FEE      = 3000;
    return subtotal >= FREE_MIN ? 0 : FEE;
}
```

---

## 6. 처리 흐름 및 화면 명세

### 6.1 담기 흐름 (FR-01)
```
상품 카드 [장바구니 담기] ─POST→ cart/addCart.jsp
   1) 로그인 확인 (미로그인 → /auth/login.jsp)
   2) 파라미터 수신(productId,name,brand,price,image,qty)
   3) CartService.addItem(memberId, item)
        ├ getOrCreateCartId → CART 확보
        └ 동일 상품? UPDATE 수량+ : INSERT
   4) cart/cart.jsp 로 리다이렉트(담은 결과 반영)
```

### 6.2 조회 흐름 (FR-02)
```
cart/cart.jsp 진입
   1) 로그인 확인
   2) List<CartItemDto> = CartService.getItems(memberId)
   3) 비어 있으면 '빈 장바구니' 영역, 있으면 표 렌더링
   4) 상품합계 / 배송비 / 결제예정금액 표시
```

### 6.3 화면(JSP) 명세
| 화면 | 경로 | 메서드 / 파라미터 | 설명 |
|------|------|------------------|------|
| 장바구니 | `/cart/cart.jsp` | GET | DB 장바구니 목록·합계 표시 |
| 담기 | `/cart/addCart.jsp` | POST `productId,name,brand,price,image,qty` | 장바구니 추가 후 리다이렉트 |
| 수량변경 | `/cart/updateQty.jsp` | POST `cartItemId,quantity` | 수량 갱신 후 리다이렉트 |
| 개별삭제 | `/cart/removeItem.jsp` | POST `cartItemId` | 항목 삭제 후 리다이렉트 |
| 전체비우기 | `/cart/clearCart.jsp` | POST | 전체 삭제 후 리다이렉트 |

> 기존 `js/cart.js`의 localStorage 직접 수정 로직은 **폼 전송(서버 처리) 방식**으로 대체한다. 화면 표시는 그대로 두되, 데이터의 원천(source of truth)을 **서버 DB**로 옮긴다.

---

*본 문서는 첨부된 `dy-2026-01-web-server-programming` 웹서버 프로젝트의 실제 소스 구조(Repository/Service/JSP + H2 JDBC, 세션 인증)를 분석하여 동일한 규약으로 작성되었으며, 구현 범위를 **장바구니 기능**으로 한정하였습니다.*
