## 프로젝트 초기 설정 가이드

이 문서는 Aircraft Safety Check App을 처음 설치하고 실행하기 위한 환경 구성 및 배포 절차를 정리한 문서입니다.

---

## 1. Flutter 개발 환경 설정

### 필수 조건

- Flutter SDK 설치 (권장 버전: 3.13 이상)
- Android Studio 또는 VS Code 설치
- Android SDK, Emulator 설정

### 설치 확인

```bash
flutter doctor
```

---

## 2. 프로젝트 실행

### 의존성 설치

```bash
flutter pub get
```

### 에뮬레이터 실행

```bash
flutter run
```

---

## 3. 프로젝트 구조 요약

```
app/
├── lib/
│   ├── screens/                # 사용자/관리자 화면
│   ├── services/               # API 호출 모듈
├── pubspec.yaml                # 의존성 설정
├── android/ / ios/             # 플랫폼별 코드
```

---

## 4. pubspec.yaml 주요 의존성

```yaml
dependencies:
  flutter:
  http: ^0.13.5
```

> Firebase 및 tflire 관련 의존성은 제거되어야 함

---

## 5. Lambda Docker 배포 가이드

### Dockerfile 예시

```dockerfile
FROM public.ecr.aws/lambda/python:3.9
COPY app/requirements.txt .
RUN pip install -r requirements.txt
COPY anomaly_model anomaly_model
COPY app/lambda_function.py .
CMD [\"lambda_function.lambda_handler\"]
```

### 배포 절차

```bash
docker build -t lambda-anomaly .
docker tag lambda-anomaly:latest <ECR_URL>
docker push <ECR_URL>
```

AWS Lambda > 이미지 기반 함수로 등록

---

## 6. API Gateway 설정

- /check 리소스
- GET / POST / PUT 메서드 생성
- Lambda 프록시 통합 설정: True
- 배포 스테이지: prod

---

## 7. 보안 및 민감 정보 관리

- Firebase 제거됨
- 환경변수 또는 `secrets.dart` 파일 사용 권장
- 비공개 설정은 `.gitignore`에 추가

---

## 8. 유의 사항

- Flutter 3.13 이상과 Dart 3.x 이상 권장
- Windows에서는 WSL 또는 PowerShell 권장
- AndroidManifest와 iOS 권한 설정 확인 (인터넷 사용 등)
