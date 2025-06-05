import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://7qi505k421.execute-api.ap-northeast-2.amazonaws.com/prod';

  static Future<Map<String, dynamic>> checkAnomaly(String flightNumber) async {
    final url = Uri.parse('$_baseUrl/check');

    print('📤 Sending JSON: ${jsonEncode({'flight_number': flightNumber})}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'flight_number': flightNumber}),
    );

    print('📥 응답 코드: ${response.statusCode}');
    print('📦 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final outer = jsonDecode(response.body);
      final inner = outer is Map && outer['body'] is String
          ? jsonDecode(outer['body'])
          : outer;
      print('✅ Parsed Inner: $inner');
      return inner;
    } else if (response.statusCode == 404) {
      throw Exception('NOT_FOUND');
    } else {
      throw Exception('SERVER_ERROR');
    }
  }
}
