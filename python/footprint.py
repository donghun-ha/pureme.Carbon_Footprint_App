"""
탄소 발자국 절감량 계산 라우터

Author: 하동훈
Date: 2024-10-07
Usage: 탄소발자국 조회   : http://127.0.0.1:8000/footprint/select?user_id=asd

이 파일은 FastAPI의 APIRouter를 사용하여 탄소 발자국을 계산하는 API 엔드포인트를 정의합니다.
사용자의 다양한 활동 데이터를 받아 탄소 배출량, 절감량, 순 탄소 발자국을 계산하여 반환합니다.
"""

"""
전세계 평균치 데이터로 절감량 표기
출처 : https://www.epa.gov/ghgemissions/sources-greenhouse-gas-emissions
    : https://www.iea.org/reports/united-states-2024/executive-summary
"""

from fastapi import APIRouter
import pymysql

# APIRouter 인스턴스 생성
router = APIRouter()

def connect():
    """MySQL 데이터베이스에 연결하는 함수입니다."""
    conn = pymysql.connect(
        host='192.168.50.71',
        user='user',
        password='qwer1234',
        db='pureme',
        charset='utf8'
    )
    return conn

@router.get("/select")
async def select(user_eMail: str = None, search: str = ''):
    """사용자의 활동 데이터를 검색하여 반환합니다."""
    search_text = f"%{search}%"
    conn = connect()
    curs = conn.cursor()

    sql = "SELECT * FROM category_has_user WHERE user_eMail=%s AND category_kind LIKE %s"
    curs.execute(sql, (user_eMail, search_text))
    rows = curs.fetchall()
    conn.close()
    
    return {'results': rows}

@router.get("/insert")
async def insert(category_kind: str = None, user_eMail: str = None, createDate: str = None, amount: str = None):
    """새로운 사용자 활동 데이터를 데이터베이스에 추가합니다."""

    print(category_kind, user_eMail, createDate, amount)
    conn = connect()
    curs = conn.cursor()

    try:
        sql = """
            INSERT INTO category_has_user
                (category_kind, user_eMail, createDate, amount)
            VALUES
                (%s, %s, %s, %s)
        """
        curs.execute(sql, (category_kind, user_eMail, createDate, amount))
        conn.commit()
        conn.close()
        return {'result': 'OK'}
    except Exception as e:
        conn.close()
        return {'result': 'Error', 'message': str(e)}

# 탄소 배출 계수 (단위: kg CO2)
CARBON_FACTORS = {
    'car': 0.21,                 # 자동차 주행 km당 탄소 배출량
    'public': 0.05,              # 대중교통 km당 탄소 배출량
    'bicycle': -0.01,            # 자전거 km당 절감되는 탄소 배출량
    'walk': -0.01,               # 도보 km당 절감되는 탄소 배출량
    'electricity': 0.5,          # 전기 사용량 1kWh당 탄소 배출량
    'gas': 0.2,                  # 가스 사용량 1kWh당 탄소 배출량
    'meat': 27,                  # 육류 1kg당 탄소 배출량
    'vegetarian': 5,             # 채식 1kg당 탄소 배출량
    'dairy': 9,                  # 유제품 1kg당 탄소 배출량
    'plant': 3,                  # 식물성 대체 식품 1kg당 탄소 배출량
    'paper': -0.5,               # 종이류 1kg당 절감되는 탄소 배출량
    'plastic': -0.4,             # 플라스틱류 1kg당 절감되는 탄소 배출량
    'glass': -0.3,               # 유리류 1kg당 절감되는 탄소 배출량
    'metal': -0.6,               # 금속류 1kg당 절감되는 탄소 배출량
    'other': -0.2                # 기타 폐기물 1kg당 절감되는 탄소 배출량
}

# 평균 활동 데이터 
# 출처 : 한국 기후,환경 네트워크
# 출처 : 한국일보 한끼밥상
CARBON_AVERAGE = {
    'trafic': 13.02,            # 일간 교통 평균 탄소량
    'electricity': 146.9,       # 월간 평균 전기 탄소 배출량
    'gas': 173.4,               # 월간 평균 가스 탄소 배출량
    'meat': 7.7                 # 일간 평균 고기 탄소 배출량
}

def calculate_reduction_from_average(activities):
    """사용자의 활동과 전 세계 평균치를 비교하여 절감량을 계산합니다."""
    total_carbon = 0.0  # 총 탄소 배출량 초기화
    total_reduction = 0.0  # 총 탄소 절감량 초기화
    average_comparison = {}  # 절감량 비교 결과 저장

    # 평균 교통량을 사용
    average_traffic = CARBON_AVERAGE['trafic']

    for activity, amount in activities.items():
        if activity in CARBON_FACTORS:
            carbon_output = amount * CARBON_FACTORS[activity]  # 사용자 활동에 따른 배출량 계산
            
            # 대중교통, 자동차, 도보, 자전거의 평균값을 사용하여 절감량 계산
            if activity in ['car', 'public', 'bicycle', 'walk']:
                average_output = average_traffic  # 평균 교통량으로 설정
            else:
                average_output = CARBON_AVERAGE.get(activity, 0)  # 전 세계 평균치
            
            # 사용자 입력값과 평균치를 비교하여 절감량 저장
            reduction = average_output - carbon_output
            total_reduction += max(0, reduction)  # 절감량이 음수일 경우 0으로 처리
            total_carbon += carbon_output
            
            average_comparison[activity] = {
                "사용자 배출량": carbon_output,
                "전세계 평균 배출량": average_output,
                "절감량": max(0, reduction)  # 절감량이 음수일 경우 0으로 처리
            }
        else:
            print(f"활동 '{activity}'에 대한 배출 계수가 없습니다.")  

    return total_carbon, total_reduction, average_comparison

def convert_to_energy_reduction(total_carbon_reduction):
    """총 탄소 발자국을 기반으로 에너지 감소량을 계산합니다."""
    energy_reduction = total_carbon_reduction * 0.001  # kg CO2를 MWh로 변환
    return energy_reduction

def convert_to_trees_planted(total_carbon_reduction):
    """총 탄소 발자국을 기반으로 심은 나무 수를 계산합니다."""
    trees_planted = total_carbon_reduction / 22  # 1 나무가 흡수하는 CO2량을 기반으로 계산
    return trees_planted

@router.get("/calculate_with_reduction")
async def calculate_with_reduction(user_eMail: str):
    """사용자의 활동에 대한 탄소 발자국과 절감량을 계산하여 반환합니다."""
    activities_result = await select(user_eMail=user_eMail)
    activities = {activity[0]: activity[3] for activity in activities_result['results']}

    # 탄소 배출량과 절감량 계산 (전 세계 평균치와 비교)
    total_carbon_footprint, total_carbon_reduction, average_comparison = calculate_reduction_from_average(activities)

    # 고기 절감량에 따른 에너지 감소량과 심은 나무 수 계산
    total_energy_reduction = convert_to_energy_reduction(total_carbon_reduction)
    total_trees_planted = convert_to_trees_planted(total_carbon_reduction)

    # 결과 반환 (절감량 포함)
    return {
        '총 탄소 발자국': f"{total_carbon_footprint:.2f} kg CO2",
        '총 절감된 탄소 발자국': f"{total_carbon_reduction:.2f} kg CO2",
        '총 에너지 감소량': f"{total_energy_reduction:.2f} MWh",
        '심은 나무 수': f"{total_trees_planted:.2f} 그루",
        '활동별 절감량 비교': average_comparison  # 전 세계 평균치와 비교한 절감량 반환
    }
