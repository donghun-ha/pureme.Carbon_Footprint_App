import footprint

from fastapi import APIRouter, HTTPException
import pymysql
from typing import List, Dict, Any
from datetime import datetime

router = APIRouter()


CARBON_AVERAGE = {
    'trafic': 13.02,            # 일간 교통 평균 탄소량 (kg CO2)
    'electricity': 146.9,       # 월간 평균 전기 탄소 배출량 (kg CO2)
    'gas': 173.4,               # 월간 평균 가스 탄소 배출량 (kg CO2)
    'meat': 7.7                 # 일간 평균 고기 탄소 배출량 (kg CO2)
}

footprint.calculate_reduction_from_average(CARBON_AVERAGE)