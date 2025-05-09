import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String flightNumber;
  final Map<String, dynamic> data;

  const ResultScreen({
    Key? key,
    required this.flightNumber,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anomaly = data['anomaly'] == 1 ? '이상 감지됨' : '정상';

    return Scaffold(
      appBar: AppBar(
        title: Text('점검 결과'),
        backgroundColor: Color(0xFF7EC4E3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight Number: $flightNumber',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('점검 데이터:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Engine Temp: ${data['engine_temp']}'),
            Text('Vibration: ${data['vibration']}'),
            Text('Altitude Error: ${data['altitude_error']}'),
            Text('Oil Pressure: ${data['oil_pressure']}'),
            SizedBox(height: 20),
            Text('감지 결과:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              anomaly,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: data['anomaly'] == 1 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
