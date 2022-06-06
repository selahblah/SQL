import pymysql
conn = pymysql.connect(host='IP', user='root', password='PASSWORD', db='soloDB',charset='utf8')

cur = conn.cursor() 
# 커서는 데이터베이스에 sql을 실행하거나 실행된 결과를 돌려받는 통로

cur.execute("CREATE TABLE userTable(id char(4), userName char(15), email char(20), birthYear int)")
# cur.execute는 sql이 연결된 데이터베이스에 실행함

cur.execute("INSERT INTO userTable VALUES('hong','홍지윤','hong@naver.com',1996)")
cur.execute("INSERT INTO userTable VALUES('kim','김태연','hong@daum.net',2011)")
cur.execute("INSERT INTO userTable VALUES('star','별사랑','hong@gmail.com',1990)")
cur.execute("INSERT INTO userTable VALUES('yang','양지은','hong@paran.com',1993)")
# 데이터는 필요한 만큼 반복해서 입력 / 아직 저장된건 아님

conn.commit() # 임시로 저장됨. 확실하게 저장 --> commit

conn.close()
# 데이터 베이스 모두 사용시, 연결한 데이터 베이스 닫기