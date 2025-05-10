import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlightEditScreen extends StatefulWidget {
  @override
  _FlightEditScreenState createState() => _FlightEditScreenState();
}

class _FlightEditScreenState extends State<FlightEditScreen> {
  final flightNumberController = TextEditingController();
  final engineTempController = TextEditingController();
  final vibrationController = TextEditingController();
  final altitudeErrorController = TextEditingController();
  final oilPressureController = TextEditingController();

  bool isEditing = false;
  String apiUrl = "https://7qi505k421.execute-api.ap-northeast-2.amazonaws.com/prod/check";

  void fetchFlightData() async {
    final flightNumber = flightNumberController.text.trim();
    print("🧪 입력된 Flight Number: $flightNumber");
    if (flightNumber.isEmpty) return;

    final uri = Uri.parse('$apiUrl?flight_number=$flightNumber');
    print("📡 요청 URI: $uri");
    final response = await http.get(uri);

    print("🔵 [DEBUG] raw response.body = ${response.body}"); // 1차 출력

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("🟢 [DEBUG] decoded data = $data"); // 최종 파싱된 객체 확인

      setState(() {
        isEditing = true;
        engineTempController.text = data['engine_temp'].toString();
        vibrationController.text = data['vibration'].toString();
        altitudeErrorController.text = data['altitude_error'].toString();
        oilPressureController.text = data['oil_pressure'].toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("데이터를 불러왔습니다.")));
    } else {
      print("🔴 [DEBUG] GET 요청 실패: ${response.statusCode}");
      setState(() {
        isEditing = false;
        engineTempController.clear();
        vibrationController.clear();
        altitudeErrorController.clear();
        oilPressureController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("기존 데이터 없음. 새로 입력해 주세요.")));
    }
  }


  void submitData() async {
    final flightNumber = flightNumberController.text.trim();
    // 모든 필드 유효성 검사
    if (flightNumber.isEmpty ||
        engineTempController.text.trim().isEmpty ||
        vibrationController.text.trim().isEmpty ||
        altitudeErrorController.text.trim().isEmpty ||
        oilPressureController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("모든 값을 입력해 주세요."))
      );
      return;
    }

    final uri = Uri.parse(apiUrl);  // 반드시 "/check" 포함
    final method = isEditing ? 'PUT' : 'POST';

    final body = {
      "flight_number": flightNumber,
      "engine_temp": engineTempController.text.trim(),
      "vibration": vibrationController.text.trim(),
      "altitude_error": altitudeErrorController.text.trim(),
      "oil_pressure": oilPressureController.text.trim()
    };

    final request = http.Request(method, uri)
      ..headers['Content-Type'] = 'application/json'
      ..body = json.encode(body);

    final streamed = await request.send();
    final result = await http.Response.fromStream(streamed);

    print("🔁 응답 코드: ${result.statusCode}");
    print("📦 응답 내용: ${result.body}");

    if (result.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("업로드 성공!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("실패: ${result.statusCode}")));
    }
  }


  @override
  void dispose() {
    flightNumberController.dispose();
    engineTempController.dispose();
    vibrationController.dispose();
    altitudeErrorController.dispose();
    oilPressureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flight 상태 수정/추가")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: flightNumberController,
              decoration: InputDecoration(labelText: 'Flight Number'),
            ),
            ElevatedButton(
              onPressed: fetchFlightData,
              child: Text("조회"),
            ),
            TextField(
              controller: engineTempController,
              decoration: InputDecoration(labelText: 'Engine Temperature'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: vibrationController,
              decoration: InputDecoration(labelText: 'Vibration'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: altitudeErrorController,
              decoration: InputDecoration(labelText: 'Altitude Error'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: oilPressureController,
              decoration: InputDecoration(labelText: 'Oil Pressure'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              child: Text(isEditing ? "수정하기" : "등록하기"),
            ),
          ],
        ),
      ),
    );
  }
}
