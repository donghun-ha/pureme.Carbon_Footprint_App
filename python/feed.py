from fastapi import APIRouter
import pymysql

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


@router.get("/likefeed")
async def login(eMail: str = None, feedId : str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        SELECT haert
        FROM likefeed
        WHERE user_eMail=%s
        AND feedId=%s
        """
        curs.execute(sql, (eMail,feedId))
        rows = curs.fetchall()
        result = [{'result': row[0]==1} for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/changeLike")
async def login(haert:str =None, eMail: str = None, feedId : str = None ):
    conn = connect()
    curs = conn.cursor()
    try:
        sql ="""
        UPDATE likefeed 
        SET
            haert = %s
        WHERE user_eMail=%s
        AND feedId=%s
        """

        curs.execute(sql, (haert, eMail,feedId))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()

