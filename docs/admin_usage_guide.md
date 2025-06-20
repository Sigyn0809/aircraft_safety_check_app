## Admin 기능 사용 가이드

이 문서는 Aircraft Safety Check App의 관리자(Admin) 기능 사용법을 정리한 가이드입니다. 관리자 전용 화면에서는 Flight Number 데이터를 등록하거나 수정할 수 있습니다.

---

## 관리자 접근 방법

1. 앱 실행 후 로그인 화면에서 "관리자 로그인" 선택  \
2. 로그인 화면에서 등록된 관리자 ID / 비밀번호 입력
3. 로그인 성공 시 관리자 전용 페이지로 이동

> 관리자 인증은 AWS Cognito 기반으로 구현되어 있으며, 로그인 시 발급된 ID Token을 이용해 `/admin` 경로의 API 호출이 인증됩니다.

---

## Flight Number 조회

- Flight Number 입력 후 [Search] 버튼 클릭  
- 해당 번호가 존재할 경우: 입력 필드에 기존 값 표시  
- 존재하지 않을 경우: 모든 필드 비워짐, 새 입력 가능 상태로 전환

---

## Flight 정보 등록 및 수정

### 등록하기

- 조회한 Flight Number가 없을 경우 → 필드를 입력하고 [Register] 클릭
- `POST /admin` 요청 발생 → DynamoDB에 항공편 정보 등록
- 필수 항목:  
  - hydraulic_pressure_A  
  - hydraulic_pressure_B  
  - hydraulic_fluid_temp  
  - brake_wear_level
  - fan_blade_wear_score
  - route (예: ICN-LAX)
- 모든 항목이 유효하게 입력되어야 등록 가능  
- 성공 시 "업로드 성공!" 메시지가 스낵바로 표시됨

### 수정하기

- 기존 Flight Number를 조회한 경우 → 데이터 수정 후 [Update] 클릭
- `PUT /admin` 요청 발생 → 해당 항공편 정보 갱신
- 성공 시 동일하게 스낵바 알림 표시됨

---

## 입력 오류 처리

- 모든 필드는 필수 입력입니다. 빈 값이 있는 경우 등록 또는 수정 불가  
- 숫자가 아닌 형식 등 유효하지 않은 값은 서버에서 거부됨  
- 오류 발생 시:  
  - "모든 값을 입력해 주세요" 또는  
  - "서버 오류" 메시지가 스낵바로 표시됨

---

## 주요 화면 흐름

1. Flight Number 입력 → [Search] 버튼 클릭  
2. 존재 시: 기존 값 표시 / 미존재 시: 빈 입력 필드 제공  
3. 값 입력 후 [Register] 또는 [Update] 버튼 클릭  
4. 결과 메시지 스낵바로 안내 표시

---

## 참고 사항

- 이 기능은 일반 사용자 화면에서는 제공되지 않음  
- 모든 등록 및 수정 요청은 API Gateway를 통해 Lambda에 POST 또는 PUT 방식으로 전달됨
