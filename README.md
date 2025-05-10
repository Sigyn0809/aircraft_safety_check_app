# Admin Flight Control Feature

이 브랜치는 어드민이 Flight Number 데이터를 직접 입력하고 수정할 수 있도록 기능을 확장한 브랜치입니다.

## 기능 요약

- Flight Number 조회(GET)
- 기존 정보 수정(PUT)
- 신규 Flight 데이터 입력(POST)
- 필드 유효성 검증 (빈 값 허용 X)

## Lambda 함수 변경 사항

- POST: 존재하지 않는 Flight Number에 대해 필수 항목이 있을 경우 신규 등록
- PUT: 기존 항목 수정
- GET: 존재 여부 판단 후 필드 제공

## 적용 경로

- Flutter: `/admin/edit`
- Lambda: `anomaly-lambda`
- API Gateway: `/check` 엔드포인트
