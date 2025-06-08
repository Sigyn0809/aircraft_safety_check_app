# AWS Lambda 연동 및 Flutter 앱 통합 과정 기록

## 프로젝트 목적
Flutter 앱에서 사용자가 입력한 flight number를 기반으로 AWS Lambda에서
- DynamoDB에서 센서 데이터를 조회하고
- 머신러닝 모델로 이상 여부를 예측하여
- 결과를 앱에 표시하는 구조 구현

## 기존 구조의 한계 및 전환 이유

### Firebase + TFLite 기반 구조의 문제점
- Firebase Functions에서 `.tflite` 모델 추론이 복잡하거나 제한적
- Flutter 내 `.tflite` 모델 로드 중 용량 문제, 호환성 문제 발생

### AWS Lambda + Docker 구조로 전환한 이유
- SavedModel 형태의 모델을 컨테이너 환경에서 자유롭게 로딩 가능
- API Gateway와 Lambda를 통해 서버리스 방식으로 Flutter 앱에 연동 가능
- 비용 없이 확장 가능하고 유지보수가 쉬움

---

## 변경 요약

- Flutter 앱에서 Firebase 의존성 제거
- `anomaly_model.h5` → SavedModel(`.keras`) 변환
- Lambda Docker 환경 구축 및 AWS ECR 배포
- API Gateway REST API 생성 및 CORS 허용
- Flutter에서 `http.post()`를 통해 Lambda 호출
- Flutter 결과 화면에 센서 데이터 + 이상 여부 출력
- 이상 감지 시 같은 노선의 정상 항공편을 추천하는 기능 추가
- 추천 항공편은 캐시 테이블(`FlightRecommendationCache`)에 저장하여 성능 최적화

---

## 에러 해결 및 시행착오

| 이슈 | 해결 방식 |
|------|------------|
| KeyError: 'body' | Lambda에서 `event['body']` → `event.get('flight_number')` 구조로 수정 |
| Flutter 앱에서 JSON 구조 파싱 실패 | 응답이 이중 JSON 구조 → `jsonDecode(response.body)['body']`로 파싱 |
| Decimal 타입 직렬화 오류 | DynamoDB에서 가져온 숫자를 `float()`으로 변환 후 `json.dumps()` 처리 |
| Lambda 로그 미출력 | `print(json.dumps(event))` 위치 조정 + 이미지 업데이트 확인 |
| Lambda 함수는 테스트 성공, Flutter에서는 실패 | `event` 구조가 달랐기 때문 → 수동 테스트 JSON 구조 변경 (`{"flight_number": "FN2000"}`)

---

## 최종 테스트 결과
- 입력: `FN2000`
- Lambda에서 DynamoDB 조회 + 모델 추론 → `anomaly = 0`
- Flutter에서 센서 값, 이상 여부 모두 정상 표시됨
- 이상인 경우 추천 항공편까지 조회되고 정상 결과 출력됨

---

## 브랜치 정보
- 기능 브랜치: `feat/aws-lambda-anomaly`
- PR 대상 브랜치: `dev`

---

## 향후 개선 아이디어
- AWS Cognito 기반 관리자 로그인 기능과 연동 완료
- 사용자별 조회 이력 저장 기능 확장 예정
- Lambda 예측 결과를 기반으로 차트 시각화 기능 추가
- 관리자 화면: 센서 데이터 등록/수정 기능 안정화 및 UI 개선
