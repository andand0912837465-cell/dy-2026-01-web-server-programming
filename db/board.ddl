DROP TABLE IF EXISTS BOARD;

CREATE TABLE IF NOT EXISTS BOARD (
    board_no INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    reply_content TEXT,
    status VARCHAR(20) DEFAULT '답변대기' NOT NULL,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- BOARD 테이블의 자동 증가 번호를 다시 1번부터 시작하도록 리셋합니다.
ALTER TABLE BOARD ALTER COLUMN board_no RESTART WITH 1;



INSERT INTO BOARD (user_id, category, title, content, status)
VALUES ('admin', '배송', '잘 만들어졌나 테스트', '성공?', '답변대기');
INSERT INTO BOARD (user_id, category, title, content, status)
VALUES ('User01', '기타', '잘 만들어졌나 테스트', '성공?', '답변완료');