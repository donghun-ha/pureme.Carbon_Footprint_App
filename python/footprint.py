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
        https://www.iea.org/reports/united-states-2024/executive-summary
"""

from fastapi import APIRouter, HTTPException
import pymysql
from typing import List, Dict, Any
from datetime import datetime

# APIRouter 인스턴스를 생성하여 API 엔드포인트를 그룹화합니다.
# 이는 FastAPI 애플리케이션의 모듈화를 돕습니다.
router = APIRouter()

def connect():
    """MySQL 데이터베이스에 연결하는 함수입니다.
    
    데이터베이스 연결 정보를 설정하고, pymysql을 사용하여 연결을 반환합니다.
    
    Returns:
        pymysql.connections.Connection: 데이터베이스 연결 객체
    """
    conn = pymysql.connect(
        host='192.168.50.71',       # 데이터베이스 호스트 주소
        user='user',            # 데이터베이스 사용자 이름
        password='qwer1234',    # 데이터베이스 비밀번호
        db='pureme',            # 사용할 데이터베이스 이름
        charset='utf8'          # 문자 인코딩 설정
    )
    return conn

# 각 카테리별 CARBON_FACTORS 분류
TRANSPORT_FACTORS = {
    'car': 0.21,
    'public': 0.05,
    'bicycle': -0.01,
    'walk': -0.01
}

ENERGY_FACTORS = {
    'electricity': 0.5,
    'gas': 0.2
}

FOOD_FACTORS = {
    'meat': 27,
    'vegetarian': 5,
    'dairy': 9,
    'plant': 3
}

OTHER_FACTORS = {
    'paper': -0.5,
    'plastic': -0.4,
    'glass': -0.3,
    'metal': -0.6,
    'other': -0.2
}




@router.get("/select")
async def select(user_eMail: str = None, search: str = ''):
    """사용자의 활동 데이터를 검색하여 반환합니다.
    
    - `user_eMail`: 사용자의 이메일 주소로 데이터를 조회하는 데 사용됩니다.
    - `search`: 카테고리 종류를 필터링하는 데 사용되는 검색어입니다.
    
    데이터베이스에서 해당 사용자의 활동 데이터를 검색하고 결과를 반환합니다.
    
    Args:
        user_eMail (str, optional): 사용자의 이메일 주소. 기본값은 None.
        search (str, optional): 카테고리 필터링 검색어. 기본값은 빈 문자열.
    
    Returns:
        dict: 검색된 결과를 포함하는 JSON 응답
    """
    # 검색어에 와일드카드를 추가하여 LIKE 쿼리에 사용
    search_text = f"%{search}%"
    conn = connect()          # 데이터베이스 연결
    curs = conn.cursor()      # 커서 생성

    # SQL 쿼리: 사용자 이메일과 카테고리 종류를 기반으로 데이터 검색
    sql = "SELECT * FROM category_has_user WHERE user_eMail=%s AND category_kind LIKE %s"
    curs.execute(sql, (user_eMail, search_text))  # 파라미터를 사용하여 SQL 인젝션 방지
    rows = curs.fetchall()    # 모든 결과를 가져옴
    conn.close()              # 연결 종료
    
    return {'results': rows}   # 결과를 JSON 형식으로 반환

@router.get("/insert")
async def insert(category_kind: str = None, user_eMail: str = None, createDate: str = None, amount: str = None):
    """새로운 사용자 활동 데이터를 데이터베이스에 추가합니다.
    
    - `category_kind`: 활동 카테고리 종류 (예: 'car', 'public' 등)
    - `user_eMail`: 사용자의 이메일 주소
    - `createDate`: 활동이 발생한 날짜 (예: '2024-10-07')
    - `amount`: 활동량 (예: km, kWh 등)
    
    새로운 데이터를 `category_has_user` 테이블에 삽입합니다.
    
    Args:
        category_kind (str, optional): 활동 카테고리 종류. 기본값은 None.
        user_eMail (str, optional): 사용자의 이메일 주소. 기본값은 None.
        createDate (str, optional): 활동 날짜. 기본값은 None.
        amount (str, optional): 활동량. 기본값은 None.
    
    Returns:
        dict: 삽입 결과를 포함하는 JSON 응답
    """
    conn = connect()          # 데이터베이스 연결
    curs = conn.cursor()      # 커서 생성

    try:
        # SQL 삽입 쿼리: 사용자 활동 데이터를 테이블에 추가
        sql = """
            INSERT INTO category_has_user
                (category_kind, user_eMail, createDate, amount)
            VALUES
                (%s, %s, %s, %s)
        """
        curs.execute(sql, (category_kind, user_eMail, createDate, amount))  # 데이터 삽입
        conn.commit()         # 변경 사항 커밋
        conn.close()          # 연결 종료
        return {'result': 'OK'}  # 성공 응답
    except Exception as e:
        conn.close()          # 오류 발생 시 연결 종료
        return {'result': 'Error', 'message': str(e)}  # 오류 응답

# 탄소 배출 계수 (단위: kg CO2)
# 각 활동별로 탄소 배출 또는 절감 계수를 정의
CARBON_FACTORS = {
    'car': 0.21,                 # 자동차 주행 km당 탄소 배출량
    'public': 0.05,              # 대중교통 km당 탄소 배출량
    'bicycle': -0.01,            # 자전거 km당 절감되는 탄소 배출량 (음수는 절감을 의미)
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
    'trafic': 13.02,            # 일간 교통 평균 탄소량 (kg CO2)
    'electricity': 146.9,       # 월간 평균 전기 탄소 배출량 (kg CO2)
    'gas': 173.4,               # 월간 평균 가스 탄소 배출량 (kg CO2)
    'meat': 7.7                 # 일간 평균 고기 탄소 배출량 (kg CO2)
}

def calculate_reduction_from_average(activities: Dict[str, float]):
    """사용자의 활동과 전 세계 평균치를 비교하여 절감량을 계산합니다.
    
    - `activities`: 사용자의 활동 데이터를 딕셔너리 형태로 받습니다.
      예: {'car': 100, 'meat': 5}
    
    반환값:
        - `total_carbon`: 총 탄소 배출량 (kg CO2)
        - `total_reduction`: 총 탄소 절감량 (kg CO2)
        - `average_comparison`: 활동별 절감량 비교 결과
    """
    total_carbon = 0.0          # 총 탄소 배출량 초기화
    total_reduction = 0.0       # 총 탄소 절감량 초기화
    average_comparison = {}     # 절감량 비교 결과를 저장할 딕셔너리

    # 평균 교통량을 사용 (일간 교통 평균 탄소량)
    average_traffic = CARBON_AVERAGE['trafic']

    # 각 활동별로 탄소 배출량과 절감량을 계산
    for activity, amount in activities.items():
        if activity in CARBON_FACTORS:
            # 사용자 활동에 따른 배출량 계산
            carbon_output = amount * CARBON_FACTORS[activity]
            
            # print(carbon_output)
            # 특정 활동들(car, public, bicycle, walk)은 교통 평균량과 비교
            if activity in ['car', 'public', 'bicycle', 'walk']:
                average_output = average_traffic
            else:
                # 다른 활동들은 CARBON_AVERAGE에서 값을 가져오거나 기본값 0 사용
                average_output = CARBON_AVERAGE.get(activity, 0)
            
            # 사용자 입력값과 평균치를 비교하여 절감량 계산
            reduction = average_output - carbon_output
            # 절감량이 음수일 경우 (배출이 더 많을 경우) 0으로 처리
            reduction = max(0, reduction)
            total_reduction += reduction
            # 총 탄소 배출량에 사용자 활동에 따른 배출량 추가
            total_carbon += carbon_output
            
            # 활동별 절감량 비교 결과 저장
            average_comparison[activity] = {
                "사용자 배출량": carbon_output,
                "전세계 평균 배출량": average_output,
                "절감량": reduction
            }
        else:
            # 정의되지 않은 활동이 있을 경우 경고 메시지 출력
            print(f"활동 '{activity}'에 대한 배출 계수가 없습니다.")  

    return total_carbon, total_reduction, average_comparison

def calculate_carbon_reductions(activities: Dict[str, float]):
    """사용자의 활동과 전 세계 평균치를 비교하여 카테고리별 절감량을 계산합니다.
    
    - `activities`: 사용자의 활동 데이터를 딕셔너리 형태로 받습니다.
      예: {'car': 100, 'meat': 5}
    
    반환값:
        - `carbon_reductions`: 카테고리별 탄소 절감량을 담은 딕셔너리
          예: {'transport': 15.0, 'energy': 20.0, 'food': 5.0, 'other': 0.0}
    """
    # 카테고리별 절감량 초기화
    carbon_reductions = {
        'transport': 0.0,
        'energy': 0.0,
        'food': 0.0,
        'other': 0.0
    }

    # 평균 교통량을 사용 (일간 교통 평균 탄소량)
    average_traffic = CARBON_AVERAGE['trafic']

    # 각 카테고리와 해당 활동들을 하나의 사전으로 통합
    all_factors = {
        'transport': TRANSPORT_FACTORS,
        'energy': ENERGY_FACTORS,
        'food': FOOD_FACTORS,
        'other': OTHER_FACTORS
    }

    # 각 활동별로 탄소 배출량과 절감량을 계산
    for activity, amount in activities.items():
        for category, factors in all_factors.items():
            if activity in factors:
                # 사용자 활동에 따른 배출량 계산
                carbon_output = amount * factors[activity]
                
                # 특정 활동들(car, public, bicycle, walk)은 교통 평균량과 비교
                if activity in ['car', 'public', 'bicycle', 'walk']:
                    average_output = average_traffic
                else:
                    # 다른 활동들은 CARBON_AVERAGE에서 값을 가져오거나 기본값 0 사용
                    average_output = CARBON_AVERAGE.get(activity, 0)
                
                # 사용자 입력값과 평균치를 비교하여 절감량 계산
                reduction = average_output - carbon_output
                # 절감량이 음수일 경우 (배출이 더 많을 경우) 0으로 처리
                reduction = max(0, reduction)
                # 카테고리별 절감량 누적
                carbon_reductions[category] += reduction
                break
        else:
            # 정의되지 않은 활동이 있을 경우 경고 메시지 출력
            print(f"활동 '{activity}'에 대한 배출 계수가 없습니다.")  

    return carbon_reductions






def convert_to_energy_reduction(total_carbon_reduction: float):
    """총 탄소 발자국을 기반으로 에너지 감소량을 계산합니다.
    
    - `total_carbon_reduction`: 총 탄소 절감량 (kg CO2)
    
    반환값:
        - `energy_reduction`: 에너지 감소량 (MWh)
    
    참고:
        - 변환 계수는 가정이며 실제 값은 다를 수 있습니다.
    """
    energy_reduction = total_carbon_reduction * 0.001  # kg CO2를 MWh로 변환 (가정)
    return energy_reduction



def convert_to_trees_planted(total_carbon_reduction: float):
    """총 탄소 발자국을 기반으로 심은 나무 수를 계산합니다.
    
    - `total_carbon_reduction`: 총 탄소 절감량 (kg CO2)
    
    반환값:
        - `trees_planted`: 심은 나무 수 (그루)
    
    참고:
        - 1 나무가 연간 흡수하는 CO2량을 22kg으로 가정
    """
    trees_planted = total_carbon_reduction / 22  # 1 나무당 흡수하는 CO2량으로 나무 수 계산
    return trees_planted



@router.get("/calculate_with_reduction")
async def calculate_with_reduction(user_eMail: str):
    """사용자의 활동에 대한 탄소 발자국과 절감량을 계산하여 반환합니다.
    
    - `user_eMail`: 사용자의 이메일 주소
    
    절차:
        1. 사용자의 활동 데이터를 데이터베이스에서 조회
        2. 활동별 탄소 배출량과 절감량 계산
        3. 절감량을 기반으로 에너지 감소량과 심은 나무 수 계산
        4. 모든 결과를 JSON 형식으로 반환
    
    Args:
        user_eMail (str): 사용자의 이메일 주소
    
    Returns:
        dict: 계산된 탄소 발자국, 절감량, 에너지 감소량, 심은 나무 수, 활동별 절감량 비교 결과를 포함하는 JSON 응답
    """
    # 사용자의 활동 데이터를 조회
    activities_result = await select(user_eMail=user_eMail)
    
    # 조회된 결과를 딕셔너리 형태로 변환
    # 여기서 activity[0]은 category_kind, activity[3]은 amount를 의미
    # 예: {'car': 100, 'meat': 5}
    activities = {activity[0]: float(activity[3]) for activity in activities_result['results']}
    
    # 탄소 배출량과 절감량 계산 (전 세계 평균치와 비교)
    total_carbon_footprint, total_carbon_reduction, average_comparison = calculate_reduction_from_average(activities)
    
    # 절감량을 기반으로 에너지 감소량과 심은 나무 수 계산
    total_energy_reduction = convert_to_energy_reduction(total_carbon_reduction)
    total_trees_planted = convert_to_trees_planted(total_carbon_reduction)

    summary = [
        round(total_energy_reduction,2),
        round(total_trees_planted,2),
        round(total_carbon_footprint,2),
        round(total_carbon_reduction,2),
        # average_comparison,
    ]
    
    # 결과를 JSON 형식으로 반환 (절감량 포함)
    return {
        'result': summary
    }

@router.get("/rankings")
async def get_rankings(limit: int = 10):
    """
    유저별 총 절감량을 기준으로 현재 달의 랭킹을 반환합니다.

    - `limit`: 반환할 랭킹의 상위 몇 명을 가져올지 결정합니다. 기본값은 10.
    
    절차:
        1. 현재 연도와 월을 가져옵니다.
        2. 데이터베이스에서 현재 월의 활동 데이터를 조회합니다.
        3. 유저별 총 절감량을 계산합니다.
        4. 절감량을 기준으로 유저들을 내림차순으로 정렬합니다.
        5. 상위 `limit`명의 유저를 선택하여 반환합니다.
    
    Args:
        limit (int, optional): 반환할 랭킹의 상위 몇 명을 가져올지 결정합니다. 기본값은 10.
    
    Returns:
        dict: 랭킹 리스트를 포함하는 JSON 응답
    """
    # 현재 날짜와 시간을 가져옵니다.
    current_date = datetime.now()
    current_year = current_date.year    # 현재 연도 (예: 2024)
    current_month = current_date.month  # 현재 월 (1-12)

    # 데이터베이스에 연결
    conn = connect()
    curs = conn.cursor()

    try:
        # SQL 쿼리: 현재 연도와 월에 해당하는 사용자 활동 데이터를 가져옵니다.
        sql = """
            SELECT user.nickName, user.eMail, user_activity.category_kind, user_activity.total_amount
            FROM user
            INNER JOIN (
                SELECT user_eMail, category_kind, SUM(amount) AS total_amount
                FROM category_has_user
                WHERE YEAR(createDate) = %s AND MONTH(createDate) = %s
                GROUP BY user_eMail, category_kind
            ) AS user_activity ON user.eMail = user_activity.user_eMail;
        """
        # SQL 쿼리 실행
        curs.execute(sql, (current_year, current_month))
        rows = curs.fetchall()

    except Exception as e:
        # 예외 발생 시 HTTP 500 에러를 반환합니다.
        raise HTTPException(status_code=500, detail=f"데이터베이스 오류: {str(e)}")
    finally:
        # 커서와 연결을 종료합니다.
        if curs:
            curs.close()
        if conn:
            conn.close()

    # 유저별 활동 데이터를 처리하는 로직
    user_activities: Dict[str, Dict[str, float]] = {}

    # 쿼리 결과를 순회하며 유저별로 활동 데이터를 정리합니다.
    for row in rows:
        user_nickName = row[0]          # 유저의 닉네임
        user_email = row[1]               # 유저의 이메일 주소
        category_kind = row[2]            # 활동 카테고리 종류
        total_amount = float(row[3])      # 해당 활동 카테고리의 총 활동량
        

        # 유저가 아직 딕셔너리에 없으면 초기화합니다.
        if user_email not in user_activities:
            user_activities[user_email] = {}

        # 해당 유저의 특정 카테고리 활동량을 저장합니다.
        user_activities[user_email][category_kind] = total_amount

    # 유저별 총 탄소 절감량을 저장할 리스트 초기화
    user_reductions: List[Dict[str, Any]] = []

    # 각 유저의 활동 데이터를 기반으로 탄소 절감량을 계산합니다.
    for user_email, activities in user_activities.items():
        # 탄소 배출량과 절감량 계산 (전 세계 평균치와 비교)
        _, total_carbon_reduction, _ = calculate_reduction_from_average(activities)
        
        # 유저의 이메일과 총 절감량을 리스트에 추가합니다.
        user_reductions.append({
            'user_nickName' : user_nickName,
            'user_eMail': user_email,
            'total_reduction': round(total_carbon_reduction,2)
        })

    # 절감량 기준으로 유저들을 내림차순으로 정렬합니다.
    user_reductions.sort(key=lambda x: x['total_reduction'], reverse=True)

    # 상위 `limit`명의 유저를 선택합니다.
    top_users = user_reductions[:limit]
    # 결과를 JSON 형식으로 반환합니다.
    return {
        'rankings': top_users
    }








@router.get("/chart")
async def calculate_with_reduction(user_eMail: str):
    """사용자의 활동에 대한 탄소 발자국과 절감량을 계산하여 반환합니다.
    
    - `user_eMail`: 사용자의 이메일 주소
    
    절차:
        1. 사용자의 활동 데이터를 데이터베이스에서 조회
        2. 활동별 탄소 배출량과 절감량 계산
        3. 절감량을 기반으로 에너지 감소량과 심은 나무 수 계산
        4. 모든 결과를 JSON 형식으로 반환
    
    Args:
        user_eMail (str): 사용자의 이메일 주소
    
    Returns:
        dict: 계산된 탄소 발자국, 절감량, 에너지 감소량, 심은 나무 수, 활동별 절감량 비교 결과를 포함하는 JSON 응답
    """
    # 사용자의 활동 데이터를 조회
    activities_result = await select(user_eMail=user_eMail)
    
    # 조회된 결과를 딕셔너리 형태로 변환
    # 여기서 activity[0]은 category_kind, activity[3]은 amount를 의미
    # 예: {'car': 100, 'meat': 5}
    activities = {activity[0]: float(activity[3]) for activity in activities_result['results']}

    return {'result' : calculate_carbon_reductions(activities)}

