-- INDEX
-- PROS ------
-- 1) SELECT 문으로 검색하는 속도가 매우 빨라짐 
-- 2) 그 결과 컴퓨터의 부담이 줄어들어 전체 시스템의 성능이 향상됨
-- CONS ------
-- 1) 인덱스도 공간을 차지하여 데이터베이스 안에 추가적인 공간이 필요함 
-- 2) 처음에 인덱스를 만드는데 시간이 오래걸릴 수 있음 
-- 3) SELECT가 아닌 변경 작업 INSERT, UPDATE, DELETE가 자주 일어나면 성능이 나빠질 수 있음

-- INDEX TYPE 
-- 1) CLUSTERED INDEX (like an English dictionary) 
--  alphabetiacal order
USE market_db;
CREATE TABLE table1(
col1	INT PRIMARY KEY,
col2	INT,
col3	INT);

SHOW INDEX FROM table1; 
-- primary is written in 'key_name' :: 기본키로 설정해서 새성된 인덱스라는 뜻
-- > 클러스터형 인덱스 
-- Non_unique = 0 :: index is unique

CREATE TABLE table2(
col1 INT PRIMARY KEY,
col2 INT UNIQUE,
col3 INT UNIQUE);

SHOW INDEX FROM table2;
-- key_name 에 열이름이 써있는 것은 보조 인덱스 

USE market_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
(mem_id		CHAR(8),
mem_name	VARCHAR(10),
mem_number	INT,
addr		CHAR(2));

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN','여자친구',6,'경기');
INSERT INTO member VALUES('OMY','오마이걸',7,'서울');
SELECT*FROM member;

ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY(mem_id);
SELECT*FROM member;
-- 클러스형 인덱스가 생성된 열로 데이터가 자동정렬됨 (알파벳순)
SHOW INDEX FROM member;

-- 인덱스 변경하기 
ALTER TABLE member DROP PRIMARY KEY;
ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY(mem_name);
SHOW INDEX FROM member;

-- 인덱스 추가하기 
INSERT INTO member VALUES('BB','빅뱅',5,'서울');
SELECT*FROM member; -- 인덱스 기준에 맞춰서 자동으로 추가됨 

-- only ONE clustered index can be creased in the table
-- which is same as the only a SINGLE primary key exists in the table

-- 정렬되지 않은 보조 인덱스
DROP TABLE IF EXISTS member;
CREATE TABLE member
(mem_id		CHAR(8),
mem_name	VARCHAR(10),
mem_number	INT,
addr		CHAR(2));

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN','여자친구',6,'경기');
INSERT INTO member VALUES('OMY','오마이걸',7,'서울');
SELECT*FROM member;

ALTER TABLE member
	ADD CONSTRAINT 
    UNIQUE (mem_id);
SELECT*FROM member; -- 순서 불변 

ALTER TABLE member
	ADD CONSTRAINT 
    UNIQUE (mem_name);
SELECT*FROM member; -- 순서 불변 

INSERT INTO member VALUES('BB','빅뱅',6,'설');
SELECT*FROM member; -- 순서 불변 (가장 뒤에 추가될뿐)
-- 보조 인덱스 만들때마다 데이터베이스 공간을 차지하므로, 꼭 필요한 열에만 생성하는 것이 중요


-- 2) SECONDARY INDEX (like index in the end of the book)