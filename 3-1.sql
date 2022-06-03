SELECT addr 주소, debut_date 데뷔일자, mem_name FROM member WHERE mem_name='블랙핑크';
SELECT * FROM member WHERE mem_number = 4;
SELECT mem_id, mem_name
	FROM member
    WHERE height <= 162;
SELECT mem_name, height, mem_number
	FROM member
    WHERE height >= 165 AND mem_number > 6;
SELECT mem_name, mem_number, height
	FROM member
    WHERE height >= 165 OR mem_number > 6;
-- between ~ and
SELECT mem_name, height
	FROM member
    WHERE height >= 163 AND height <= 165;
-- same as above
SELECT mem_name, height
	FROM member
    WHERE height BETWEEN 163 AND 165;
--
SELECT mem_name, addr
	FROM member
    WHERE addr = '경기' OR addr = '전남' OR addr = '경남';
-- IN (same as above)
SELECT mem_name, addr
	FROM member
    WHERE addr IN ('전남','경기','경남');
-- LIKE (using some parts of strings)
SELECT * 
	FROM member
    WHERE mem_name LIKE '우%';
-- LIKE (using some parts of strings)
SELECT * 
	FROM member
    WHERE mem_name LIKE '__핑크';
-- subquery
SELECT height FROM member WHERE mem_name = '에이핑크'; -- 에이핑크 평균 키 
SELECT mem_name, height FROM member WHERE height > 164;
-- two queries --> one query (practical)
SELECT mem_name, height FROM member
	WHERE height > (SELECT height FROM member WHERE mem_name='에이핑크')

