## Lambda 함수 구조 및 TensorFlow 모델 연동 방식

이 문서는 Aircraft Safety Check App의 AWS Lambda 함수 내부 구조, TensorFlow 모델 로딩 및 추론 방식, Docker 배포 흐름에 대해 설명합니다.

---

## 기본 구조

Lambda 함수는 `httpMethod` 값을 기준으로 `GET`, `POST`, `PUT` 요청을 분기하여 처리합니다.

```python
method = event.get("httpMethod", "POST")
```

각 메서드의 처리 방식은 다음과 같습니다:

| 메서드 | 기능 |
|--------|------|
| GET    | DynamoDB에서 flight_number에 해당하는 센서 데이터 조회 |
| POST   | flight_number로 기존 데이터 조회 후 추론 또는 신규 등록 |
| PUT    | flight_number에 해당하는 센서 데이터 수정 |

---

## TensorFlow 모델 연동

### 모델 포맷

- `.tflite` 포맷은 제거됨
- 현재는 `.keras` 포맷 사용 (Keras 3 기반)

### 모델 로딩

```python
model = tf.keras.models.load_model("anomaly_model")
infer = model.signatures["serving_default"]
```

- 모델은 Lambda 시작 시 한 번 로드됨
- 추론 시 TensorFlow Serving Signature를 통해 실행

### 입력 예시

```python
input_data = np.array([[56.2, 0.48, -458.3, 16.8]], dtype=np.float32)
input_tensor = tf.convert_to_tensor(input_data)
output = infer(input_tensor)
```

---

## 추론 결과 해석

```python
prediction = list(output.values())[0].numpy()
anomaly = int(prediction[0][0] > 0.5)
```

- `0 또는 1`의 이진 분류 결과
- 0: 정상, 1: 이상

---

## Docker 기반 배포 흐름

1. Dockerfile로 Lambda용 Python 환경 구성
2. anomaly_model 포함 후 로컬에서 이미지 빌드

```bash
docker build -t lambda-anomaly .
```

3. AWS ECR로 푸시

```bash
docker tag lambda-anomaly:latest <ECR_URL>
docker push <ECR_URL>
```

4. Lambda에서 이미지 기반 함수로 설정

---

## 오류 처리 구조

```python
except Exception as e:
    return {
        "statusCode": 500,
        "body": json.dumps({"error": str(e)})
    }
```

- 모든 예외는 500 응답으로 반환
- 400, 404, 422 등은 분기별로 명시적 처리

---

## 참고

- Lambda 프록시 통합 사용
- Docker 이미지 내 anomaly_model 파일과 requirements.txt 필요
- 로컬 테스트는 docker run으로 가능
