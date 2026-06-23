# QuizMaster

주제별 퀴즈를 풀 수 있는 웹 애플리케이션입니다.
로그인 후 5개의 주제 중 하나를 선택하여 객관식 퀴즈를 풀고, 점수와 오답을 확인할 수 있습니다.


---

## 프로젝트 구조 (MVC 패턴)

```
quiz-master/
├── pom.xml                                  
├── README.md                               
├── src/
│   ├── main/
│   │   ├── java/kr/ac/dy/cs/quizmaster/
│   │   │   ├── controller/                  # [Controller]
│   │   │   │   ├── AuthFilter.java          #   인증 필터 (로그인 체크)
│   │   │   │   ├── LoginServlet.java        #   /login - 로그인 처리
│   │   │   │   ├── LogoutServlet.java       #   /logout - 로그아웃
│   │   │   │   ├── RegisterServlet.java     #   /register - 회원가입
│   │   │   │   ├── TopicListServlet.java    #   /topics - 주제 목록 조회
│   │   │   │   ├── QuizServlet.java         #   /quiz - 퀴즈 출제 & 채점
│   │   │   │   ├── ResultListServlet.java   #   /results - 기록 조회
│   │   │   │   └── StartupListener.java     #   앱 시작 시 DB 초기화
│   │   │   ├── service/                     # [Service] 비즈니스 로직
│   │   │   │   ├── UserService.java         #   로그인/회원가입 검증
│   │   │   │   └── QuizService.java         #   퀴즈 채점, 결과 저장/조회
│   │   │   ├── repository/                  # [Repository] 데이터 액세스 (DAO)
│   │   │   │   ├── UserRepository.java      #   QUIZ_USER 테이블 CRUD
│   │   │   │   ├── QuizTopicRepository.java #   QUIZ_TOPIC 테이블 조회
│   │   │   │   ├── QuizQuestionRepository.java # QUIZ_QUESTION 테이블 조회
│   │   │   │   └── QuizResultRepository.java #   QUIZ_RESULT 테이블 CRUD
│   │   │   ├── dto/                         # [Model]
│   │   │   │   ├── User.java                #   사용자 정보
│   │   │   │   ├── QuizTopic.java           #   퀴즈 주제
│   │   │   │   ├── QuizQuestion.java        #   퀴즈 문제 (4지선다)
│   │   │   │   └── QuizResult.java          #   퀴즈 결과
│   │   │   └── util/                        # 유틸리티
│   │   │       ├── QuizH2DbConnector.java   #   H2 DB 연결 관리
│   │   │       └── DatabaseInitializer.java #   DB 초기화
│   │   ├── resources/
│   │   │   └── schema.sql                   # DDL + 시드 데이터
│   │   └── webapp/
│   │       └── WEB-INF/                     # [View]
│   │           ├── web.xml                  # 배포 설정
│   │           ├── login.jsp                # 로그인 페이지
│   │           ├── register.jsp             # 회원가입 페이지
│   │           ├── topics.jsp               # 주제 선택 페이지
│   │           ├── quiz.jsp                 # 퀴즈 풀기 페이지
│   │           ├── result.jsp               # 결과 및 오답 리뷰 페이지
│   │           └── results.jsp              # 퀴즈 기록 조회 페이지
│   └── test/
└── target/
    └── quiz-master-1.0-SNAPSHOT.war         # 빌드된 WAR 파일
```

### MVC 계층 설명

| 계층 | 역할 | 포함 파일 |
|------|------|-----------|
| **Model** (`dto/`) | 데이터 표현 객체. DB 테이블과 1:1 매핑 | User, QuizTopic, QuizQuestion, QuizResult |
| **Repository** (`repository/`) | DB 접근 로직 (DAO). SQL 실행 및 결과 매핑 | 각 테이블별 1개 |
| **Service** (`service/`) | 비즈니스 로직. Controller와 Repository 중간에서 검증/처리 | UserService, QuizService |
| **Controller** (`controller/`) | HTTP 요청 처리. 파라미터 검증 → Service 호출 → View로 포워딩 | 7개 Servlet + Filter |
| **View** (`WEB-INF/`) | JSP 화면 출력. Controller가 전달한 데이터를 HTML로 렌더링 | 6개 JSP |

### 요청 흐름

```
사용자 → [AuthFilter 인증 체크] → [Servlet Controller] → [Service] → [Repository] → H2 DB
                                                         ↓
                                                    [JSP View] → HTML 응답
```

---

## 데이터베이스


### 테이블 구조

| 테이블 | 설명 | 주요 컬럼 |
|--------|------|-----------|
| `QUIZ_USER` | 사용자 | user_id (PK), name, password |
| `QUIZ_TOPIC` | 퀴즈 주제 | topic_id (PK), topic_name, description |
| `QUIZ_QUESTION` | 퀴즈 문제 | question_id (PK), topic_id (FK), question_text, option1~4, correct_answer |
| `QUIZ_RESULT` | 퀴즈 결과 | result_id (PK), user_id (FK), topic_id (FK), score, total, attempt_date |



### 초기 데이터

최초 실행 시 `schema.sql`에 정의된 다음 데이터가 자동으로 입력됩니다.
- 샘플 사용자: `test` / `1234`
- 5개 주제, 각 주제당 5문항 (총 25문항)

---

## API 엔드포인트

| URL | Method | 설명 | 인증 필요 |
|-----|--------|------|-----------|
| `/` | GET | 루트 - 로그인 페이지로 리다이렉트 | X |
| `/login` | GET | 로그인 페이지 표시 | X |
| `/login` | POST | 로그인 처리 | X |
| `/register` | GET | 회원가입 페이지 표시 | X |
| `/register` | POST | 회원가입 처리 | X |
| `/logout` | GET | 로그아웃 처리 | O |
| `/topics` | GET | 주제 목록 페이지 | O |
| `/quiz?topicId={id}` | GET | 퀴즈 풀기 페이지 (문제 출력) | O |
| `/quiz` | POST | 퀴즈 제출 및 채점 | O |
| `/results` | GET | 내 퀴즈 기록 페이지 | O |

---


### 테스트 계정

- **아이디**: `test`
- **비밀번호**: `1234`

---

## 퀴즈 주제 (5개)

| 주제 | ID | 설명 | 문항 수 |
|------|----|------|---------|
| **Java 프로그래밍** | 1 | Java 언어 기초, 객체지향 개념, 컬렉션, 예외 처리 | 5 |
| **데이터베이스** | 2 | SQL 문법, 정규화, 트랜잭션 ACID, 인덱스 | 5 |
| **웹 개발** | 3 | HTML/CSS, JavaScript, Servlet/JSP 생명주기, HTTP | 5 |
| **알고리즘** | 4 | 정렬 알고리즘, 자료구조(스택/큐), 이진 탐색, 재귀 | 5 |
| **네트워크** | 5 | TCP/UDP, HTTP/HTTPS, DNS, OSI 7계층, IP | 5 |

---

## 기능

### 1. 회원가입 및 로그인
- 아이디, 이름, 비밀번호로 회원가입
- 중복 아이디 체크
- 세션 기반 로그인 유지

### 2. 주제별 퀴즈
- 5가지 주제 중 선택하여 퀴즈 시작
- 각 주제당 5문항, 4지 선다형

### 3. 채점 및 결과 확인
- 제출 즉시 자동 채점
- 점수/전체 문항 및 정답률 표시

### 4. 오답 리뷰
- 각 문항별 정답/오답 표시 (초록/빨강)
- 정답 위치 확인 가능 (✓ 표시)

### 5. 퀴즈 기록
- 사용자별 전체 퀴즈 이력 조회
- 주제별 점수, 정답률, 응시 일자 확인
- 최신순 정렬

---

## 문제 출처 및 확장

새로운 문제를 추가하려면 `src/main/resources/schema.sql`의 `QUIZ_QUESTION` MERGE 구문에 데이터를 추가하거나, 별도의 관리 화면을 개발하여 데이터를 입력할 수 있습니다.

현재는 관리자 기능 없이 고정된 문제로 동작하며, 관리자 기능이 필요할 경우 `TopicListServlet`과 `QuizQuestionRepository`를 확장하여 추가할 수 있습니다.
