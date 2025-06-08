# API 설계 및 엔드포인트 명세

Aircraft Safety Check App은 AWS API Gateway를 통해 Lambda 함수와 통신하며, 사용자와 관리자의 요청을 분리하여 처리하는 RESTful API 구조를 따릅니다.

---

## 공통 정보

- **Base URL**: `https://<api-id>.execute-api.ap-northeast-2.amazonaws.com/prod`
- **요청 및 응답 형식**: JSON (`Content-Type: application/json`)
- **Lambda 프록시 통합**: 사용 중
- **인증 여부**:
  - `/check` 경로: **비인증**, 일반 사용자 접근
  - `/admin` 경로: **인증 필요**, 관리자만 접근 (Cognito 토큰 필요)

---

## 1. 사용자 API

### [GET] /check

#### 설명
Flight Number에 해당하는 센서 데이터를 조회하거나, `recommend_for` 파라미터를 통해 추천 항공편을 요청합니다.

#### 요청 예시
```
GET /check?flight_number=BX7494
GET /check?recommend_for=BX7494
```

#### 응답 예시 (조회 성공)
```json
{
  "flight_number": "BX7494",
  "hydraulic_pressure_A": 2650.0,
  "hydraulic_pressure_B": 2600.0,
  "hydraulic_fluid_temp": 54.0,
  "brake_wear_level": 22.0,
  "fan_blade_wear_score": 3.1,
  "route": "ICN-NRT"
}
```

#### 응답 예시 (추천 항공편)
```json
{
  "recommended_number": "BX7512"
}
```

---

### [POST] /check

#### 설명
Flight Number만 제공하면 이상 감지를 수행하고, 결과에 따라 추천 항공편도 포함됩니다.

#### 요청 본문 예시
```json
{
  "flight_number": "BX7494"
}
```

#### 응답 예시 (anomaly 감지 + 추천)
```json
{
  "anomaly": 1,
  "recommended_number": "BX7512"
}
```

#### 응답 예시 (정상)
```json
{
  "anomaly": 0
}
```

---

## 2. 관리자 API (인증 필요)

### [GET] /admin

#### 설명
관리자가 입력한 Flight Number의 센서 데이터를 조회합니다. 사용자 GET과 응답 형식은 동일하지만, Cognito 토큰이 필요합니다.

#### 요청 예시
```
GET /admin?flight_number=BX7494
Authorization: Bearer <ID_TOKEN>
```

---

### [POST] /admin

#### 설명
항공편 정보를 신규 등록합니다.

#### 요청 본문
```json
{
  "flight_number": "BX7494",
  "hydraulic_pressure_A": 2650.0,
  "hydraulic_pressure_B": 2600.0,
  "hydraulic_fluid_temp": 54.0,
  "brake_wear_level": 22.0,
  "fan_blade_wear_score": 3.1,
  "route": "ICN-NRT"
}
```

#### 응답
```json
{
  "message": "Flight added"
}
```

---

### [PUT] /admin

#### 설명
기존 항공편 정보를 수정합니다. `flight_number`가 존재해야 합니다.

#### 요청 본문
```json
{
  "flight_number": "BX7494",
  "hydraulic_pressure_A": 2600.0,
  "hydraulic_pressure_B": 2590.0,
  "hydraulic_fluid_temp": 52.5,
  "brake_wear_level": 23.0,
  "fan_blade_wear_score": 2.9,
  "route": "ICN-NRT"
}
```

#### 응답
```json
{
  "message": "Flight updated"
}
```

---

## 3. 응답 코드 요약

| 코드 | 설명 |
|------|------|
| 200  | 요청 성공 |
| 400  | 필드 누락 또는 형식 오류 |
| 401  | 인증되지 않은 요청 (관리자 API에서 발생) |
| 404  | Flight Number를 찾을 수 없음 |
| 405  | 지원되지 않는 메서드 |
| 500  | Lambda 내부 처리 중 에러 발생 |
