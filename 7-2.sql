SET GLOBAL log_bin_trust_function_creators = 1;

-- use SOTRED FUNCTION

-- 1) 숫자 2개의 합계를 계산하는 함수
USE market_db;
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)
	RETURNS INT
BEGIN
	RETURN number1 + number2;
END $$
DELIMITER ;

SELECT sumFunc(100,200) AS '합계';

-- 2) 데뷔연도를 입력하면, 활동기간이 얼마나 되었는지 출력해주는 함수 
DROP FUNCTION IF EXISTS calcYearFunc;
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT) -- 데뷔연도를 parameter로 받음
	RETURNS INT
BEGIN
	DECLARE runYear INT;
    SET runYear = YEAR(CURDATE()) - dYear;
	RETURN runYear;
END $$
DELIMITER ;

SELECT calcYearFunc(2010) AS '활동 횃수';

-- 함수의 반환값을 각 변수에 저장한 후, 그 차이를 계산해서 출력
SELECT calcYearFunc(2007) INTO @debut2007;
SELECT calcYearFunc(2013) INTO @debut2013;
SELECT @debut2007-@debut2013 AS '2007과 2013 차이';
-- member 테이블에서 모든 회원이 데뷔한지 몇년 되었는지 조회
SELECT mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 횃수'
	FROM member;

-- 함수 삭제
DROP FUNCTION calcYearFunc;

-- -------------------------------------------------------
-- 커서의 단계별 실습 

USE market_db;
DROP PROCEDURE IF EXISTS cursor_proc;
DELIMITER $$
CREATE PROCEDURE cursor_proc()
BEGIN
	-- 1) 사용할 변수 준비하기
	DECLARE memNumber INT;
	DECLARE cnt INT DEFAULT 0; -- DEFAULT 이용해 초기값을 0으로 설정
	DECLARE totNumber INT DEFAULT 0;
	DECLARE endofrow BOOLEAN DEFAULT FALSE; -- 처음에는 당연히 행의 끝이 아닐테니 FALSE로 초기화

	-- 2) 커서 선언 
	DECLARE memberCuror CURSOR FOR -- 커서라는 것은 결국 select문		
		SELECT mem_number FROM member; -- member을 조회하는 구문을 커서로 만들어 놓으면 됨 (memberCursor)
			
	-- 3) 반복 조건 선언
	-- 행이 끝나면 더이상 반복하지 않도록 설정 
	-- 행의 끝에 다다르면 선언한 endofrow 변수를 TRUE로 설정       
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endofrow = TRUE;

	-- 4) 커서 열기 
	OPEN memberCuror;
    
    -- 5) 행 반복하기 
    cursor_loop: LOOP
		FETCH memberCuror INTO memNumber; -- FETCH는 한 행씩 읽어오는 것        
        IF endofrow THEN		-- 행의 끝에 다다르면 반복 조건을 선언한 3)에 의해서 endofrow 가 TRUE로 변경되고 
			LEAVE cursor_loop;	-- 반복하는 부분을 빠져나감
		END IF;
        
        SET cnt = cnt + 1;
        SET totNumber = totNumber + memNumber;
	
    END LOOP cursor_loop;
    
    SELECT (totNumber/cnt) AS '회원의 평균 인원 수';
    
    CLOSE memberCuror; -- 커서 닫기
    
END $$
DELIMITER ;

CALL cursor_proc();

