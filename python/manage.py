from fastapi import APIRouter
import pymysql

from datetime import datetime, timedelta

import re

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

@router.get("/loginVerify")
async def login(eMail: str = None, password: str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        SELECT count(manageEMail)
        FROM manager
        WHERE manageEMail=%s
        AND managerPw=%s
        """
        curs.execute(sql, (eMail, password))
        rows = curs.fetchall()
        result = [{'seq': row[0]==1} for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()




@router.get("/userperday")
async def userperday():
    conn = connect()
    curs = conn.cursor()
    now = datetime.now()
    try:
        ##### 일별 이메일 생성수
        sql = """
            SELECT 'day' as period, COUNT(eMail) as count, (SELECT COUNT(eMail)/ DATEDIFF(max(createDate), min(createDate)) AS date_difference FROM user )
            *
            (SELECT daydiff FROM (SELECT COUNT(eMail), (SELECT LEAST((SELECT DATEDIFF(max(createDate), min(createDate)) AS date_difference FROM user), 1) )as daydiff FRom user) AS jj)  
            as average 
            FROM user
            WHERE createDate > NOW() - INTERVAL 1 DAY

            UNION ALL

            SELECT 'week' as period, COUNT(eMail) as count, 
            (SELECT COUNT(eMail)/DATEDIFF(max(createDate), min(createDate)) AS date_difference FROM user) 
            *
            (SELECT daydiff FROM (SELECT COUNT(eMail), (SELECT LEAST((SELECT DATEDIFF(max(createDate), min(createDate)) AS date_difference FROM user), 7) )as daydiff FRom user) AS jj)  
            as average
            FROM user
            WHERE createDate > NOW() - INTERVAL 7 DAY

            UNION ALL

            SELECT 'month' as period, COUNT(eMail) as count, 
            (COUNT(eMail)/DATEDIFF(max(createDate), min(createDate))) 
            *
            (SELECT daydiff FROM (SELECT COUNT(eMail), (SELECT LEAST((SELECT DATEDIFF(max(createDate), min(createDate)) AS date_difference FROM user), 30) )as daydiff FRom user) AS jj)  
            as average
            FROM user
            WHERE createDate > NOW() - INTERVAL 30 DAY

            UNION ALL

            SELECT 'all' as period, COUNT(eMail) as count, COUNT(eMail) as average
            FROM user
        """
        curs.execute(sql)
        rows = curs.fetchall()
        print(rows)
        result = [{
            'period': row[0],
            'count': row[1],
            'average': row[2],
            } for row in rows]
        conn.commit()
        return {'result': result}
    ### 에러나면 쓰기
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/searchUser")
async def userperday(serachUserWord :str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        ##### 일별 이메일 생성수
        sql = """
            SELECT 
                u.*
            FROM 
                user AS u
            LEFT JOIN 
                (SELECT 
                    user_eMail,
                    DATE_ADD(ceaseDatetime, INTERVAL ceasePeriod DAY) AS endDate
                FROM 
                    accountcease
                ) AS ac
            ON 
                u.eMail = ac.user_eMail
            WHERE 
                (ac.endDate IS NULL OR ac.endDate <= NOW()) 
                AND 
                SUBSTRING_INDEX(u.eMail, '@', 1) LIKE %s
                AND 
                u.eMail NOT IN (
                    SELECT 
                        user_eMail
                    FROM 
                        accountcease
                    WHERE 
                        DATE_ADD(ceaseDatetime, INTERVAL ceasePeriod DAY) > NOW()
                );
        """
        # SQL에서 `LIKE` 문 사용
        curs.execute(sql, (f"%{serachUserWord}%",)) 
        rows = curs.fetchall()
        ## user에 담을수있도록 result제공
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


@router.get("/accountCeaseInsert")
async def queryReportReason(user_eMail :str = None, manager_manageEMail:str = None , ceaseReason:str = None, ceasePeroid:str = None):
    now = datetime.now()
    conn = connect()
    curs = conn.cursor()
    try:
        
        sql = """
            INSERT 
            INTO accountcease (user_eMail, manager_manageEMail, ceaseDatetime, ceaseReason, ceasePeriod)
            VALUES (%s, %s, %s, %s, %s);
        """
        curs.execute(sql, (user_eMail, manager_manageEMail, now, ceaseReason, ceasePeroid))  # 
        result = "OK"
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()



#### 
@router.get("/queryReportcount")
async def queryReportcount(leastAmount : str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
            SELECT *
            FROM    (SELECT 
                        r.feedId, 
                        COUNT(r.feedId) AS feed_count
                    FROM 
                        report AS r
                    LEFT JOIN 
                        pureme.managefeed AS m ON r.feedId = m.feedID
                    WHERE 
                        m.feedID IS NULL
                    GROUP BY 
                        r.feedId
                    ORDER BY 
                        feed_count DESC) AS wow
            WHERE feed_count >=%s
            ;
        """
        curs.execute(sql, leastAmount)  
        rows = curs.fetchall()
        result = [{
            'feedId': row[0],
            'feed_count': row[1],
            } for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/queryReportReason")
async def queryReportReason(feedId :str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        
        sql = """
            SELECT *
            FROM report
            WHERE feedId = %s;
        """

        curs.execute(sql, feedId)  # 
        rows = curs.fetchall()
        result = [{
            'user_eMail': row[0],
            'feedId': row[1],
            'reportTime': row[2],
            'reportReason': row[3],
            } for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()

@router.get("/reportFeed")
async def queryReportReason(manager_manageEMail:str = None, feedId:str = None , changeKind:str = None):
    now = datetime.now()
    conn = connect()
    curs = conn.cursor()
    try:
        
        sql = """
            INSERT 
            INTO managefeed (manager_manageEMail, feedId, changeDatetime, changeKind) 
            VALUES (%s, %s, %s, %s);
        """
        curs.execute(sql, (manager_manageEMail, feedId, now, changeKind))  # 
        result = "OK"
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()



