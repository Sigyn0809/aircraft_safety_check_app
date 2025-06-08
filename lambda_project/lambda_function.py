import json
import boto3
import numpy as np
import tensorflow as tf
from decimal import Decimal
from boto3.dynamodb.conditions import Attr

# 모델 로드
model = tf.keras.models.load_model('anomaly_model')
infer = model.signatures["serving_default"]

# DynamoDB 연결
dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-2')
table = dynamodb.Table('FlightSensorData')
cache_table = dynamodb.Table('FlightRecommendationCache')

def convert_decimal(obj):
    if isinstance(obj, list):
        return [convert_decimal(i) for i in obj]
    elif isinstance(obj, dict):
        return {k: convert_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, Decimal):
        return float(obj)
    else:
        return obj

def handle_recommendation(flight_number):
    response = table.get_item(Key={"flight_number": flight_number})
    item = response.get("Item")
    if not item:
        return {"statusCode": 404, "body": json.dumps({"error": "Flight not found"})}

    print("🔍 캐시 테이블 조회 중...")
    cache_response = cache_table.scan(FilterExpression=Attr("route").eq(item["route"]))
    cached_items = cache_response.get("Items", [])
    recommended_item = next((i for i in cached_items if i["flight_number"] != flight_number), None)

    if recommended_item:
        print(f"✅ 캐시 추천 사용: {recommended_item['flight_number']}")
        return {
            "statusCode": 200,
            "body": json.dumps({"recommended_number": recommended_item["flight_number"]})
        }

    print("♻️ 캐시 미스. 재추론 시도 중...")
    scan_response = table.scan(FilterExpression=Attr("route").eq(item["route"]))
    for candidate in scan_response.get("Items", []):
        if candidate["flight_number"] == flight_number:
            continue

        input_data = np.array([[float(candidate["hydraulic_pressure_A"]),
                                float(candidate["hydraulic_pressure_B"]),
                                float(candidate["hydraulic_fluid_temp"]),
                                float(candidate["brake_wear_level"]),
                                float(candidate["fan_blade_wear_score"])]], dtype=np.float32)

        input_tensor = tf.convert_to_tensor(input_data)
        prediction = list(infer(input_tensor).values())[0].numpy()
        anomaly = int(prediction[0][0] > 0.5)

        if anomaly == 0:
            print(f"✅ 추천용 정상 항공편 발견: {candidate['flight_number']}")
            cache_table.put_item(Item={
                "flight_number": candidate["flight_number"],
                "hydraulic_pressure_A": Decimal(str(candidate["hydraulic_pressure_A"])),
                "hydraulic_pressure_B": Decimal(str(candidate["hydraulic_pressure_B"])),
                "hydraulic_fluid_temp": Decimal(str(candidate["hydraulic_fluid_temp"])),
                "brake_wear_level": Decimal(str(candidate["brake_wear_level"])),
                "fan_blade_wear_score": Decimal(str(candidate["fan_blade_wear_score"])),
                "route": candidate["route"]
            })
            return {
                "statusCode": 200,
                "body": json.dumps({"recommended_number": candidate["flight_number"]})
            }

    print("❌ 추천 가능한 정상 항공편 없음.")
    return {"statusCode": 200, "body": json.dumps({})}


def lambda_handler(event, context):
    method = event.get("httpMethod", "POST")
    path = event.get("resource", "/check")  # 예: "/check" 또는 "/admin"
    print(f"🟡 Method: {method}")
    print(f"🟡 Path: {path}")
    print("🟡 Event:", json.dumps(event))

    try:
        is_admin = path.startswith("/admin")

        # ✅ 사용자용 GET (조회 또는 추천)
        if method == "GET" and not is_admin:
            query = event.get("queryStringParameters", {}) or {}

            if "recommend_for" in query:
                return handle_recommendation(query["recommend_for"])

            flight_number = query.get("flight_number")
            if not flight_number:
                return {"statusCode": 400, "body": json.dumps({"error": "Missing flight_number"})}

            response = table.get_item(Key={"flight_number": flight_number})
            item = response.get("Item")
            if not item:
                return {"statusCode": 404, "body": json.dumps({"error": "Flight not found"})}

            converted_item = convert_decimal(item)
            return {"statusCode": 200, "body": json.dumps(converted_item)}
        
        # ✅ 관리자용 GET (항공편 정보 조회)
        elif method == "GET" and is_admin:
            query = event.get("queryStringParameters", {}) or {}

            flight_number = query.get("flight_number")
            if not flight_number:
                return {"statusCode": 400, "body": json.dumps({"error": "Missing flight_number"})}

            response = table.get_item(Key={"flight_number": flight_number})
            item = response.get("Item")
            if not item:
                return {"statusCode": 404, "body": json.dumps({"error": "Flight not found"})}

            return {"statusCode": 200, "body": json.dumps(item, default=str)}

        
        # ✅ 사용자용 POST (이상 여부 판별)
        elif method == "POST" and not is_admin:
            body = json.loads(event.get("body", "{}"))
            flight_number = body.get("flight_number")
            if not flight_number:
                return {"statusCode": 400, "body": json.dumps({"error": "Missing flight_number"})}

            response = table.get_item(Key={"flight_number": flight_number})
            item = response.get("Item")
            if not item:
                return {"statusCode": 404, "body": json.dumps({"error": "Flight not found"})}

            input_data = np.array([[float(item["hydraulic_pressure_A"]),
                                    float(item["hydraulic_pressure_B"]),
                                    float(item["hydraulic_fluid_temp"]),
                                    float(item["brake_wear_level"]),
                                    float(item["fan_blade_wear_score"])]], dtype=np.float32)

            input_tensor = tf.convert_to_tensor(input_data)
            prediction = list(infer(input_tensor).values())[0].numpy()
            anomaly = int(prediction[0][0] > 0.5)

            result = {
                "anomaly": anomaly,
                "flight_number": flight_number,
                "route": item["route"],
                "hydraulic_pressure_A": float(item["hydraulic_pressure_A"]),
                "hydraulic_pressure_B": float(item["hydraulic_pressure_B"]),
                "hydraulic_fluid_temp": float(item["hydraulic_fluid_temp"]),
                "brake_wear_level": float(item["brake_wear_level"]),
                "fan_blade_wear_score": float(item["fan_blade_wear_score"])
            }

            if anomaly == 1:
                rec_result = handle_recommendation(flight_number)
                rec_body = json.loads(rec_result["body"])
                result.update(rec_body)

            return {"statusCode": 200, "body": json.dumps(result)}

        # ✅ 관리자용 POST (항공편 등록)
        elif method == "POST" and is_admin:
            body = json.loads(event.get("body", "{}"))
            flight_number = body.get("flight_number")
            if not flight_number:
                return {"statusCode": 400, "body": json.dumps({"error": "Missing flight_number"})}

            response = table.get_item(Key={"flight_number": flight_number})
            if response.get("Item"):
                return {"statusCode": 400, "body": json.dumps({"error": "Flight already exists"})}

            required_fields = [
                "hydraulic_pressure_A", "hydraulic_pressure_B",
                "hydraulic_fluid_temp", "brake_wear_level",
                "fan_blade_wear_score", "route"
            ]
            for field in required_fields:
                if field not in body or body[field] in (None, "", "null"):
                    return {"statusCode": 400, "body": json.dumps({"error": f"Missing or invalid field: {field}"})}

            table.put_item(Item={
                "flight_number": flight_number,
                "hydraulic_pressure_A": Decimal(str(body["hydraulic_pressure_A"])),
                "hydraulic_pressure_B": Decimal(str(body["hydraulic_pressure_B"])),
                "hydraulic_fluid_temp": Decimal(str(body["hydraulic_fluid_temp"])),
                "brake_wear_level": Decimal(str(body["brake_wear_level"])),
                "fan_blade_wear_score": Decimal(str(body["fan_blade_wear_score"])),
                "route": body["route"]
            })
            return {"statusCode": 200, "body": json.dumps({"message": "Flight added"})}

        # ✅ 관리자용 PUT (항공편 수정)
        elif method == "PUT" and is_admin:
            body = json.loads(event.get("body", "{}"))
            flight_number = body.get("flight_number")
            if not flight_number:
                return {"statusCode": 400, "body": json.dumps({"error": "Missing flight_number"})}

            response = table.get_item(Key={"flight_number": flight_number})
            item = response.get("Item")
            if not item:
                return {"statusCode": 404, "body": json.dumps({"error": "Flight not found"})}

            table.put_item(Item={
                "flight_number": flight_number,
                "hydraulic_pressure_A": Decimal(str(body["hydraulic_pressure_A"])),
                "hydraulic_pressure_B": Decimal(str(body["hydraulic_pressure_B"])),
                "hydraulic_fluid_temp": Decimal(str(body["hydraulic_fluid_temp"])),
                "brake_wear_level": Decimal(str(body["brake_wear_level"])),
                "fan_blade_wear_score": Decimal(str(body["fan_blade_wear_score"])),
                "route": body["route"]
            })
            return {"statusCode": 200, "body": json.dumps({"message": "Flight updated"})}

        # ❌ 허용되지 않은 메서드
        else:
            return {"statusCode": 405, "body": json.dumps({"error": "Method not allowed"})}

    except Exception as e:
        print(f"❗ 오류 발생: {str(e)}")
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
