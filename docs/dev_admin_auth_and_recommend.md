## 개발 로그: 관리자 로그인 및 추천 항공편 기능 추가

### 주요 기능

1. **관리자 인증 기능**
   - AWS Cognito 기반 로그인
   - 로그인 후 토큰을 이용해 `/admin` 경로 보호 API 호출 가능
   - 로그인 성공 시 자동 로그아웃 처리도 구현됨

2. **항공편 등록 및 수정**
   - 관리자 화면에서 항공편 검색/등록/수정 기능 구현
   - 사용자 접근은 제한되고 인증 필요

3. **이상 감지 후 추천 항공편 제공**
   - 이상 감지 시 같은 노선의 정상 항공편을 자동으로 추천
   - 추론을 통해 anomaly == 0인 항공편이 있을 경우 추천
   - 추천된 결과는 캐시 테이블(`FlightRecommendationCache`)에 저장됨

4. **보안 구조 분리**
   - `/admin/*` → Cognito 인증 필요
   - `/check` → 사용자용, 인증 없이 가능

---

### 기술 사항

- Lambda 내부에서 path(`/check`, `/admin`) 기반 분기 처리
- `/check`: 사용자용 (비인증), `/admin`: 관리자용 (인증)
- Flutter Amplify 연동을 통해 ID Token을 HTTP Authorization 헤더에 포함

---

### API 동작 흐름

- 로그인 성공 → idToken 발급
- Flutter → `Authorization` 헤더 포함 요청
- API Gateway + Lambda → 토큰 검증
