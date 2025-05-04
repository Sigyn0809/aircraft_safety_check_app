# Aircraft Safety Check App

**캡스톤 디자인 프로젝트 (광운대학교 전기공학과 4학년)**  
**프로젝트명**: Aircraft Safety Check - 비행기 안전 상태 조회 앱 개발  
**학번**: 2018732026 김준호

---

## 프로젝트 개요

이 Flutter 애플리케이션은 사용자가 비행기 번호를 입력하여 해당 항공기의 센서 데이터를 조회하고, Firebase와 연결된 머신러닝 모델을 통해 이상 여부를 판단하는 시스템입니다.

---

## 사용 기술

| 영역        | 기술 스택 |
|-------------|-----------|
| 프론트엔드  | Flutter (Dart) |
| 백엔드      | Firebase Firestore |
| 머신러닝    | TensorFlow + TFLite |
| 실험 & 학습 | Google Colab |

---

## 기능 요약

- **일반 사용자**: 비행기 번호로 센서 데이터를 조회하고, 이상 여부를 실시간으로 확인  
- **관리자 기능**: Firestore에 센서 데이터 입력 및 수정  
- **이상 감지**: 사전 학습된 TFLite 모델을 활용한 이진 분류 (정상 / 이상)

---

## 프로젝트 구조 (일부)
aircraft_safety_check_app/
├── android/                          # Android 관련 설정 및 코드
│   ├── app/
│   │   ├── build.gradle              # 앱 모듈 Gradle 설정
│   │   ├── google-services.json      # Firebase 설정 파일 (비공개)
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml           # 앱 구성 설정
│   │           ├── kotlin/
│   │           │   └── com/example/aircraft_safety_check_app_1/
│   │           │       └── MainActivity.kt       # Flutter 진입점
│   │           └── res/                          # 리소스 (아이콘, 스타일 등)
│   ├── build.gradle                # 프로젝트 수준 Gradle 설정
│   ├── gradle.properties          # Gradle 전역 환경 변수
│   ├── gradlew / gradlew.bat      # Gradle wrapper 실행 파일
│   └── settings.gradle            # 모듈 연결 정보
│
├── lib/                             # Flutter 애플리케이션 코드
│   ├── screens/                     # 각 기능별 화면 구성 파일
│   │   ├── admin_login_screen.dart
│   │   ├── admin_safety_check_page.dart
│   │   ├── login_screen.dart
│   │   └── user_login_screen.dart
│   ├── firebase_options.dart        # Firebase 초기화 설정 (자동 생성됨)
│   └── main.dart                    # 앱 시작점 및 라우팅 정의
│
├── pubspec.yaml                     # Flutter 종속성 및 리소스 정의
├── pubspec.lock                     # 의존성 버전 잠금 파일
├── README.md                        # 프로젝트 설명 문서
├── .gitignore                       # Git 추적 제외 항목
└── .metadata / .packages / .dart_tool / build (자동 생성 빌드 관련 파일들)

---

## 주의사항

- `google-services.json` 파일은 보안을 위해 GitHub에 포함되어 있지 않습니다.
