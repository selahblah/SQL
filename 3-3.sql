USE market_db;
CREATE TABLE hongong1 (toy_id INT, toy_name CHAR(4), age INT);
INSERT INTO hongong1 VALUES (1, '우디', 25);
INSERT INTO hongong1 (toy_id, toy_name) VALUES (2,'버즈');
INSERT INTO hongong1 (toy_name, age, toy_id) VALUES ('제시',20,3);

-- 자동으로 증가하는 auto_increment
CREATE TABLE hongong2 (
	toy_id INT AUTO_INCREMENT PRIMARY KEY,
    toy_name CHAR(4),
    age INT);
INSERT INTO hongong2 VALUES (NULL, '보핍', 25);
INSERT INTO hongong2 VALUES (NULL, '슬링키', 22);
INSERT INTO hongong2 VALUES (NULL, '렉스', 21);
SELECT * FROM hongong2;

SELECT LAST_INSERT_ID();

-- auto_increment ;; starting from 100
ALTER TABLE hongong2 AUTO_INCREMENT=100; -- alter table 은 테이블을 변경하라는 의미 
INSERT INTO hongong2 VALUES (NULL, '재남', 35); -- null이지만 id 100
INSERT INTO hongong2 VALUES (NULL, '블핑', 30); -- null이지만 id 101

CREATE TABLE hongong3(
toy_id INT AUTO_INCREMENT PRIMARY KEY,
name CHAR(4),
age int);
ALTER TABLE hongong3 AUTO_INCREMENT = 10000;
SET @@auto_increment_increment=3;
--
INSERT INTO hongong3 VALUES (NULL, '토마스', 20);
INSERT INTO hongong3 VALUES (NULL, '제임스', 23);
INSERT INTO hongong3 VALUES (NULL, '블핑', 30);
-- same as above
INSERT INTO hongong3 VALUES (NULL, '고든', 40), (NULL, '램짓',27), (NULL, '버틀', 34);

-- 다른 테이블의 데이터를 한번에 입력 
SELECT COUNT(*) FROM market_db.member;
DESC market_db.member;
CREATE TABLE pop_member (mem_name CHAR(35), mem_number INT);
INSERT INTO pop_member
	SELECT mem_name, mem_number FROM market_db.member;

-- -----------------------------------------------
-- 데이터 수정 update
USE market_db;
UPDATE pop_member
	SET mem_name = 'blackpink'
    WHERE mem_name = '블랙핑크';
SELECT*FROM pop_member WHERE mem_name = 'blackpink';
--
UPDATE pop_member
	SET mem_name = 'blackpink', mem_number = 0
    WHERE mem_name = '블랙핑크';
SELECT * FROM pop_member WHERE mem_name = 'blackpink';
--
-- ----------------------------------------------------
-- 데이터 삭제 :: del
-- if we use 'del' without 'where', all the rows will be removed !!
SELECT * FROM hongong3;
DELETE FROM hongong3
	WHERE name LIKE '%스';
SELECT * FROM hongong3;
--
DELETE FROM hongong3
	WHERE name LIKE '%스'
    LIMIT 1;-- 모두 삭제하는 것이 아니라 상위 1개만 삭제됨
--
-- DELETE 대용량 테이블의 삭제
-- DELETE FROM hongong3; -- 빈테이블 남김
-- DROP TABLE hongong3; -- 테이블 자체 삭제 
-- TRUNCATE TABLE hongong3; -- 빈테이블 남김