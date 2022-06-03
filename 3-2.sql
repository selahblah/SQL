-- order by
SELECT mem_id, mem_name, debut_date
	FROM member
    ORDER BY debut_date;
-- dsc 내림차순 (default: asc)
SELECT mem_id, mem_name, debut_date
	FROM member
    ORDER BY debut_date DESC;
SELECT mem_id, mem_name, debut_date, height
	FROM member
    WHERE height >= 164
    ORDER BY height DESC;
-- 기준 2개 설정함 // height가 동일할경우, asc 오름차순 기준
SELECT mem_id, mem_name, debut_date, height
	FROM member
    WHERE height >= 164
    ORDER BY height DESC, debut_date ASC;
-- LIMIT (출력 갯수 제한)
-- print 3 rows
SELECT *
	FROM member
    LIMIT 3;
-- 데뷔 일자가 빠른 3건만 뽑기
SELECT * 
	FROM member
    ORDER BY debut_date ASC
    LIMIT 3;
-- sort by height, but get 2-data from the third row
SELECT *
 	FROM member
    ORDER BY height DESC
    LIMIT 3, 2;
-- -------------------------------------
-- DISTINCT // delete the repeated data
SELECT addr FROM member ORDER BY addr;
SELECT DISTINCT addr FROM member;
-- -------------------------------------
-- GROUP BY
SELECT mem_id, amount FROM buy ORDER BY mem_id;
-- sum AMOUNT by mem_id 
SELECT mem_id, SUM(amount) FROM buy GROUP BY mem_id;
-- changing col names
SELECT mem_id "회원 아이디", SUM(amount) "총 구매 개수"
	FROM buy GROUP BY mem_id;
SELECT mem_id "회원 아이디", SUM(amount*price) "총 구매 개수" 
	FROM buy GROUP BY mem_id;
SELECT AVG(amount) "평균 구매 개수" FROM buy;
SELECT mem_id, AVG(amount) "평균 구매 개수"
	FROM buy
    GROUP BY mem_id;
-- -------------------------------------
-- count
-- count(*) 는 모든 행의 개수 셈
-- count(열이름)은 열 이름의 값이 NULL인것을 제외한 행의 개수를 셈
SELECT COUNT(*) FROM member;
SELECT COUNT(phone1) "연락처가 있는 사람" FROM member;
-- -------------------------------------
-- having 
-- 집계 함수에 대해서 조건을 제한함
-- having 절은 group_by 다음에 와야함

-- -- error -- 
-- SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
-- 	FROM buy
--    WHERE SUM(price*amount) > 1000
--    GROUP BY mem_id;
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
	FROM buy
    GROUP BY mem_id
    HAVING SUM(price*amount) > 1000;
SELECT mem_id "회원 아이디", SUM(price*amount) "총 구매 금액"
	FROM buy
    GROUP BY mem_id
    HAVING SUM(price*amount) > 1000
    ORDER BY SUM(price*amount) DESC;
    
