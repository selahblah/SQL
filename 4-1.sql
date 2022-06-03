USE market_db;
CREATE TABLE hongong4(
	tinyint_col TINYINT,
    smallint_col SMALLINT,
    int_col INT,
    bigint_col BIGINT);

INSERT INTO hongong4 VALUES(127, 32767, 2146864890,90000000000000000);

-- INT
-- -------------------------------------
-- TINYINT		-128 ~ 127
-- SMALLINT		-32768 ~ 32767
-- INT			약 -21억 ~ + 21억
-- BIGINT		약 -900경 ~ +900경

-- TINYINT UNSIGNED 정수형에 unsigned를 붙이면 범위가 0부터 지정됨
-- ---------------------------------------------------------------
-- STRINGS
-- -------------------------------------
-- CHAR			1 ~ 255 -- 글자의 개수가 고정된 경우
-- VARCHAR		1 ~ 16383 -- 글자의 개수가 변동될 경우

-- 데이터가 숫자 형태라도 연산이나 크기에 의미가 없다면, 문자형으로 지정하는것이 좋음 
-- ex. 전화번호
-- ---------------------------------------------------------------
-- STRONG BIG DATA
-- -------------------------------------
-- TEXT 형식
-- TEXT / LONGTEXT
-- BLOB (video , photo) 형식
-- BLOB / LONGBLOB
-- -------------------------------------
-- REAL TYPE 실수형
-- FLOAT 4 BYTE 소수점 7자리까지 표현
-- DOUBLE 8 BYTE 소수점 아래 15자리까지 표현
-- --------------------------------------
-- 날짜형 
-- DATE		YYYY-MM-DD
-- TIME		HH:MM:SS
-- DATETIME YYYY-MM-DD HH:MM:SS (DATE, TIME 모두 저장시)


-- USING VARIABLES
USE market_db;
SET @myVar1 = 5; -- 변수 선언
SET @myVar2 = 4.25;

SELECT @myVar1;
SELECT @myVar1 + @myVar2;

SET @txt = '가수이름=';
SET @height = 166;
SELECT @txt, mem_name FROM member WHERE height > @height;

-- variables can't be used for LIMIT 
-- >> PREPARE, EXECUTE (solution)
SET @count = 3;
PREPARE mySQL FROM 'SELECT mem_name, height FROM member ORDER BY height LIMIT?';
EXECUTE mySQL USING @count;
-- same as above
SELECT mem_name, height FROM member ORDER BY height LIMIT 3;

-- TYPE CONVERSION 
-- ---- EXPLICIT CONVERSION & IMPLICIT CONVERSION 
-- -------------------------------------
-- 1) EXPLICIT CONVERSION ( CAST(), CONVERT() )
-- -------------------------------------
SELECT AVG(price) AS '평균 가격' FROM buy; -- output as real type
SELECT CAST(AVG(price) AS SIGNED) '평균 가격' FROM buy; -- output as INT
SELECT CONVERT(AVG(price) , SIGNED) '평균 가격' FROM buy; -- same as above

SELECT CAST('2022$12$12' AS DATE);
SELECT CAST('2022/12/12' AS DATE);
SELECT CAST('2022%12%12' AS DATE);
SELECT CAST('2022@12@12' AS DATE);

SELECT num, CONCAT(CAST(price AS CHAR), 'X', CAST(amount AS CHAR), '=')
		'가격X수량', price*amount '구매액'
        FROM buy; -- 여기서 CONCAT()은 문자를 이어주는 역할
-- -------------------------------------
-- 2) INPLICIT CONVERSION
-- -------------------------------------
SELECT '100'+'200';
SELECT CONCAT(100,200); -- by using CONCAT, numbers are changed to strings 

