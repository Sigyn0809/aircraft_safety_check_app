# Aircraft Safety Check App

## 프로젝트 개요

이 프로젝트는 Flutter 기반의 모바일 애플리케이션으로, 사용자가 입력한 항공편 번호를 기반으로 AWS Lambda를 통해 센서 데이터를 조회하고, TensorFlow 모델을 사용하여 이상 여부를 판단하여 결과를 시각적으로 제공하는 기능을 구현합니다.

## 주요 기능

### 일반 사용자
- **항공편 조회 및 상태 확인**: 항공편 번호 입력 → 센서 데이터 기반 이상 여부 판단
- **오류 처리 UX**: 존재하지 않는 항공편 번호 입력 시, 스낵바를 통해 직관적 안내 제공

### 관리자(Admin)
- **항공편 정보 등록 및 수정**:
  - 등록되지 않은 항공편 번호 조회 시 빈 입력 필드 표시
  - 모든 항목 입력 후 신규 항공편 데이터 등록 (POST)
  - 기존 데이터 조회 후 수정 가능 (PUT)
- **입력 유효성 검증**:
  - 필수 입력 필드 누락 시 등록 거부
  - 유저 쪽에서는 등록 불가, 관리자 전용 처리

---

## 아키텍처 흐름
```
[ Flutter 앱 ]
↓ (POST)
[ AWS API Gateway ]
↓
[ Lambda (Docker 배포) ]
↓
[ DynamoDB / TensorFlow 모델 추론 ]
```
---

## 프로젝트 구조
```
app/
├── android/
├── ios/
├── lib/
│ ├── screens/
│ │ ├── user_login_screen.dart
│ │ ├── admin_login_screen.dart
│ │ └── flight_edit_screen.dart # ← 관리자용 신규 화면
│ ├── services/
│ │ └── api_service.dart # ← GET/POST/PUT 처리 구조 반영
│ └── main.dart
├── test/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.lock
└── pubspec.yaml
README.md
```

---

## 기술 스택

- **Flutter**: 프론트엔드 프레임워크
- **AWS Lambda (Docker)**: 서버리스 모델 + 모델 추론
- **DynamoDB**: 항공편 데이터 저장
- **TensorFlow**: 이상 감지 모델 (`.keras`)
- **API Gateway**: Lambda 호출 인터페이스
- **GitHub / CI**: 브랜치 기반 기능 관리

---

## 참고 사항

- Firebase 및 `.tflite` 모델은 제거되었습니다.
- TensorFlow 모델은 `.h5` → `.keras` 포맷으로 변환.
- Lambda 함수는 Docker로 배포되어 AWS ECR에 등록됨.
- API Gateway는 Lambda 프록시 통합을 활성화한 상태로 GET/POST/PUT 지원.
- 관리자 기능(`feat/admin-insert-flight`)은 `dev` 브랜치에 병합되어 반영됨.
