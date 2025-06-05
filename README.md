# Aircraft Safety Check App

## 주요 기능 업데이트

### 1. 이상 감지 및 추천 항공편 기능
- 사용자 입력 항공편 번호에 대해 센서 데이터를 기반으로 이상 여부를 판별합니다.
- 이상이 감지된 경우, 같은 노선의 다른 정상 항공편을 찾아 추천해줍니다.
- 성능 향상을 위해 추천 항공편은 DynamoDB 캐시 테이블(FlightRecommendationCache)에 저장되어, 이후 조회 시 재추론 없이 응답됩니다.

### 2. 관리자 인증 기능 (AWS Cognito 연동)
- 관리자 전용 기능(항공편 등록, 수정, 조회)은 AWS Cognito 인증 기반 로그인 후 사용 가능하도록 구현되어 있습니다.
- 로그인 시 발급받은 토큰을 API 호출 시 포함하여 인증을 수행합니다.
- `/admin` 경로로 시작하는 API만 인증이 요구되며, 사용자 API는 인증 없이 접근 가능합니다.

---

## 프로젝트 개요

이 프로젝트는 Flutter 기반의 모바일 애플리케이션으로, 사용자가 입력한 항공편 번호를 기반으로 AWS Lambda를 통해 센서 데이터를 조회하고, TensorFlow 모델을 사용하여 이상 여부를 판단하여 결과를 시각적으로 제공하는 기능을 구현합니다.

---

## 주요 기능

### 일반 사용자
- **항공편 조회 및 상태 확인**: 항공편 번호 입력 → 센서 데이터 기반 이상 여부 판단
- **추천 항공편 제공**: 이상 감지 시 같은 노선의 정상 항공편을 추천
- **오류 처리 UX**: 존재하지 않는 항공편 번호 입력 시, 스낵바를 통해 직관적 안내 제공

### 관리자(Admin)
- **항공편 정보 등록 및 수정**:
  - 등록되지 않은 항공편 번호 조회 시 빈 입력 필드 표시
  - 모든 항목 입력 후 신규 항공편 데이터 등록 (POST)
  - 기존 데이터 조회 후 수정 가능 (PUT)
- **입력 유효성 검증**:
  - 필수 입력 필드 누락 시 등록 거부
  - 유저 쪽에서는 등록 불가, 관리자 전용 처리
- **로그인 인증 처리**:
  - AWS Cognito 기반 로그인 → 토큰 발급 → 관리자 API 인증

---

## 아키텍처 흐름
'''
[ Flutter 앱 ]
↓ (POST /admin/..., /check)
[ AWS API Gateway ]
↓
[ Lambda (Docker 배포) ]
↓
[ DynamoDB / TensorFlow 모델 추론 ]
'''
---

## 프로젝트 구조
'''
app/
├── android/
├── ios/
├── lib/
│ ├── screens/
│ │ ├── user_login_screen.dart
│ │ ├── admin_login_screen.dart
│ │ └── flight_edit_screen.dart
│ ├── services/
│ │ └── api_service.dart
│ └── main.dart
├── test/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.lock
└── pubspec.yaml
README.md
'''

---

## 기술 스택

- **Flutter**: 프론트엔드 프레임워크
- **AWS Lambda (Docker)**: 서버리스 모델 + 모델 추론
- **DynamoDB**: 항공편 데이터 저장
- **TensorFlow**: 이상 감지 모델 (`.keras`)
- **API Gateway**: Lambda 호출 인터페이스
- **AWS Cognito**: 관리자 로그인 인증
- **GitHub / CI**: 브랜치 기반 기능 관리