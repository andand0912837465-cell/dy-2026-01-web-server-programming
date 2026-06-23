-- 20251258 김상범
-- QUIZ_USER, QUIZ_TOPIC, QUIZ_QUESTION, QUIZ_RESULT 테이블을 생성하고 초기 데이터를 입력하는 SQL 스크립트
-- QUIZ_USER 테이블
CREATE TABLE IF NOT EXISTS QUIZ_USER (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- QUIZ_TOPIC 테이블
CREATE TABLE IF NOT EXISTS QUIZ_TOPIC (
    topic_id INT AUTO_INCREMENT PRIMARY KEY,
    topic_name VARCHAR(100) NOT NULL,
    description VARCHAR(500)
);

-- QUIZ_QUESTION 테이블
CREATE TABLE IF NOT EXISTS QUIZ_QUESTION (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    topic_id INT NOT NULL,
    question_text VARCHAR(1000) NOT NULL,
    option1 VARCHAR(500) NOT NULL,
    option2 VARCHAR(500) NOT NULL,
    option3 VARCHAR(500) NOT NULL,
    option4 VARCHAR(500) NOT NULL,
    correct_answer INT NOT NULL CHECK (correct_answer BETWEEN 1 AND 4),
    FOREIGN KEY (topic_id) REFERENCES QUIZ_TOPIC(topic_id)
);

-- QUIZ_RESULT 테이블
CREATE TABLE IF NOT EXISTS QUIZ_RESULT (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    topic_id INT NOT NULL,
    score INT NOT NULL,
    total INT NOT NULL,
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES QUIZ_USER(user_id),
    FOREIGN KEY (topic_id) REFERENCES QUIZ_TOPIC(topic_id)
);

-- 샘플 사용자
MERGE INTO QUIZ_USER (user_id, name, password) KEY(user_id) VALUES ('test', '테스트', '1234');

-- 주제 데이터
MERGE INTO QUIZ_TOPIC (topic_id, topic_name, description) KEY(topic_id) VALUES
(1, 'Java 프로그래밍', 'Java 언어의 기초부터 객체지향 개념까지 테스트해보세요'),
(2, '데이터베이스', 'SQL, 정규화, 트랜잭션 등 데이터베이스 기본 지식을 확인합니다'),
(3, '웹 개발', 'HTML, CSS, JavaScript, 서블릿/JSP 등 웹 기술을 평가합니다'),
(4, '알고리즘', '정렬, 탐색, 자료구조 등 알고리즘 기본기를 점검하세요'),
(5, '네트워크', 'TCP/IP, HTTP, DNS 등 네트워크 기초 지식을 테스트합니다');

-- Java 문제
MERGE INTO QUIZ_QUESTION (question_id, topic_id, question_text, option1, option2, option3, option4, correct_answer) KEY(question_id) VALUES
(1, 1, 'Java에서 기본 자료형(primitive type)이 아닌 것은?', 'int', 'double', 'String', 'boolean', 3),
(2, 1, 'Java에서 상속을 나타내는 키워드는?', 'implements', 'extends', 'inherit', 'super', 2),
(3, 1, '다음 중 Java의 접근 제어자가 아닌 것은?', 'private', 'protected', 'default', 'package', 4),
(4, 1, 'Java 인터페이스의 메서드는 기본적으로 무엇인가?', 'public abstract', 'private', 'protected', 'static', 1),
(5, 1, '다음 중 Garbage Collection에 대한 설명으로 옳은 것은?', '프로그래머가 직접 호출해야 한다', '더 이상 참조되지 않는 객체를 자동으로 제거한다', '메모리를 직접 할당한다', '컴파일 타임에 실행된다', 2);

-- 데이터베이스 문제
MERGE INTO QUIZ_QUESTION (question_id, topic_id, question_text, option1, option2, option3, option4, correct_answer) KEY(question_id) VALUES
(6, 2, 'SQL에서 데이터를 조회할 때 사용하는 명령어는?', 'INSERT', 'UPDATE', 'SELECT', 'DELETE', 3),
(7, 2, '다음 중 DB 트랜잭션의 특성이 아닌 것은?', '원자성(Atomicity)', '일관성(Consistency)', '속도성(Velocity)', '지속성(Durability)', 3),
(8, 2, '기본 키(Primary Key)의 특징으로 올바른 것은?', 'NULL 값을 허용한다', '중복을 허용한다', 'NULL과 중복을 모두 허용한다', 'NULL과 중복을 모두 허용하지 않는다', 4),
(9, 2, '외래 키(Foreign Key)의 역할은?', '테이블의 유일성을 보장한다', '두 테이블 간의 관계를 정의한다', '인덱스를 생성한다', '데이터 타입을 정의한다', 2),
(10, 2, 'SQL에서 조건 검색을 위해 사용하는 구문은?', 'WHERE', 'HAVING', 'BOTH', 'FILTER', 1);

-- 웹 개발 문제
MERGE INTO QUIZ_QUESTION (question_id, topic_id, question_text, option1, option2, option3, option4, correct_answer) KEY(question_id) VALUES
(11, 3, '다음 중 웹 페이지의 구조를 정의하는 언어는?', 'HTML', 'CSS', 'JavaScript', 'SQL', 1),
(12, 3, 'HTTP 요청 메서드 중 데이터를 생성(Create)할 때 사용하는 것은?', 'GET', 'POST', 'PUT', 'DELETE', 2),
(13, 3, 'Servlet의 생명주기 메서드가 아닌 것은?', 'init()', 'service()', 'destroy()', 'start()', 4),
(14, 3, 'CSS에서 아이디 선택자를 나타내는 기호는?', '.', '#', '@', '&', 2),
(15, 3, 'JSP에서 다른 페이지로 이동할 때 사용하는 액션 태그는?', 'jsp:include', 'jsp:forward', 'jsp:param', 'jsp:useBean', 2);

-- 알고리즘 문제
MERGE INTO QUIZ_QUESTION (question_id, topic_id, question_text, option1, option2, option3, option4, correct_answer) KEY(question_id) VALUES
(16, 4, '다음 중 시간 복잡도가 O(n²)인 정렬 알고리즘은?', '퀵 정렬', '병합 정렬', '버블 정렬', '힙 정렬', 3),
(17, 4, '스택(Stack) 자료구조의 특징은?', 'FIFO(선입선출)', 'LIFO(후입선출)', '랜덤 접근', '양방향 접근', 2),
(18, 4, '이진 탐색(Binary Search)의 전제 조건은?', '데이터가 내림차순으로 정렬되어 있어야 한다', '데이터가 정렬되어 있어야 한다', '데이터가 중복되지 않아야 한다', '데이터가 연결 리스트여야 한다', 2),
(19, 4, '큐(Queue) 자료구조의 특징은?', 'FIFO(선입선출)', 'LIFO(후입선출)', '랜덤 접근', '우선순위 기반 접근', 1),
(20, 4, '재귀 함수의 필수 요소가 아닌 것은?', '기저 조건(Base case)', '자기 자신 호출', '반복문', '종료 조건', 3);

-- 네트워크 문제
MERGE INTO QUIZ_QUESTION (question_id, topic_id, question_text, option1, option2, option3, option4, correct_answer) KEY(question_id) VALUES
(21, 5, 'TCP의 특징이 아닌 것은?', '연결 지향적이다', '데이터 전송을 보장한다', '비연결 지향적이다', '흐름 제어를 지원한다', 3),
(22, 5, 'HTTP의 기본 포트 번호는?', '21', '80', '443', '8080', 2),
(23, 5, 'DNS의 역할은?', 'IP 주소를 자동으로 할당한다', '도메인 이름을 IP 주소로 변환한다', '데이터를 암호화한다', '라우팅 테이블을 관리한다', 2),
(24, 5, 'OSI 7계층 중 데이터 링크 계층의 주요 기능은?', '라우팅', '세션 관리', '오류 검출 및 프레임 전송', '데이터 암호화', 3),
(25, 5, 'IP 프로토콜의 주요 역할은?', '데이터 신뢰성 보장', '패킷의 목적지까지 경로 설정 및 전달', '애플리케이션 간 통신', '물리적 신호 전송', 2);
