# author 하동훈
# 2024 - 10 - 07
# 탄소 발자국 절감량 계산식 로직 구현

from fastapi import FastAPI
import pymysql

app = FastAPI()

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='pureme',
        charset='utf8'
    )
    return conn

# 탄소 배출 계수 (단위: kg C02)
CARBON_FACTORS = {
    'car_km' : 0.21, # 자동차 주행 km당 탄소 배출량
    'electricity_kwh' : 0.5, 
}
