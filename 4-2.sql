-- JOIN (= INNER JOIN)
USE market_db;
SELECT *
	FROM buy
    INNER JOIN member
    ON buy.mem_id = member.mem_id
WHERE buy.mem_id = 'BLK';

SELECT * 
	FROM buy
		INNER JOIN member
        ON buy.mem_id = member.mem_id;

-- this includes error as 'mem_id' is included in both tables
SELECT mem_id, mem_name, prod_name, addr, CONCAT(phone1,phone2) '연락처'
	FROM buy
		INNER JOIN member
		ON buy.mem_id = member.mem_id;
-- this is correct 
SELECT buy.mem_id, mem_name, prod_name, addr, CONCAT(phone1,phone2) '연락처'
	FROM buy
		INNER JOIN member
		ON buy.mem_id = member.mem_id;
        
-- using alias(B,M) of tables to make it simple
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr,
				CONCAT(M.phone1, M.phone2) '연락처'
	 FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id;

SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	ORDER BY B.mem_id;
    
-- having only one result from reapeated results 'distinct'
SELECT DISTINCT M.mem_id, M.mem_name, M.addr
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	ORDER BY M.mem_id;
    
-- ------------------------------------------
-- OUTER JOIN :: 한쪽 테이블에만 있는 내용도 출력
-- ------------------------------------------
-- LEFT OUTER JOIN
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
	FROM member M
		LEFT OUTER JOIN buy B -- LEFT OUTER JOIN == LEFT JOIN
        ON M.mem_id = B.mem_id
	ORDER BY M.mem_id;
-- LEFT OUTER JOIN means "all contents in the left table 'member' should be included"
-- ------------------------------------------
-- RIGHT OUTER JOIN
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
	FROM buy B -- tables are joined based on the 'right table B'
		RIGHT OUTER JOIN member M
        ON M.mem_id = B.mem_id
	ORDER BY M.mem_id;

-- application
-- 회원으로 가입만 하고, 한번도 구매한 적 없는 회원의 목록을 추출함 
SELECT DISTINCT M.mem_id, B.prod_name, M.mem_name, M.addr
	FROM member M
		LEFT OUTER JOIN buy B
        ON M.mem_id = B.mem_id
	WHERE B.prod_name IS NULL
    ORDER BY M.mem_id;

-- extra 
-- 1) cross join 
-- 		한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인시키는 기능 
-- 		(결과, 전체 행수는 두 테이블의 각 행수를 곱한 개수가 됨)
SELECT * 
	FROM buy
		CROSS JOIN member;
        
-- 2) self join 
-- 		자체 조인은 하나의 테이블에 서로 다른 별칭을 붙여서 조인하는 것 
