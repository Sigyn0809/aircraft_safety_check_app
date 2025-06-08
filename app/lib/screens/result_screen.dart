import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';

class ResultScreen extends StatelessWidget {
  final String flightNumber;
  final Map<String, dynamic> data;

  const ResultScreen({
    Key? key,
    required this.flightNumber,
    required this.data,
  }) : super(key: key);

  Future<void> _fetchRecommendedFlight(BuildContext context, String recommendedNumber) async {
    try {
      final response = await ApiService.checkAnomaly(recommendedNumber);

      if (response == null || !response.containsKey("anomaly")) {
        throw Exception("INVALID_RESPONSE");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            flightNumber: recommendedNumber,
            data: response,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추천 항공편 정보를 불러오지 못했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anomaly = data['anomaly'] == 1 ? '이상 징후가 감지되었습니다.' : '비행 전 안전 상태가 양호합니다.';
    final recommendedNumber = data['recommended_number'];
    final hasRecommendation = recommendedNumber != null;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFD7EFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Inspection Result',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.04,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Flight Number: ${flightNumber}',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('노선: ${data['route']}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                      SizedBox(height: screenHeight * 0.02),

                      Text('점검 데이터:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                      SizedBox(height: screenHeight * 0.01),
                      Text('• Hydraulic Pressure A: ${data['hydraulic_pressure_A']}', style: TextStyle(fontSize: 20)),
                      SizedBox(height: screenHeight * 0.01),
                      Text('• Hydraulic Pressure B: ${data['hydraulic_pressure_B']}', style: TextStyle(fontSize: 20)),
                      SizedBox(height: screenHeight * 0.01),
                      Text('• Hydraulic Fluid Temp: ${data['hydraulic_fluid_temp']}', style: TextStyle(fontSize: 20)),
                      SizedBox(height: screenHeight * 0.01),
                      Text('• Brake Wear Level: ${data['brake_wear_level']}', style: TextStyle(fontSize: 20)),
                      SizedBox(height: screenHeight * 0.01),
                      Text('• Fan Blade Wear Score: ${data['fan_blade_wear_score']}', style: TextStyle(fontSize: 20)),
                      SizedBox(height: screenHeight * 0.03),

                      Text('감지 결과:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        anomaly,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: anomaly == '이상 징후가 감지되었습니다.' ? Colors.red : Colors.green,
                        ),
                      ),
                      if (anomaly == '이상 징후가 감지되었습니다.' && hasRecommendation) ... [
                        SizedBox(height: screenHeight * 0.04),
                        Divider(),
                        Text('✅ 추천 항공편: $recommendedNumber (정상)',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: screenHeight * 0.01),
                        ElevatedButton(
                          onPressed: () => _fetchRecommendedFlight(context, recommendedNumber),
                          child: Text('자세히 보기'),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
