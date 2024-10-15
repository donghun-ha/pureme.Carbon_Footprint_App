"""
탄소 발자국 절감량 계산 라우터

Author: 하동훈
Date: 2024-10-08~2024-10-10
Usage:
    - 탄소 발자국 조회:
        http://127.0.0.1:8000/footprint/select?user_eMail=유저이메일
    - 사용자 활동 데이터 삽입:
        http://127.0.0.1:8000/footprint/insert?category_kind=카테고리종류&user_eMail=유저이메일&createDate=YYYY-MM-DD&amount=활동량
    - 탄소 발자국 및 절감량 계산:
        http://127.0.0.1:8000/footprint/calculate_with_reduction?user_eMail=유저이메일
    - 현재 달의 랭킹 조회:
        http://127.0.0.1:8000/footprint/rankings?limit=랭킹수

이 파일은 FastAPI의 APIRouter를 사용하여 탄소 발자국을 계산하는 API 엔드포인트를 정의합니다.
사용자의 다양한 활동 데이터를 받아 탄소 배출량, 절감량, 순 탄소 발자국을 계산하여 반환합니다.

전세계 평균치 데이터로 절감량 표기
출처 : 
    - https://www.epa.gov/ghgemissions/sources-greenhouse-gas-emissions
    - https://www.iea.org/reports/united-states-2024/executive-summary
"""
"""
에러 수정

Date : 2024-10-11~2024-10-12
    - 1) Main Page 와 Ranking Page 탄소 절감량이 다르게 표기되는 부분 에러 수정.
    - 2) 절감량이 사용자가 입력하지 않은 날짜도 포함돼서 계산되는 에러 수정 
        - ex) 10-09,10-11 입력을 하고 10-10일은 입력 하지 않았다고 가정 
        - 'trafic'을 기준으로 일 평균 탄소 배출량인 13.02을 0으로 빼서 절감량이 13.02로 추가되는 부분 수정
    - 3) 에너지 총 감소량 L로 표기 된 부분 계산식 오류 수정
"""

from fastapi import APIRouter, HTTPException
import pymysql
from typing import List, Dict, Any
from datetime import datetime

# APIRouter 인스턴스를 생성하여 API 엔드포인트를 그룹화합니다.
router = APIRouter()

def connect():
    """
    MySQL 데이터베이스에 연결하는 함수입니다.
    
    데이터베이스 연결 정보를 설정하고, pymysql을 사용하여 연결을 반환합니다.
    
    Returns:
        pymysql.connections.Connection: 데이터베이스 연결 객체
    """
    conn = pymysql.connect(
        host='192.168.50.71',       # 데이터베이스 호스트 주소
        user='user',             # 데이터베이스 사용자 이름
        password='qwer1234',     # 데이터베이스 비밀번호
        db='pureme',             # 사용할 데이터베이스 이름
        charset='utf8',          # 문자 인코딩 설정
        cursorclass=pymysql.cursors.DictCursor  # 딕셔너리 형태로 결과 반환
    )
    return conn

@router.get("/select")
async def select(user_eMail: str = None, search: str = ''):
    """
    사용자의 활동 데이터를 검색하여 반환합니다.
    
    Args:
        user_eMail (str, optional): 사용자의 이메일 주소. 기본값은 None.
        search (str, optional): 카테고리 필터링 검색어. 기본값은 빈 문자열.
    
    Returns:
        dict: 검색된 결과를 포함하는 JSON 응답
    """
    search_text = f"%{search}%"
    conn = connect()          # 데이터베이스 연결
    curs = conn.cursor()      # 커서 생성

    try:
        # SQL 쿼리: 사용자 이메일과 카테고리 종류를 기반으로 데이터 검색, category 테이블과 조인하여 genPerAmount 가져오기
        sql = """
            SELECT ch.category_kind, ch.amount, c.genPerAmount, ch.createDate
            FROM category_has_user ch
            JOIN category c ON ch.category_kind = c.kind
            WHERE ch.user_eMail = %s AND ch.category_kind LIKE %s
        """
        curs.execute(sql, (user_eMail, search_text))  # 파라미터를 사용하여 SQL 인젝션 방지
        rows = curs.fetchall()    # 모든 결과를 가져옴
    except Exception as e:
        # 오류 발생 시 에러 메시지 반환
        return {'result': 'Error', 'message': str(e)}
    finally:
        conn.close()              # 연결 종료
    
    # 검색된 결과를 JSON 형식으로 반환
    return {'result': 'OK', 'results': rows}

@router.get("/insert")
async def insert(category_kind: str = None, user_eMail: str = None, createDate: str = None, amount: str = None):
    """
    새로운 사용자 활동 데이터를 데이터베이스에 추가합니다.
    
    Args:
        category_kind (str, optional): 활동 카테고리 종류. 기본값은 None.
        user_eMail (str, optional): 사용자의 이메일 주소. 기본값은 None.
        createDate (str, optional): 활동 날짜. 기본값은 None. ('YYYY-MM-DD' 형식)
        amount (str, optional): 활동량. 기본값은 None. (float로 변환 가능)
    
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
        # amount는 float, createDate는 string in 'YYYY-MM-DD' format
        amount_float = float(amount) if amount else 0.0
        curs.execute(sql, (category_kind, user_eMail, createDate, amount_float))  # 데이터 삽입
        conn.commit()         # 변경 사항 커밋
        return {'result': 'OK'}  # 성공 응답
    except Exception as e:
        conn.rollback()        # 오류 발생 시 롤백
        return {'result': 'Error', 'message': str(e)}  # 오류 응답
    finally:
        curs.close()          # 커서 닫기
        conn.close()          # 연결 종료

# 평균 활동 데이터 
CARBON_AVERAGE = {
    'trafic': 13.02,            # 일간 교통 평균 탄소량 (kg CO2)
    'electricity': 146.9,       # 월간 평균 전기 탄소 배출량 (kg CO2)
    'gas': 173.4,               # 월간 평균 가스 탄소 배출량 (kg CO2)
    'meat': 7.7                 # 일간 평균 고기 탄소 배출량 (kg CO2)
}

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

def calculate_reduction_from_average(activities: List[Dict[str, Any]], date_diff: int, months_diff: int):
    """
    사용자의 활동과 전 세계 평균치를 비교하여 절감량을 계산합니다.
    
    Args:
        activities (List[Dict[str, Any]]): 사용자의 활동 데이터를 리스트 형태로 받습니다.
        각 활동은 {'category_kind', 'amount', 'genPerAmount', 'createDate'} 형태
        date_diff (int): 가입일부터 현재일까지의 일 수
        months_diff (int): 가입일부터 현재까지의 개월 수
    
    Returns:
        Tuple[float, float, Dict[str, Dict[str, float]]]: 총 탄소 배출량, 총 탄소 절감량, 활동별 절감량 비교 결과
    """
    total_carbon = 0.0          # 총 탄소 배출량 초기화
    total_reduction = 0.0       # 총 탄소 절감량 초기화
    average_comparison = {}     # 절감량 비교 결과를 저장할 딕셔너리

    # 각 그룹의 기준 평균
    trafic_categories = ['car', 'public', 'bicycle', 'walk']
    meat_categories = ['meat', 'vegetarian', 'dairy', 'plant']
    other_categories = ['electricity', 'gas']

    # 그룹별 탄소 배출량 초기화
    trafic_emission = 0.0
    meat_emission = 0.0
    electricity_emission = 0.0
    gas_emission = 0.0

    # 각 카테고리별 활동한 날 수를 추적하기 위한 집합
    category_day_counts = {
        'trafic': set(),
        'meat': set(),
        'electricity': set(),
        'gas': set()
    }

    # 활동 데이터를 그룹별로 처리
    for activity in activities:
        category_kind = activity['category_kind']
        amount = float(activity['amount'])
        genPerAmount = float(activity['genPerAmount'])
        # createDate를 문자열로 변환 (날짜 형식에 따라)
        createDate = activity['createDate'].strftime('%Y-%m-%d') if isinstance(activity['createDate'], datetime) else activity['createDate']
        carbon_output = amount * genPerAmount
        total_carbon += carbon_output

        if category_kind in trafic_categories:
            trafic_emission += carbon_output
            category_day_counts['trafic'].add(createDate)
        elif category_kind in meat_categories:
            meat_emission += carbon_output
            category_day_counts['meat'].add(createDate)
        elif category_kind == 'electricity':
            electricity_emission += carbon_output
            category_day_counts['electricity'].add(createDate)
        elif category_kind == 'gas':
            gas_emission += carbon_output
            category_day_counts['gas'].add(createDate)
        else:
            # 기타 카테고리의 경우 (절감)
            total_carbon -= carbon_output  # 절감량을 빼줌

    # 'trafic' 카테고리 절감량 계산
    number_of_trafic_days = len(category_day_counts['trafic'])
    if number_of_trafic_days > 0:
        trafic_expected = CARBON_AVERAGE['trafic'] * number_of_trafic_days
        trafic_reduction = trafic_expected - trafic_emission
        trafic_reduction = max(0, trafic_reduction)  # 절감량은 음수가 될 수 없음
        total_reduction += trafic_reduction
        average_comparison['trafic'] = {
            "사용자 배출량": round(trafic_emission, 2),
            "전세계 평균 배출량": round(trafic_expected, 2),
            "절감량": round(trafic_reduction, 2)
        }

    # 'meat' 카테고리 절감량 계산
    number_of_meat_days = len(category_day_counts['meat'])
    if number_of_meat_days > 0:
        meat_expected = CARBON_AVERAGE['meat'] * number_of_meat_days
        meat_reduction = meat_expected - meat_emission
        meat_reduction = max(0, meat_reduction)  # 절감량은 음수가 될 수 없음
        total_reduction += meat_reduction
        average_comparison['meat'] = {
            "사용자 배출량": round(meat_emission, 2),
            "전세계 평균 배출량": round(meat_expected, 2),
            "절감량": round(meat_reduction, 2)
        }

    # 'electricity' 카테고리 절감량 계산
    number_of_electricity_days = len(category_day_counts['electricity'])
    if number_of_electricity_days > 0 and months_diff > 0:
        electricity_expected = CARBON_AVERAGE['electricity'] * months_diff
        electricity_reduction = electricity_expected - electricity_emission
        electricity_reduction = max(0, electricity_reduction)  # 절감량은 음수가 될 수 없음
        total_reduction += electricity_reduction
        average_comparison['electricity'] = {
            "사용자 배출량": round(electricity_emission, 2),
            "전세계 평균 배출량": round(electricity_expected, 2),
            "절감량": round(electricity_reduction, 2)
        }

    # 'gas' 카테고리 절감량 계산
    number_of_gas_days = len(category_day_counts['gas'])
    if number_of_gas_days > 0 and months_diff > 0:
        gas_expected = CARBON_AVERAGE['gas'] * months_diff
        gas_reduction = gas_expected - gas_emission
        gas_reduction = max(0, gas_reduction)  # 절감량은 음수가 될 수 없음
        total_reduction += gas_reduction
        average_comparison['gas'] = {
            "사용자 배출량": round(gas_emission, 2),
            "전세계 평균 배출량": round(gas_expected, 2),
            "절감량": round(gas_reduction, 2)
        }

    return total_carbon, total_reduction, average_comparison

def convert_to_energy_reduction_liters(total_carbon_reduction: float):
    """
    총 탄소 절감량을 기반으로 에너지 감소량을 리터로 계산합니다.
    
    Args:
        total_carbon_reduction (float): 총 탄소 절감량 (kg CO2)
    
    Returns:
        float: 에너지 감소량 (L)
    """
    # 가솔린 1리터당 배출되는 CO2는 약 2.31kg
    liters_reduction = total_carbon_reduction / 2.31
    return liters_reduction

def convert_to_trees_planted(total_carbon_reduction: float):
    """
    총 탄소 발자국을 기반으로 심은 나무 수를 계산합니다.
    
    Args:
        total_carbon_reduction (float): 총 탄소 절감량 (kg CO2)
    
    Returns:
        float: 심은 나무 수 (그루)
    """
    trees_planted = total_carbon_reduction / 22  # 1 나무당 흡수하는 CO2량으로 나무 수 계산
    return trees_planted

@router.get("/calculate_with_reduction")
async def calculate_with_reduction(user_eMail: str):
    """
    사용자의 활동에 대한 탄소 발자국과 절감량을 계산하여 반환합니다.
    
    Args:
        user_eMail (str): 사용자의 이메일 주소
    
    Returns:
        dict: 계산된 탄소 발자국, 절감량, 에너지 감소량, 심은 나무 수, 활동별 절감량 비교 결과를 포함하는 JSON 응답
    """
    # 사용자의 활동 데이터를 조회
    activities_result = await select(user_eMail=user_eMail)
    
    # select 함수가 오류를 반환했는지 확인
    if activities_result.get('result') == 'Error':
        return activities_result
    
    # 조회된 결과를 리스트 형태로 변환
    # 각 활동: {'category_kind', 'amount', 'genPerAmount', 'createDate'}
    activities = activities_result.get('results', [])
    
    if not activities:
        return {'result': 'Error', 'message': '사용자의 활동 데이터를 찾을 수 없습니다.'}
    
    # 사용자 가입일 조회 (user 테이블에서)
    conn = connect()
    curs = conn.cursor()
    
    try:
        curs.execute("SELECT createDate FROM user WHERE eMail = %s LIMIT 1;", (user_eMail,))
        row = curs.fetchone()
        if not row or not row.get('createDate'):
            return {'result': 'Error', 'message': '사용자의 가입일을 찾을 수 없습니다.'}
        join_date = row['createDate']  # 가입일 가져오기

        # join_date를 datetime.date로 변환
        if isinstance(join_date, datetime):
            join_date = join_date.date()
        elif isinstance(join_date, str):
            join_date = datetime.strptime(join_date, '%Y-%m-%d').date()
        else:
            return {'result': 'Error', 'message': '사용자의 가입일 형식이 올바르지 않습니다.'}

        # 현재 날짜와 가입일로 기간 계산
        current_date = datetime.now().date()
        date_diff = (current_date - join_date).days  # 가입일부터 현재일까지의 일 수
        if date_diff < 1:
            return {'result': 'Error', 'message': '가입일이 현재 날짜 이후입니다.'}

        # 가입일부터 현재까지의 개월 수 계산
        months_diff = (current_date.year - join_date.year) * 12 + (current_date.month - join_date.month)
        if months_diff < 1:
            months_diff = 1  # 최소 1개월로 설정

        # 절감량 계산
        total_carbon_footprint, total_carbon_reduction, average_comparison = calculate_reduction_from_average(
            activities, date_diff, months_diff
        )

        # 에너지 절감량과 심은 나무 수 계산
        total_energy_reduction = convert_to_energy_reduction_liters(total_carbon_reduction)  # 리터 단위로 변경
        total_trees_planted = convert_to_trees_planted(total_carbon_reduction)

        # 요약 정보 준비
        summary = {
            'total_carbon_footprint': round(total_carbon_footprint, 2),
            'total_carbon_reduction': round(total_carbon_reduction, 2),
            'total_energy_reduction': round(total_energy_reduction, 1),  # 리터 단위
            'total_trees_planted': round(total_trees_planted, 1),
            'average_comparison': average_comparison
        }

        # 결과를 JSON 형식으로 반환
        return {
            'result': 'OK',
            'summary': summary
        }

    except Exception as e:
        # 예외 발생 시 에러 메시지 반환
        return {'result': 'Error', 'message': str(e)}
    finally:
        curs.close()
        conn.close()

@router.get("/rankings")
async def get_rankings(limit: int = 10):
    """
    유저별 총 절감량을 기준으로 현재 달의 랭킹을 반환합니다.

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
            SELECT u.nickName, u.eMail, ch.category_kind, SUM(ch.amount) AS total_amount, c.genPerAmount, ch.createDate
            FROM user u
            INNER JOIN category_has_user ch ON u.eMail = ch.user_eMail
            JOIN category c ON ch.category_kind = c.kind
            WHERE YEAR(ch.createDate) = %s AND MONTH(ch.createDate) = %s
            GROUP BY u.eMail, ch.category_kind, ch.createDate
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
    user_activities: Dict[str, List[Dict[str, Any]]] = {}
    user_nickNames: Dict[str, str] = {}

    # 쿼리 결과를 순회하며 유저별로 활동 데이터를 정리합니다.
    for row in rows:
        user_nickName = row['nickName']          # 유저의 닉네임
        user_email = row['eMail']                # 유저의 이메일 주소
        category_kind = row['category_kind']     # 활동 카테고리 종류
        total_amount = float(row['total_amount'])# 해당 활동 카테고리의 총 활동량
        category_genPerAmount = float(row['genPerAmount'])  # 카테고리별 탄소 배출 계수
        createDate = row['createDate']           # 활동 날짜

        # 유저가 아직 리스트에 없으면 초기화합니다.
        if user_email not in user_activities:
            user_activities[user_email] = []
            user_nickNames[user_email] = user_nickName

        # 해당 유저의 특정 카테고리 활동을 리스트에 추가합니다.
        user_activities[user_email].append({
            'category_kind': category_kind,
            'amount': total_amount,
            'genPerAmount': category_genPerAmount,
            'createDate': createDate
        })

    # 유저별 총 탄소 절감량을 저장할 리스트 초기화
    user_reductions: List[Dict[str, Any]] = []

    # 각 유저의 활동 데이터를 기반으로 탄소 절감량을 계산합니다.
    for user_email, activities in user_activities.items():
        # 사용자 가입일 조회
        try:
            with connect() as conn_rank:
                with conn_rank.cursor() as curs_rank:
                    curs_rank.execute("SELECT createDate FROM user WHERE eMail = %s LIMIT 1;", (user_email,))
                    row_rank = curs_rank.fetchone()
                    if not row_rank or not row_rank.get('createDate'):
                        continue  # 가입일이 없으면 스킵
                    join_date = row_rank['createDate']
                    if isinstance(join_date, datetime):
                        join_date = join_date.date()
                    elif isinstance(join_date, str):
                        join_date = datetime.strptime(join_date, '%Y-%m-%d').date()
                    else:
                        continue  # 형식이 올바르지 않으면 스킵

                    current_date_rank = datetime.now().date()
                    date_diff_rank = (current_date_rank - join_date).days  # 가입일부터 현재일까지의 일 수
                    months_diff_rank = (current_date_rank.year - join_date.year) * 12 + (current_date_rank.month - join_date.month)
        except Exception as e:
            continue  # 오류 발생 시 스킵

        # 절감량 계산
        if date_diff_rank < 1:
            date_diff_rank = 1  # 최소 1일로 설정
        if months_diff_rank < 1:
            months_diff_rank = 1  # 최소 1개월로 설정

        # 절감량 계산
        total_carbon_footprint, total_carbon_reduction, _ = calculate_reduction_from_average(
            activities, date_diff_rank, months_diff_rank
        )

        # 탄소 절감량 계산
        total_reduction = total_carbon_reduction

        # 결과를 리스트에 추가
        user_reductions.append({
            'user_nickName': user_nickNames[user_email],
            'user_eMail': user_email,
            'total_reduction': round(total_reduction, 2)
        })

    # 절감량 기준으로 유저들을 내림차순으로 정렬합니다.
    user_reductions.sort(key=lambda x: x['total_reduction'], reverse=True)

    # 상위 `limit`명의 유저를 선택합니다.
    top_users = user_reductions[:limit]
    print(top_users)

    # 결과를 JSON 형식으로 반환.
    return {
        'rankings': top_users
    }

### DONE ###