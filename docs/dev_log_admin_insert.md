## 기능 개발 로그 - Admin 입력 기능 (`feat/admin-insert-flight`)

이 문서는 어드민이 Flight Number 데이터를 등록 및 수정할 수 있도록 기능을 확장한 개발 과정을 정리한 기록입니다.

---

## 개발 목적

- 기존 사용자 기능은 조회 및 이상 판별에 한정됨
- 어드민이 신규 항공편을 등록하거나 기존 항공편의 센서 데이터를 수정할 수 있도록 기능 추가

---

## 주요 기능

- Flight Number를 입력하여 조회 (존재 시 수정 가능, 미존재 시 등록)
- 필드 유효성 검증: 모든 센서 값 필수
- Flutter UI 구성: `flight_edit_screen.dart`
- Lambda POST 분기 로직:
  - 기존 데이터 존재: 모델 추론
  - 데이터 미존재 + 값 존재: 신규 등록
- Lambda PUT: 기존 데이터 수정

---

## Lambda 주요 변경 내역

- `POST`: 기존 여부 확인 → 등록 또는 추론 분기
- `PUT`: 기존 키에 대해 센서값 업데이트
- 에러 코드 명확화:
  - 200: 성공
  - 400: 필드 누락
  - 404: Flight Number 없음
  - 422: 추론 불가능 상태

---

## Flutter 변경 내역

- 신규 화면 `flight_edit_screen.dart` 생성
- ApiService 수정: POST/PUT에 json body 전달
- 사용자 입력 유효성 검사 및 스낵바 메시지 추가
- 오류 메시지를 사용자 친화적으로 단순화:
  - "존재하지 않는 Flight Number입니다. 다시 입력해 주세요."
  - "모든 항목을 입력해 주세요."

---

## Git 브랜치 및 병합 내역

- 브랜치 생성: `feat/admin-insert-flight`
- 주요 커밋 메시지:
  - `feat: add admin functionality to register and modify flight data`
  - `resolve: merge dev with folder structure changes`
- 병합 경로:
  - `feat/admin-insert-flight` → `dev` → `master`
- 충돌 해결:
  - 폴더 구조 변경으로 인한 rename/delete conflict 발생
  - `flight_edit_screen.dart` 위치 이동
  - `firebase.json`, `firebase_options.dart` 등 제거된 파일 확인 및 정리

---

## 테스트 시나리오

- 존재하는 Flight Number 조회 후 수정
- 존재하지 않는 Flight Number 등록 (모든 필드 입력 시)
- 필드 누락 시 등록 실패
- 사용자 쪽에서 없는 번호 입력 시 에러 메시지 출력

---

## 릴리스 로그

| 날짜       | 브랜치                   | 내용                                      |
|------------|--------------------------|-------------------------------------------|
| 2024-05-10 | feat/admin-insert-flight | 기능 브랜치 생성 및 개발 완료             |
| 2024-05-10 | dev                      | 병합 완료                                 |
| 2024-05-10 | master                   | 최종 병합 및 릴리스                       |

---

## 참고 사항

- API 명세와 Lambda 구조는 `api_structure.md`, `lambda_architecture.md` 문서 참고
