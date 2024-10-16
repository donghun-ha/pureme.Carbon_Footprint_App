# 🌿 pureme (Carbon Footprint Calculator App)

**pureme**는 Flutter와 Python(FastAPI)을 기반으로 한 탄소 발자국 계산 애플리케이션으로, 사용자가 자신의 탄소 배출량을 계산하고 모니터링하며 절감할 수 있도록 도와줍니다. 다양한 활동 영역에서의 탄소 배출을 추적하고, 커뮤니티와의 상호작용을 통해 지속 가능한 생활을 장려합니다.

🛠️ **개발 환경**

  - **IDE**: Visual Studio Code
  - **언어 및 프레임워크**:
  	- Flutter: Dart
  	- Python: FastAPI
  - **데이터베이스**: MySQL
  - **클라우드 서비스**: Firebase
  - **디바이스**: AOS,IOS
## 📈 주요 기능

### 사용자 기능

- **탄소 발자국 계산하기**
  - **교통**: 대중교통, 자동차, 도보, 자전거 이용 시 발생되는 탄소 배출량 계산
  - **분리수거**: 재활용 활동으로 인한 탄소 절감량 계산
  - **식습관**: 식습관에 따른 탄소 배출량 계산
  - **에너지 사용**: 가정 내 전기, 가스 사용량을 기반으로 탄소 배출량 계산
  - **절감량 표시**: 평균 데이터와 비교하여 절감된 탄소량을 나무 심은 수와 전기 에너지 절약량으로 시각화
  - **걸음수 표시**: 사용자의 건강 앱 권한을 받아 걸음수를 시각화

- **커뮤니티**
  - 사용자들이 자신의 탄소 절감 활동을 공유
  - 좋아요, 댓글, 사진 업로드 기능
  - 대댓글 기능으로 활발한 소통 가능

- **랭킹 페이지**
  - 전체 사용자 중 상위 1-10위 사용자 표시
  - 개인의 순위와 절감량 별도로 확인 가능

- **마이 페이지**
  - 자신이 작성한 게시글 확인 및 게시글 작성
  - 회원 정보 수정 및 비밀번호 변경
  - 탄소 발자국 분석 및 카테고리별 탄소 발자국 비교 차트 시각화
  - 기부 사이트로 이동하는 기부 탭

### 관리자 기능

- **앱 통계**
  - 일일 유저 수 및 가입 수를 차트로 시각화

- **Feed 관리**
  - 사용자를 검색하고 게시글을 검토
  - 게시글 숨김 처리 및 삭제 기능

- **사용자 관리**
  - 사용자를 검색하고 계정 정지(1일, 1주일, 30일) 기능

- **신고 관리**
  - 신고된 게시물을 확인하고 조치

## 📚 기술 스택

### 프론트엔드

- **Flutter**: 모바일 애플리케이션 개발
- **패턴**: MVVM (Model-View-ViewModel) 아키텍처
  -	Model: 데이터 구조 및 비즈니스 로직 관리 (데이터베이스 모델, API 응답 모델)
	-	View: 사용자 인터페이스 구성 요소 (Flutter 위젯)
	-	ViewModel: 뷰와 모델 간의 중재자 역할, 상태 관리 및 데이터 바인딩
- **주요 패키지**
  - `cloud_firestore: ^5.4.4`: Firebase Firestore 연동을 통해 실시간 데이터베이스 기능 제공
  - `firebase_core: ^3.6.0`: Firebase 초기화 및 설정 관리
  - `firebase_storage: ^12.3.2`: Firebase Storage를 통한 이미지 및 파일 저장
  - `get: ^4.6.6`: 상태 관리 및 라우팅을 위한 GetX 패키지
  - `get_storage: ^2.1.1`: 로컬 스토리지 관리
  - `http: ^1.2.2`: REST API 통신을 위한 HTTP 클라이언트
  - `image_picker: ^1.1.2`: 사용자가 기기에서 이미지를 선택하고 업로드할 수 있도록 지원
  - `like_button: ^2.0.5`: 게시글에 좋아요 기능 구현
  - `syncfusion_flutter_charts: ^27.1.52`: 데이터 시각화를 위한 차트 컴포넌트
  - `webview_flutter: ^4.8.0`: 앱 내에서 웹 페이지를 표시할 수 있는 웹뷰 통합
  - `health: ^11.1.0`: 건강 데이터 접근을 위한 패키지
  - `permission_handler: ^10.0.0`: 다양한 권한을 관리하고 요청하는 기능 제공

### 백엔드

- **Python (FastAPI)**: 고성능 API 서버 구축
- **데이터베이스**: MySQL
- **Firebase**: 실시간 데이터베이스 및 스토리지(게시글 및 댓글 관리)

## 🛠️ 설치 방법

### 1. 저장소 클론하기

```bash
git clone https://github.com/사용자이름/pureme.Carbon_Footprint_App.git
cd pureme.Carbon_Footprint_Calculation-App
```

### 2. 프론트엔드 설정
```
flutter pub get
```

### 3. 백엔드 설정

- **서버 실행**
```
cd/프로젝트 경로/python
uvicorn pureme:app --reload
```
