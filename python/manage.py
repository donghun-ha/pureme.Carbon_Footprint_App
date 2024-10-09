from fastapi import APIRouter
import pymysql

from datetime import datetime, timedelta

import re

router = APIRouter()


def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='pureme',
        charset='utf8'
    )
    return conn


@router.get("/userperday")
async def userperday():
    conn = connect()
    curs = conn.cursor()
    now = datetime.now()
    yesterday = now - timedelta(1)
    lastweek = now - timedelta(7)
    lastmonth = now - timedelta(30)
    try:
        ##### 일별 이메일 생성수
        sql = """
        SELECT count(eMail)
        FROM user
        WHERE createDate > %s
        """
        curs.execute(sql, (yesterday))
        row_days = curs.fetchall()
        
        #### 주간 이메일 생성수        
        sql = """
        SELECT count(eMail)
        FROM user
        WHERE createDate > %s
        """
        curs.execute(sql, (lastweek))
        row_weeks = curs.fetchall()


        ### 월간 이메일 생성수
        sql = """
        SELECT count(eMail)
        FROM user
        WHERE createDate > %s
        """
        curs.execute(sql, (lastmonth))
        row_month = curs.fetchall()

        ### 보내줄 row
        rows = list(row_days + row_weeks + row_month);
        print(rows)        

        result = [{'count': row[0]} for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/searchUser")
async def userperday(userEMail :str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        ##### 일별 이메일 생성수
        sql = """
        SELECT *
        FROM user
        WHERE eMail LIKE %s
        """
        # SQL에서 `LIKE` 문 사용
        curs.execute(sql, (f"%{userEMail}%",))  # `email_id`로 시작하는 모든 이메일 검색
        rows = curs.fetchall()
        result = [{
            'eMail': row[0],
            'nickName': row[1],
            'password': row[2],
            'phone': row[3],
            'createDate': row[4],
            'etc': row[5],
            'point': row[6],
            'profileImage' : row[7]
            } for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()
