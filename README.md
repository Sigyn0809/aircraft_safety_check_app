# Aircraft Safety Check App

## 프로젝트 개요

Aircraft Safety Check App은 Flutter로 개발된 모바일 앱으로, 사용자가 입력한 항공편 번호를 기반으로 AWS Lambda에서 해당 항공편의 센서 데이터를 조회하고, TensorFlow 모델을 통해 이상 여부를 판단하는 기능을 제공합니다.  
이상이 감지된 경우, 같은 노선의 정상 항공편을 추천해주는 기능까지 포함되어 있으며, 관리자 인증을 통해 항공편 데이터를 직접 등록 및 수정할 수 있는 기능도 함께 제공됩니다.

---

## 주요 기능

### 일반 사용자
- **이상 감지 조회**  
  - 항공편 번호 입력 후 Lambda에서 DynamoDB를 통해 센서 데이터를 조회하고, TensorFlow 모델로 이상 여부 판별
- **추천 항공편 기능**  
  - 이상 징후가 발견된 경우, 같은 노선 내의 정상 항공편을 추천
- **결과 시각화**  
  - 센서 데이터와 감지 결과를 UI에 시각적으로 표시
- **직관적인 오류 처리**  
  - 존재하지 않는 항공편일 경우 스낵바로 안내

### 관리자(Admin)
- **로그인 기능 (AWS Cognito 기반)**  
  - 이메일 및 비밀번호 기반 로그인
  - 로그인 성공 시 JWT 토큰 발급 및 API 인증 헤더 포함
- **데이터 등록 및 수정**  
  - 신규 항공편 데이터 등록 (POST)
  - 기존 항공편 수정 (PUT)
  - 조회 시 등록 여부에 따라 폼 자동 전환
- **보안 처리**  
  - `/admin` 경로 하위 API는 인증이 필요하며, 사용자용 `/check` 경로는 공개

---

## 주요 업데이트

### 1. 이상 감지 + 추천 항공편 기능
- 입력 항공편에 대해 이상이 감지되면, 같은 노선의 정상 항공편을 추천
- 추천 항공편은 DynamoDB 내 별도 캐시 테이블(`FlightRecommendationCache`)에 저장되어 재추론 없이 빠르게 응답

### 2. 관리자 인증 기능
- AWS Cognito를 통한 로그인 및 토큰 발급
- 관리자 전용 기능은 인증이 포함된 요청만 처리하도록 Lambda에서 경로 분기 처리

---

## 아키텍처 흐름

```
[ Flutter 앱 ]
     ↓ (POST /check, GET /check, POST /admin, PUT /admin)
[ AWS API Gateway ]
     ↓
[ AWS Lambda (Docker + TensorFlow) ]
     ↓
[ DynamoDB + 캐시 테이블 + 모델 추론 ]
```

---

## 프로젝트 구조

```
app/
├── android/                         # Android 플랫폼 관련 코드 (auto-generated)
├── ios/                             # iOS 플랫폼 관련 코드 (auto-generated)
├── lib/
│   ├── screens/                     # Flutter 화면 구성
│   │   ├── login_screen.dart        # 일반 사용자 및 관리자 선택 화면
│   │   ├── user_login_screen.dart   # 일반 사용자 로그인 화면(항공편 조회)
│   │   ├── admin_login_screen.dart  # 관리자 로그인 화면 (Cognito 인증 연동)
│   │   ├── result_screen.dart       # 일반 사용자 조회 결과 화면
│   │   └── flight_edit_screen.dart  # 관리자 전용 비행편 등록 및 수정 화면
│   ├── services/
│   │   └── api_service.dart         # API 통신 모듈 (GET/POST/PUT 요청)
│   └── main.dart                    # Flutter 앱 진입점
├── test/                            # (옵션) 테스트 코드
├── .gitignore                       # Git 추적 제외 파일 정의
├── pubspec.yaml                     # Flutter 의존성 설정 파일
├── pubspec.lock                     # 실제 설치된 패키지 버전 고정
├── analysis_options.yaml            # Lint 분석 및 스타일 옵션

lambda_project/                      # AWS Lambda 함수 프로젝트 (Docker 기반)
├── Dockerfile                       # Lambda용 Docker 이미지 설정
├── lambda_function.py               # 메인 핸들러 및 이상 감지 + 관리자 분기 처리
├── anomaly_model/                   # 저장된 Keras 모델 (SavedModel 포맷)
│   ├── keras_metadata.pb
│   ├── saved_model.pb
│   └── variables/
│       ├── variables.data-00000-of-00001
│       └── variables.index
└── requirements.txt                 # Lambda 컨테이너용 파이썬 의존성 목록

docs/                                # 프로젝트 문서화 폴더
├── api_structure.md                 # API 설계 및 엔드포인트 명세
├── aws_integration_log.md           # Lambda 연동, 오류 수정 및 통합 과정 로그
├── admin_usage_guide.md             # 관리자 사용법 안내
├── lambda_architecture.md           # Lambda 분기 설계 및 인증 흐름 문서화
├── dev_log_admin_insert.md          # 관리자 등록 기능 개발 로그
├── project_setup_guide.md           # 프로젝트 초기 설정, 배포 가이드
└── ...                              # 기타 관련 문서 파일

README.md                            # 프로젝트 전체 개요 및 기능/아키텍처 설명
```


---

## 기술 스택

- **Flutter**: 프론트엔드 프레임워크
- **AWS Lambda (Docker)**: 서버리스 모델 + TensorFlow 추론
- **TensorFlow (.keras)**: 이상 감지 모델
- **DynamoDB**: 항공편 및 추천 항공편 데이터 저장
- **API Gateway**: Lambda 호출 라우팅 및 인증 처리
- **AWS Cognito**: 관리자 인증 (JWT 기반 토큰 발급)
- **GitHub + 브랜치 전략**: `feat/*`, `dev`, `main` 체계 운영

---

## 테스트 및 배포

- **Lambda**는 Docker 이미지로 ECR에 업로드 후 배포
- **API Gateway**는 사용자용(`/check`)과 관리자용(`/admin`) 엔드포인트를 분리하여 인증 처리
- **Flutter 앱**은 Android 기준 개발 및 테스트 완료
