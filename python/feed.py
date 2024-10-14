from fastapi import APIRouter
import pymysql

### 박상범 수정
from datetime import datetime

router = APIRouter()

def connect():
    conn = pymysql.connect(
        host='192.168.50.71',
        user='user',
        password='qwer1234',
        db='pureme',
        charset='utf8'
    )
    return conn


@router.get("/getFeedLike")
async def getFeedLike(feedId: str = None, userEmail : str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        SELECT 
            heart_row.user_eMail, heart_row.heart, total_heart
        FROM 
            (SELECT user_eMail, SUM(heart) as heart
                FROM pureme.likefeed
                WHERE feedId = %s
                GROUP BY user_eMail)
            as heart_row,
            (SELECT SUM(heart) AS total_heart
                FROM pureme.likefeed
                WHERE feedId = %s)
            as total_heart_row
        WHERE 
            heart_row.user_eMail = %s

        UNION

        SELECT 
            NULL AS user_eMail, 0 AS heart, total_heart_row.total_heart
        FROM 
            (SELECT SUM(heart) AS total_heart
                FROM pureme.likefeed
                WHERE feedId = %s)
            as total_heart_row
        WHERE NOT EXISTS 
            (SELECT 1 
                FROM pureme.likefeed
                WHERE feedId = %s
                AND user_eMail = %s)
        """
        curs.execute(sql, (feedId, feedId, userEmail, feedId, feedId, userEmail))
        row = curs.fetchone()
        print(row)
        # result = [{'result': row[0]==1} for row in rows]
        conn.commit()
        return {'result': row}
    except Exception as e:
        print("Error:", e)
        return {"result": "Error"}
    finally:
        conn.close()


@router.get("/updateLike")
async def updateLike(feedId:str =None, userEmail: str = None, heart : str = None ):
    conn = connect()
    curs = conn.cursor()
    try:
        sql ="""
        INSERT INTO 
            likefeed (user_eMail, feedId, heart)
        VALUES
            (%s, %s, %s);
        """

        curs.execute(sql, (userEmail, feedId, heart))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"result": "Error"}
    finally:
        conn.close()

#### 박상범 수정
@router.get("/updateReport")
async def updateLike(feedId:str =None, userEmail: str = None, reportReason : str = None ):
    reportTime = datetime.now()
    conn = connect()
    curs = conn.cursor()
    try:
        sql ="""
        INSERT INTO 
            report (user_eMail, feedId, reportTime, reportReason)
        VALUES
            (%s, %s, %s, %s);
        """

        curs.execute(sql, (userEmail, feedId, reportTime, reportReason))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"result": "Error"}
    finally:
        conn.close()
