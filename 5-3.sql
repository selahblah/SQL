USE market_db;
SELECT mem_id, height FROM member;

-- view 
CREATE VIEW v_member
AS 
	SELECT mem_id, height FROM member;

SELECT*FROM v_member;
SELECT mem_id FROM v_member
	WHERE height IN (164,166,167);
    
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr,
				CONCAT(M.phone1, M.phone2) '연락처'
	 FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id;
-- 복잡한 위 쿼리를 뷰로 생성해놓고 쉽게 접근하도록 만들기
CREATE VIEW v_memberbuy
AS
	SELECT B.mem_id, M.mem_name, B.prod_name, M.addr,
					CONCAT(M.phone1, M.phone2) '연락처'
		 FROM buy B
			INNER JOIN member M
			ON B.mem_id = M.mem_id;

SELECT*FROM v_memberbuy WHERE mem_name = '블랙핑크';

-- view 실제 생성, 수정, 삭제
USE market_db;
CREATE VIEW v_viewtest1
AS
	SELECT B.mem_id AS 'MEMBER ID', M.mem_name AS 'MEMBER NAME', B.prod_name AS 'PRODCUT NAME',
					CONCAT(M.phone1, M.phone2) AS '연락처' -- AS 를 alias앞에 붙여 코드를 명확하게 보이도록 할 수 있음
		 FROM buy B
			INNER JOIN member M
			ON B.mem_id = M.mem_id;
            
SELECT `MEMBER ID`, `MEMBER NAME` FROM v_viewtest1;
SELECT DISTINCT `MEMBER ID`, `MEMBER NAME` FROM v_viewtest1; -- 백틱 사용

-- 뷰 수정 
ALTER VIEW v_viewtest1
AS 
	SELECT B.mem_id AS '회원아이디', M.mem_name AS '회원이름', B.prod_name AS '제품이름',
					CONCAT(M.phone1, M.phone2) AS '연락처' -- AS 를 alias앞에 붙여 코드를 명확하게 보이도록 할 수 있음
		 FROM buy B
			INNER JOIN member M
			ON B.mem_id = M.mem_id;
 SELECT DISTINCT `회원아이디`, `회원이름` FROM v_viewtest1;
 
 -- 뷰 삭제
 DROP VIEW v_viewtest1;
 
-- 뷰 정보 확인
USE market_db;
CREATE OR REPLACE VIEW v_viewtest2
AS
		SELECT mem_id, mem_name, addr FROM member;

DESCRIBE v_viewtest2; -- it's without pk
DESCRIBE member; -- with pk

SHOW CREATE VIEW v_viewtest2;
-- 뷰를 통한 데이터의 수정/삭제
UPDATE v_member SET height = '166' where mem_id = 'BLK';

--  지정 범위로 뷰 설정
CREATE VIEW v_height166
AS
		SELECT*FROM member WHERE height<= 167;

SELECT * FROM v_height166;

DELETE FROM v_height167 WHERE height <167;
INSERT INTO v_height167 VALUES('BB', '방', 6, '서울', NULL, NULL, 166, '2019-07-22');

-- COMPLEX VIEW :: 두개 이상의 테이블로 뷰 만들기 
CREATE VIEW v_complex
AS
		SELECT B.mem_id, M.mem_name, B.prod_name, M.addr
			FROM buy B
				INNER JOIN member M
                ON B.mem_id = M.mem_id;
-- 복합뷰를 통해 테이블에 데이터를 입력, 수정, 삭제 불가

-- 뷰가 참조하는 테이블 삭제 
DROP TABLE IF EXISTS buy, member;
SELECT*FROM v_height167; -- 참조하는 테이블이 없으므로 조회 불가 

CHECK TABLE v_height167; -- 뷰가 참조하는 테이블이 삭제되어 오류가 발생하는것으로 확인됨