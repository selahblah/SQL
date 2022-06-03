-- IF 
DROP PROCEDURE IF EXISTS ifProc1; -- 기존의 ifProc1 이 있으면 삭제
DELIMITER $$					-- ;으로는 SQL의 끝인지 stored procedure의 끝인지 알수 없어 $$ 사용
CREATE PROCEDURE ifProc1()
BEGIN
	IF 100 = 100 THEN
		SELECT '100은 100과 같습니다';
	END IF;
END $$
DELIMITER ;
CALL ifProc1(); 				-- CALL을 통해 ifProc1()이 시행됨 
-- ----------------------------------------------------
-- IF ~ ELSE
DROP PROCEDURE IF EXISTS ifProc2;
DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE myNum INT;		-- declare 통해 myNum 변수 선언 
    SET myNum = 200;		-- set 통해 myNum 변수에 200 대입
    IF myNum = 100 THEN
		SELECT '100입니다';
	ELSE 
		SELECT '100이 아닙니다';
	END IF;
END $$
DELIMITER ;
CALL ifProc2();
-- application (IF)
DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE debutDate DATE; -- 데뷔일자
    DECLARE curDate DATE; -- 오늘
    DECLARE days INT; -- 활동한 일수
    
    SELECT debut_date INTO debutDate -- INTO 를 통해, 데뷔일자가 debutDate 에 저장됨
		FROM market_db.member
        WHERE mem_id = 'APN';
	
    SET curDATE = CURRENT_DATE(); -- 현재날짜
    SET days = DATEDIFF(curDATE, debutDate); -- 날짜의 차이, 일 단위
    
    IF (days/365) >= 5 THEN -- 5 년이 지났다면
		SELECT CONCAT('벌써 데뷔한지', days, '일이 지남');
	ELSE
		SELECT '데뷔한지' + days + '일밖에 안됨';
	END IF;
END $$
DELIMITER ; 
CALL ifProc3();

-- ----------------------------------------------------
-- CASE :: 여러가지 조건중에서 선택해야 하는 경우 
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 88;
    
    CASE 
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		ELSE 
			SET credit = 'F';
	END CASE;
    SELECT CONCAT('취득점수 ==>', point), CONCAT('학점 ==>', credit);
END $$
DELIMITER ;
CALL caseProc();

-- application (CASE)
SELECT mem_id, SUM(price*amount) "총구매액"
	FROM buy
    GROUP BY mem_id;
    
SELECT mem_id, SUM(price*amount) "총구매액"
	from buy
    GROUP BY mem_id
    ORDER BY SUM(price*amount) DESC; -- 총 구매액이 많은 순서로 정렬
    
-- 회원의 이름도 출력해보기 but 회원이름은 member 에 있음 --> join
SELECT B.mem_id, M.mem_name, SUM(price*amount) "총구매액"
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY B.mem_id
    ORDER BY SUM(price*amount) DESC;

-- 구매하지 않은 회원의 아이디와 이름도 출력하기 
SELECT M.mem_id, M.mem_name, SUM(price*amount) "총구매액"
	FROM buy B
		RIGHT OUTER JOIN member M
        ON M.mem_id = B.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;
-- ------------------------------ new column is added
SELECT M.mem_id, M.mem_name, SUM(price*amount) "총구매액",
	CASE 
		WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
		WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
        WHEN (SUM(price*amount) >= 1) THEN '일반고객'
        ELSE '유령고객'
	END "회원등급"
    FROM buy B
		RIGHT OUTER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;

-- ----------------------------------------------------
-- while 
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT; -- 1에서 100까지 증가할 변수
    DECLARE HAP INT; -- 더한 값을 누적할 변수
    SET i = 1;
    SET hap = 0;
    
    WHILE (i <= 100) DO
		SET hap = hap + i;
		SET i = i+1;
	END WHILE;
    SELECT '1부터 100까지의 합 ==>', hap;
END $$
DELIMITER ; 
CALL whileProc();
-- application (while)
DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
    
    myWhile:
    WHILE (I<=100) DO
		IF (i%4 = 0) THEN
			SET i = i+1;
            ITERATE myWhile;
		END IF;
        SET hap = hap + i;
        IF (hap>1000) THEN
			LEAVE myWhile;
		END IF;
        SET i = i+1;
	END WHILE;
    
    SELECT '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 =>', hap;
END $$
DELIMITER ;
-- 
