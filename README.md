# ✈️ Aircraft Safety Check App

## 📱 프로젝트 개요

이 프로젝트는 Flutter 기반의 모바일 애플리케이션으로, 사용자가 입력한 항공편 번호를 기반으로 AWS Lambda를 통해 센서 데이터를 조회하고, TensorFlow 모델을 사용하여 이상 여부를 판단하여 결과를 시각적으로 제공하는 기능을 구현합니다.

## 🔧 주요 기능

- **사용자 입력**: 항공편 번호 입력을 통한 데이터 조회 요청
- **AWS Lambda 연동**: 입력된 항공편 번호를 기반으로 Lambda 함수 호출
- **DynamoDB 조회**: 해당 항공편의 센서 데이터 조회
- **TensorFlow 모델 적용**: 조회된 데이터를 기반으로 이상 여부 판단
- **시각화**: 결과를 앱 내에서 시각적으로 표시

## 📂 프로젝트 구조

```
app/
├── android/
├── ios/
├── lib/
├── test/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.lock
└── pubspec.yaml
README.md
```

## 🛠️ 기술 스택

- **Flutter**: 프론트엔드 프레임워크
- **AWS Lambda**: 서버리스 컴퓨팅
- **DynamoDB**: NoSQL 데이터베이스
- **TensorFlow**: 머신러닝 모델
- **Docker**: Lambda 함수 컨테이너화
- **API Gateway**: Lambda 함수와의 통신 인터페이스

## 📌 참고 사항

- Firebase 및 `.tflite` 모델은 제거되었습니다.
- TensorFlow 모델은 `.h5`에서 `.keras` 포맷으로 변환되었습니다.
- Lambda 함수는 Docker로 배포되어 AWS ECR에 등록되었으며, API Gateway와 연동되어 있습니다.
