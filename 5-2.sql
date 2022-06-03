DROP DATABASE IF EXISTS naver_db;
CREATE DATABASE naver_db;

USE naver_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member
(mem_id		CHAR(8) NOT NULL PRIMARY KEY,
mem_name	VARCHAR(10) NOT NULL,
mem_number	TINYINT NOT NULL,
addr		CHAR(2) NOT NULL,
phone1		CHAR(3) NULL,
phone2		CHAR(8) NULL,
height		TINYINT UNSIGNED NULL,
debut_date	DATE NULL
);

DROP TABLE IF EXISTS buy;
CREATE TABLE buy
(num		INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id		CHAR(8) NOT NULL,
prod_name	CHAR(6) NOT NULL,
group_name	CHAR(4)	NULL,
price		INT UNSIGNED NULL,
amount		SMALLINT UNSIGNED NULL,
FOREIGN KEY (mem_id) REFERENCES member(mem_id)
-- 마지막 열 :: 이테이블의 mem_id 열을 member테이블의 mem_id열과 외래키 관계로 연결해라
);

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '1111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055','2222222', 163, '2016-8-8');
INSERT INTO member VALUES('WMN','여자친구',6,'경기','031','3333333',166, '2015-1-15');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑',NULL,30,2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로','디지털',1000,1);
--  error :: APN은 아직 member 테이블에 존재하지 않아서 오류가 발생
INSERT INTO buy VALUES(NULL, 'APN','아이폰','디지털',200,1);

DESCRIBE member; -- info of the table
-- ----------------------------------------------
-- primary key 기본키 
-- ----------------------------------------------
-- 1) CREATE TABLE의 마지막 행에 PRIMARY KEY(mem_id) 추가
-- 2) CREATE TABLE 이후, ALTER TABLE에서 ..

-- ALTER TABLE member
-- 	ADD CONSTRAINT
--  PRIMARY KEY (mem_id)
    
-- ----------------------------------------------
-- foreign key 외래키
-- ----------------------------------------------
-- member table (primary key) & buy table (foreign key)
-- The table with the foreign key is called the "child table", 
-- and the table with the primary key is called the "referenced or parent table"
-- * all the foreign key should be included in primary key
-- * primary key is unique 

-- 1) CREATE TABLE의 마지막 행에 FOREIGN KEY (mem_id) REFERENCES member(mem_id) 추가
-- 2) ALTER TABLE 에서.. 

-- ALTER TABLE buy
-- 	ADD CONSTRAINT
-- 	FOREIGN KEY(mem_id) REFERENCES member(mem_id);

USE naver_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
(mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL
);
CREATE TABLE buy
(num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
user_id CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL,
FOREIGN KEY(user_id) REFERENCES member(mem_id)
); -- child table의 아이디 열 이름이 parent table의 아이디 열 이름과 동일해야하는것은 아님! 

INSERT INTO member VALUES('sg', '에스지', 170);
INSERT INTO buy VALUES(NULL, 'sg','빵');
INSERT INTO buy VALUES(NULL, 'sg','초코송이');

SELECT*FROM member;
SELECT*FROM buy;

SELECT M.mem_id, M.mem_name, B.prod_name
	FROM buy B
		INNER JOIN member M
        ON B.user_id = M.mem_id;

UPDATE member SET mem_id = 'wannabe' WHERE mem_id = 'sg';
-- primary key - foreign key 관계 맺은 후, parent table 의 열 이름이 변경되지 않음 

DELETE FROM member WHERE mem_id = 'sg';
-- primary key - foreign key 관계 맺은 후, parent table 의 열은 삭제되지 않음

-- SOLUTION :: ON UPDATE CASCADE & ON DELETE CASCADE
DROP TABLE IF EXISTS buy;
CREATE TABLE buy
(num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id		CHAR(8) NOT NULL,
prod_name	CHAR(6) NOT NULL
);
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id) REFERENCES member(mem_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
-- ON UPDATE CASCADE 통해 자동으로 변경 
-- ON DELETE CASCADE 은 parent table의 데이터가 삭제되면 child table의 데이터도 삭제되는 기능 

INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');
UPDATE member SET mem_id = 'PINK' WHERE mem_id = 'BLK';
INSERT INTO memeber VALUES('OK','오키',165);

