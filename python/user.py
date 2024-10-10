from fastapi import APIRouter, File, UploadFile
import pymysql
from datetime import datetime

router = APIRouter()

from fastapi.responses import FileResponse
import os
import shutil

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

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
        SELECT count(eMail)
        FROM user
        WHERE eMail=%s
        AND password=%s
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

@router.get("/login")
async def login(eMail: str = None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        SELECT eMail,nickName,password,phone,createDate,etc,point,profileImage
        FROM user
        WHERE eMail=%s
        """
        curs.execute(sql, (eMail))
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
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()



@router.get("/eMailVerify")
async def login(eMail: str = None):
    conn = connect()
    curs = conn.cursor()
    print(len("BqfayfXeJsMD5Fzua8Ce"))
    try:
        sql = """
        SELECT count(eMail)
        FROM user
        WHERE eMail=%s
        """
        curs.execute(sql, (eMail))
        rows = curs.fetchall()
        result = [{'result': row[0]!=1} for row in rows]
        conn.commit()
        return {'result': result}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/signIn")
async def login(eMail: str = None, nickname: str =None, password: str = None,phone:str = None):
    aa = datetime.now()
    print(aa)
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        INSERT 
        INTO user(
        eMail,nickname,password,phone,createDate,etc,point
        )
        values(%s,%s,%s,%s,%s,0,0)
        """
        curs.execute(sql, (eMail,nickname, password, phone,aa))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()

@router.get("/update")
async def login(cureMail:str, eMail: str = None, nickname: str =None, phone:str = None):

    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        UPDATE user 
        SET
            eMail = %s,
            nickname = %s,
            phone = %s
        WHERE eMail = %s
        """
        curs.execute(sql, (eMail,nickname,phone,cureMail))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()

@router.get("/updateAll")
async def login(cureMail:str, eMail: str = None, nickname: str =None, phone:str = None, profileImage:str = None):

    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        UPDATE user 
        SET
            eMail = %s,
            nickname = %s,
            phone = %s,
            profileImage = %s
        WHERE eMail = %s
        """
        curs.execute(sql, (eMail,nickname,phone,profileImage,cureMail))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.get("/updatePW")
async def login(eMail: str = None, password:str = None):

    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        UPDATE user 
        SET
            password = %s
        WHERE eMail = %s
        """
        curs.execute(sql, (password,eMail))
        conn.commit()
        return {'result': 'OK'}
    except Exception as e:
        print("Error:", e)
        return {"results": "Error"}
    finally:
        conn.close()


@router.post("/imageUpload")
async def upload_file(file : UploadFile = File(...)):

    try:
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        with open(file_path, "wb") as buffer: ## "wb" : write binarry
            shutil.copyfileobj(file.file, buffer)
        return{'result' : 'OK'}

    except Exception as e:
        print("Error:", e)
        return({"reslut" : "Error"})


