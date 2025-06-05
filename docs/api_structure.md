## API 설계 및 엔드포인트 명세

Aircraft Safety Check App은 AWS API Gateway를 통해 Lambda 함수와 통신하며, 다음과 같은 RESTful API 구조를 따릅니다.

---

## 공통 사항

- **Base URL**: `https://<api-id>.execute-api.ap-northeast-2.amazonaws.com/prod`
- **엔드포인트**: `/check`
- **요청 및 응답 형식**: JSON (`Content-Type: application/json`)
- **Lambda 프록시 통합**: 사용 중

---

## [GET] /check

### 설명
Flight Number에 해당하는 센서 데이터를 조회합니다.

### 요청
- 쿼리 파라미터: `?flight_number=FN2001`

### 예시
```
GET /check?flight_number=FN2001
```

### 응답 (200 OK)
```json
{
  "flight_number": "FN2001",
  "engine_temp": 56.2,
  "vibration": 0.48,
  "altitude_error": -458.3,
  "oil_pressure": 16.8
}
```

### 응답 (404 Not Found)
```json
{
  "error": "Flight number not found"
}
```

---

## [POST] /check

### 설명
기존 Flight Number가 존재할 경우 모델 추론을 수행하고, 존재하지 않으면 새 데이터를 등록합니다.

### 요청 본문
```json
{
  "flight_number": "FN3001",
  "engine_temp": "65.2",
  "vibration": "0.52",
  "altitude_error": "-421.0",
  "oil_pressure": "14.5"
}
```

- Flight Number만 있을 경우 → 추론
- 필드가 전부 있으면 → 등록

### 응답 (예: 추론 성공)
```json
{
  "flight_number": "FN3001",
  "anomaly": 1,
  "engine_temp": 65.2,
  "vibration": 0.52,
  "altitude_error": -421.0,
  "oil_pressure": 14.5
}
```

### 응답 (400 Bad Request)
```json
{
  "error": "Missing or invalid field: engine_temp"
}
```

---

## [PUT] /check

### 설명
기존 Flight Number에 대해 센서 데이터를 수정합니다.

### 요청 본문
```json
{
  "flight_number": "FN3001",
  "engine_temp": "70.0",
  "vibration": "0.50",
  "altitude_error": "-430.0",
  "oil_pressure": "18.0"
}
```

### 응답 (200 OK)
```json
{
  "message": "Item updated"
}
```

---

## 응답 코드 요약

| 코드 | 설명 |
|------|------|
| 200  | 요청 성공 |
| 400  | 필드 누락, 형식 오류 등 잘못된 요청 |
| 404  | Flight Number가 존재하지 않음 |
| 422  | Flight 등록 불가 상태 (데이터 부족 시 Lambda에서 사용할 수 있음) |
