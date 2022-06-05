-- STORED PROCEDURE
USE market_db;
DROP PROCEDURE IF EXISTS user_proc;
DELIMITER $$
CREATE PROCEDURE user_proc()
BEGIN
	SELECT*FROM member;
END $$
DELIMITER ;

CALL user_proc();
DROP PROCEDURE user_proc; -- 삭제

-- Input PARAMETER 활용 (하나일때)
USE market_db;
DROP PROCEDURE IF EXISTS user_proc1;
DELIMITER $$
CREATE PROCEDURE user_proc1(IN userName VARCHAR(10))
BEGIN
	SELECT*FROM member WHERE mem_name = userName;
END $$
DELIMITER ;

CALL user_proc1('에이핑크');

-- (두개일때)
DROP PROCEDURE IF EXISTS user_proc2;
DELIMITER $$
CREATE PROCEDURE user_proc2(
	IN userNumber INT,
    IN userHeight INT )
BEGIN
	SELECT * FROM member
		WHERE mem_number > userNumber AND height > userHeight;
END $$
DELIMITER ;

CALL user_proc2(6, 165);

-- output PARAMETER 의 활용
-- STORED PROCEDURE 만드는 시점에서는 아직 존재하지 않는 테이블을 사용해도됨  
-- but, CALL로 실행하는 시점에는 사용한 테이블이 있어야함 

DROP PROCEDURE IF EXISTS user_proc3;
DELIMITER $$
CREATE PROCEDURE user_proc3(
	IN txtValue CHAR(10),
    OUT outValue INT)
BEGIN
	INSERT INTO noTable VALUES(NULL, txtValue);
    SELECT MAX(id) INTO outValue FROM noTable;
END $$
DELIMITER ;

DESC noTable; -- 테이블 구조 확인
    
CREATE TABLE IF NOT EXISTS noTable(
	id INT AUTO_INCREMENT PRIMARY KEY,
    txt CHAR(10)
);

CALL user_proc3('테스트1', @myValue);
SELECT CONCAT('입력된 ID 값 ==>', @myValue);

-- SQL programming Application 
DROP PROCEDURE IF EXISTS ifelse_proc;
DELIMITER $$
CREATE PROCEDURE ifelse_proc(
	IN memName VARCHAR(10) -- input parameter 선언 
)BEGIN
	DECLARE debutYear INT; -- debutYear 변수 선언
	SELECT YEAR(debut_date) into debutYear FROM member
		WHERE mem_name = memName; -- year()함수를 통해 연도만 추출해서 변수에 저장
	IF (debutYear >= 2015) THEN
		SELECT '신인가수' AS '메시지'; -- 데뷔 연도에 따라 다른 메시지 전달
	else
		SELECT '고참' AS '메시지';
	END IF;
END $$
DELIMITER ;

CALL ifelse_proc('오마이걸');

-- using WHILE , sum 1 ~ 100
DROP PROCEDURE IF EXISTS while_proc;
DELIMITER $$
CREATE PROCEDURE while_proc()
BEGIN
	DECLARE hap INT; -- 합계 변수
    DECLARE num INT; -- 1부터 100까지 증가하는 변수
    SET hap = 0; -- 합계 초기화
    SET num = 1;
    
    WHILE (num <= 100) DO -- 100까지 반복
		SET hap = hap + num;
        SET num = num + 1; -- 숫자 증가
	END WHILE;
    SELECT hap AS '1~100까지 합계';
END $$
DELIMITER ;

CALL while_proc();

-- Dynamic SQL
DROP PROCEDURE IF EXISTS dynamic_proc;
DELIMITER $$
CREATE PROCEDURE dynamic_proc(
	IN tableName VARCHAR(20)
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT*FROM', tableName);
    PREPARE myQuery FROM @sqlQuery;
    EXECUTE myQuery;
    DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL dynamic_proc('member');