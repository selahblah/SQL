-- create and delete INDEX
USE market_db;
SELECT*FROM member;
SHOW INDEX FROM member; -- only one clustered index, 'mem_id'
SHOW TABLE STATUS LIKE 'member'; 
-- index_length == 보조인덱스 크기 but 보조 인덱스가 없으므로 표기x

-- CREATE SECONDARY INDEX 
CREATE INDEX idx_member_addr
	ON member(addr); -- member 테이블의 addr열에 지정된 인덱스

SHOW INDEX FROM member; 
-- non_unique 1 :: 고유 보조 인덱스가 아니라는 것 :: 중복된 데이터 허용

SHOW TABLE STATUS LIKE 'member';
-- index_length 가 보조 인덱스 크기인데, 크기가 0 (이상함)
-- 생성한 인덱스를 실제로 적용시키려면 ANALYZE TABLE 문으로 먼저 테이블을 분석/처리해야함
ANALYZE TABLE member;
SHOW TABLE STATUS LIKE 'member'; -- index_length 더이상 0이 아님

CREATE UNIQUE INDEX idx_member_number
	ON member (mem_number);
-- unique index with mem_number can't be created since mem_number includes repeated values

CREATE UNIQUE INDEX idx_mem_name
	ON member (mem_name); -- mem_name is unique
    
SHOW INDEX FROM member;
SELECT*FROM member;

SELECT mem_id, mem_name, addr FROM member; -- got an output without using an index

SELECT mem_id, mem_name, addr
	FROM member
    WHERE mem_name = '에이핑크'; -- using an index 
-- index is used only when the col name is included in WHERE ~

CREATE INDEX idx_member_mem_number
	ON	member (mem_number); -- making a secondary index
ANALYZE TABLE member;

SELECT mem_name, mem_number
	FROM	member
    WHERE	mem_number >= 7; -- using an index

-- ---------------------------------------------
-- 인덱스를 사용하지 않을때 
SELECT mem_name, mem_number
	FROM	member
    WHERE mem_number >= 1; 
-- 인덱스를 사용하는 대신, 전체 테이블 검색함 
-- 인덱스가 있더라도, mysql이 전체 테이블 검색하는 것이 낫겠다고 판단 
-- 이 경우, 대부분의 행을 가져와야하므로 인덱스를 왔다갔다 하는 것보다 테이블을 차례대로 읽는 것이 효율적

SELECT mem_name, mem_number
	FROM member
	WHERE mem_number*2 >= 14; 
-- WHERE 문에 연산이 가해지면, 인덱스를 사용x
-- >> WHERE 문에서는 연산 안하는 것이 좋음

SHOW INDEX FROM member;

-- Delete INDEX -----------------------------------
DROP INDEX idx_mem_name ON member;
DROP INDEX idx_member_addr ON member;
DROP INDEX idx_member_mem_number ON member;

ALTER TABLE member
	DROP PRIMARY KEY; 
-- PRIMARY KEY에 저장된 인덱스는 drop index 로 제거되지 않음
-- ALTER TABLE 문으로만 제거됨 
-- but ERORR 발생
-- >> primary key를 제거하기 전, foreign key와의 관계를 제거해야함 

-- 테이블에는 여러 foreign key가 있을 수 있음 
-- 먼저 foreign key 이름을 알아야함 though information_schema 데이터베이스의 referential_constraints 
SELECT table_name, constraint_name
	FROM information_schema.referential_constraints
	WHERE constraint_schema = 'market_db'; -- foreign key == buy_ibfk_1

ALTER TABLE buy
	DROP FOREIGN KEY buy_ibfk_1;
ALTER TABLE member
	DROP PRIMARY KEY;
    
SHOW INDEX FROM member; -- empty index!!

