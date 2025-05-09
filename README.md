# 🚀 Aircraft Safety Check App - AWS Lambda Anomaly Detection

## 📦 브랜치 개요

이 브랜치는 AWS Lambda를 활용한 이상 탐지 기능의 구현에 중점을 둔 개발 브랜치입니다. Docker를 사용하여 Lambda 함수를 컨테이너화하고, TensorFlow 모델을 통해 센서 데이터의 이상 여부를 판단하는 기능을 포함하고 있습니다.

## 🔧 구현 내용

- **Lambda 함수 개발**: 항공편 번호를 입력받아 DynamoDB에서 센서 데이터를 조회
- **TensorFlow 모델 통합**: 조회된 데이터를 기반으로 이상 여부 판단
- **Docker 컨테이너화**: Lambda 함수를 Docker로 패키징하여 AWS ECR에 배포
- **API Gateway 연동**: Lambda 함수를 API Gateway와 연동하여 HTTP POST 요청 처리

## 🗂️ 디렉토리 구조

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

- **AWS Lambda**: 서버리스 컴퓨팅
- **DynamoDB**: NoSQL 데이터베이스
- **TensorFlow**: 머신러닝 모델
- **Docker**: Lambda 함수 컨테이너화
- **API Gateway**: Lambda 함수와의 통신 인터페이스

## 📝 참고 사항

- Lambda 함수는 `event.get('flight_number')`를 사용하여 입력을 처리합니다.
- Decimal 직렬화 오류는 `float(item['value'])`로 변환하여 해결하였습니다.
- 응답 데이터 구조를 개선하여 센서값을 포함하도록 수정하였습니다.
- 로그 출력 문제는 `print(json.dumps(event))` 위치 조정 및 이미지 최신화로 해결하였습니다.
- Flutter에서 호출 시 구조 mismatch 문제는 Lambda에서 `event`를 직접 읽도록 수정하였습니다.
