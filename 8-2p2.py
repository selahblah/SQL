import pymysql

# 데이터 입력 프로그램 
# 전역 변수 선언
conn = cur = None
data1 = data2 = data3 = data4 = sql = ""

# 메인 코드
conn = pymysql.connect(host='IP', user='root', password='PASSWORD', db='soloDB',charset='utf8')
cur = conn.cursor()

while (True) :
    data1 = input("사용자 ID ==> ")
    if data1 == "":
        break;
    data2 = input("사용자 이름 ==> ")
    data3 = input("사용자 이메일 ==> ")
    data4 = input("사용자 출생연도 ==> ")
    sql = "INSERT INTO userTable VALUES('"+data1+"','"+data2+"','"+data3+"',"+data4+")"
    # 입력한 데이터를 sql변수에 문자열로 만듬 
    cur.execute(sql)
    # 생성한 문자열을 실행해서 데이터를 입력
    
conn.commit()
conn.close()