import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class FlightEditScreen extends StatefulWidget {
  @override
  _FlightEditScreenState createState() => _FlightEditScreenState();
}

class _FlightEditScreenState extends State<FlightEditScreen> {
  final flightNumberController = TextEditingController();
  final hydraulicPressureAController = TextEditingController();
  final hydraulicPressureBController = TextEditingController();
  final hydraulicFluidTempController = TextEditingController();
  final brakeWearLevelController = TextEditingController();
  final fanBladeWearScoreController = TextEditingController();
  final routeController = TextEditingController();

  bool isEditing = false;
  bool _isSearching = false;
  bool _isSubmitting = false;
  String apiUrl = "https://7qi505k421.execute-api.ap-northeast-2.amazonaws.com/prod/admin";

  void fetchFlightData() async {
    final flightNumber = flightNumberController.text.trim();
    if (flightNumber.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final token = session.userPoolTokens?.idToken.raw;

      final uri = Uri.parse('$apiUrl?flight_number=$flightNumber');
      final response = await http.get(uri, headers: {
        'Authorization': token ?? '',
      });

      print("📡 statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          isEditing = true;
          hydraulicPressureAController.text = data['hydraulic_pressure_A'].toString();
          hydraulicPressureBController.text = data['hydraulic_pressure_B'].toString();
          hydraulicFluidTempController.text = data['hydraulic_fluid_temp'].toString();
          brakeWearLevelController.text = data['brake_wear_level'].toString();
          fanBladeWearScoreController.text = data['fan_blade_wear_score'].toString();
          routeController.text = data['route']?.toString() ?? "";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFB3E5FC),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Center(
              heightFactor: 1,
              child: Text(
                "데이터를 불러왔습니다.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        setState(() {
          isEditing = false;
          hydraulicPressureAController.clear();
          hydraulicPressureBController.clear();
          hydraulicFluidTempController.clear();
          brakeWearLevelController.clear();
          fanBladeWearScoreController.clear();
          routeController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFB3E5FC),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Center(
              heightFactor: 1,
              child: Text(
                "기존 데이터 없음. 새로 입력해 주세요.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("🔥 fetchFlightData exception: $e");
    }

    setState(() => _isSearching = false);
  }

  void submitData() async {
    final flightNumber = flightNumberController.text.trim();
    if (flightNumber.isEmpty ||
        hydraulicPressureAController.text.trim().isEmpty ||
        hydraulicPressureBController.text.trim().isEmpty ||
        hydraulicFluidTempController.text.trim().isEmpty ||
        brakeWearLevelController.text.trim().isEmpty ||
        fanBladeWearScoreController.text.trim().isEmpty ||
        routeController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFFFE0B2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Center(
            heightFactor: 1,
            child: Text(
              "모든 값을 입력해 주세요.",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      return;
    }

    final uri = Uri.parse(apiUrl);
    final method = isEditing ? 'PUT' : 'POST';

    final body = {
      "flight_number": flightNumber,
      "hydraulic_pressure_A": hydraulicPressureAController.text.trim(),
      "hydraulic_pressure_B": hydraulicPressureBController.text.trim(),
      "hydraulic_fluid_temp": hydraulicFluidTempController.text.trim(),
      "brake_wear_level": brakeWearLevelController.text.trim(),
      "fan_blade_wear_score": fanBladeWearScoreController.text.trim(),
      "route": routeController.text.trim()
    };

    setState(() => _isSubmitting = true);

    try {
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final token = session.userPoolTokens?.idToken.raw;

      final request = http.Request(method, uri)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = token ?? ''
        ..body = json.encode(body);

      final streamed = await request.send();
      final result = await http.Response.fromStream(streamed);

      if (result.statusCode == 200) {
        final msg = isEditing ? "수정이 완료되었습니다" : "항공편 등록 성공!";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFEEEEEE),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Center(
              heightFactor: 1,
              child: Text(
                msg,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFFFCDD2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Center(
              heightFactor: 1,
              child: Text(
                "서버 오류가 발생했습니다",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("🔥 submitData exception: \$e");
    }

    setState(() => _isSubmitting = false);
  }

  @override
  void dispose() {
    flightNumberController.dispose();
    hydraulicPressureAController.dispose();
    hydraulicPressureBController.dispose();
    hydraulicFluidTempController.dispose();
    brakeWearLevelController.dispose();
    fanBladeWearScoreController.dispose();
    routeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            try {
              await Amplify.Auth.signOut(); // 로그아웃 완료될 때까지 대기
              print("✅ 로그아웃 완료됨");
              Navigator.pop(context);       // 로그아웃 완료 후 화면 이동
            } catch (e) {
              print("🔥 로그아웃 실패: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("로그아웃에 실패했습니다."),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Edit Flight Data',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.12,
          vertical: screenHeight * 0.01,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Flight Number", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: flightNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter Flight Number",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSearching ? null : fetchFlightData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF87CEEB),
                      disabledBackgroundColor: Color(0xFF87CEEB),
                      foregroundColor: Colors.white,
                      minimumSize: Size(80, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 4,
                    ),
                    child: _isSearching
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : Text("Search", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var field in [
                      ['Hydraulic Pressure A', hydraulicPressureAController, TextInputType.number],
                      ['Hydraulic Pressure B', hydraulicPressureBController, TextInputType.number],
                      ['Hydraulic Fluid Temp', hydraulicFluidTempController, TextInputType.number],
                      ['Brake Wear Level', brakeWearLevelController, TextInputType.number],
                      ['Fan Blade Wear Score', fanBladeWearScoreController, TextInputType.number],
                      ['Route (예: ICN-PUS)', routeController, TextInputType.text],
                    ])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(field[0] as String, style: TextStyle(fontSize: 16)),
                          TextField(
                            controller: field[1] as TextEditingController,
                            keyboardType: field[2] as TextInputType,
                            decoration: InputDecoration(
                              hintText: 'Enter ${field[0]}',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF87CEEB),
                    disabledBackgroundColor: Color(0xFF87CEEB),
                    foregroundColor: Colors.white,
                    minimumSize: Size(150, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : Text(isEditing ? "Update" : "Register", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
