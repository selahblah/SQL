-- TRIGGER
-- trigger is automatically executed when INSERT, UPDATE, or DELETE is used
-- by using Trigger, data can be backed up when data is deleted

USE market_db;
CREATE TABLE IF NOT EXISTS trigger_table (id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES(1, '레드벨벳');
INSERT INTO trigger_table VALUES(2, '잇지');
INSERT INTO trigger_table VALUES(3, '블핑');

DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$
CREATE TRIGGER myTrigger -- trigger 생성
	AFTER DELETE -- 이 트리거는 delete문이 발생된 후 작동하라는 의미
    ON trigger_table -- 이 트리거를 부착할 테이블 지정
    FOR EACH ROW -- 각 행마다 적용시킨다는 의미, 트리거에는 거의 항상 써줌
BEGIN
	SET @msg = '가수 그룹이 삭제됨' ; -- 트리거에서 실제로 작동할 부분
END $$
DELIMITER ;

SET @msg = '';
INSERT INTO trigger_table VALUES(4,'마마무');
SELECT @msg; -- DELETE 에만 트기러가 부착되어, 트리거는 작동되지 않아 빈 @msg가 나옴
UPDATE trigger_table SET txt = '블핑' WHERE id = 3;
SELECT @msg; -- UPDATE문 역시 트리거 작동 안함

DELETE FROM trigger_table WHERE id=4;
SELECT @msg;

-- ----------------------------------------
-- 트리거 활용 -------------------------------

USE market_db;
CREATE TABLE singer(SELECT mem_id, mem_name, mem_number, addr FROM member);
-- 아이디, 이름, 인원, 주소 4개 열로 구성된 테이블 singer 로 복사해서 진행 

CREATE TABLE backup_singer
(mem_id		CHAR(8) NOT NULL,
mem_name	VARCHAR(10) NOT NULL,
mem_number	INT NOT NULL,
addr		CHAR(2) NOT NULL,
modType		CHAR(2), -- 변경된 타입. '수정' 또는 '삭제'
modDate		DATE, -- 변경된 날짜
modUser		VARCHAR(30) -- 변경한 사용자
);
-- singer 테이블에 INSERT, UPDATE 가 일어나면, 변경되기 전의 데이터를 저장할 백업테이블을 미리 생성했음
-- 백업 테이블에는 추가로 수정, 삭제 구분할 변경된 타입(modType), 변경된 날짜(modDate), 변경한 사용자(modUser)를 추가함

-- UPDATE 시, 작동하는 singer_updateTrg 만들기
DROP TRIGGER IF EXISTS singer_updateTrg;
DELIMITER $$
CREATE TRIGGER singer_updateTrg
	AFTER UPDATE
    ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, 
		OLD.mem_number, OLD.addr, '수정', CURDATE(), CURRENT_USER());
        -- OLD 테이블은 update 나 delete가 수행될때, 변경되기 전의 데이터가 잠깐 저장되는 임시 테이블
        -- OLD 테이블에 update 문이 작동되면, 이 행에 의해 업데이트 되기 전의 데이터가 백업테이블에 입력됨
        -- 원래 데이터가 보존됨
END $$
DELIMITER ;

-- DELETE시, 작동하는 singer_updateTrg 만들기
DROP TRIGGER IF EXISTS singer_delteTrg;
DELIMITER $$
CREATE TRIGGER singer_deleteTrg
	AFTER DELETE
    ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, 
		OLD.mem_number, OLD.addr, '수정', CURDATE(), CURRENT_USER());
        -- OLD 테이블은 update 나 delete가 수행될때, 변경되기 전의 데이터가 잠깐 저장되는 임시 테이블
        -- OLD 테이블에 update 문이 작동되면, 이 행에 의해 업데이트 되기 전의 데이터가 백업테이블에 입력됨
        -- 원래 데이터가 보존됨
END $$
DELIMITER ;

UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
DELETE FROM singer WHERE mem_number >= 7;

-- DELETE ALL THE ROWS ON THE TABLE using TRUNCATE TABLE
TRUNCATE TABLE singer;

SELECT*FROM backup_singer; 
-- 백업테이블에 삭제된 내용이 들어가지 않음
-- because delete가 아닌 truncate table로 적용되어서