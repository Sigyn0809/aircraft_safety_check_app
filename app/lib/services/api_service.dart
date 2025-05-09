import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://7qi505k421.execute-api.ap-northeast-2.amazonaws.com/prod';

  static Future<Map<String, dynamic>> checkAnomaly(String flightNumber) async {
    final url = Uri.parse('$_baseUrl/check');

    print('Sending JSON: ${jsonEncode({'flight_number': flightNumber})}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'flight_number': flightNumber}),
    );

    if (response.statusCode == 200) {
      print('RAW RESPONSE BODY: ${response.body}');
      final outer = jsonDecode(response.body);
      final inner = outer is Map && outer['body'] is String
          ? jsonDecode(outer['body'])
          : outer;
      print('Parsed Inner: $inner'); // ✅ 파싱 결과 확인
      return inner;
    } else {
      throw Exception('API 호출 실패: ${response.body}');
    }
  }
}
