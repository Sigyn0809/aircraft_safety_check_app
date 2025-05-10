# Admin Flight Insert 기능 업데이트 로그

## 날짜: 2024-05-10  
## 브랜치: feat/admin-insert-flight

### 주요 변경 사항

- 어드민용 Flight Number 입력/수정 기능 구현
- Lambda에서 POST 로직에 신규 항공편 등록 조건 추가
- 입력값 검증 로직 포함 (engine_temp, vibration 등)
- Flutter에서 없는 항공편 입력 시 경고 메시지 스낵바 처리

### 테스트 시나리오

- FN2000 → 수정 성공
- FN3000 → 신규 등록 성공 (모든 필드 입력 시)
- 빈 입력 시 등록 거부 (400 처리)
- 유저 쪽에서 없는 항공편 입력 시 스낵바 출력 확인

### 관련 리소스

- API Gateway: `/check` (GET, POST, PUT)
- Lambda: `anomaly-lambda` (프록시 통합 O)
- Flutter Screen: `FlightEditScreen`, `ApiService.checkAnomaly()`
