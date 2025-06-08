import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

Future<void> _configureAmplify() async {
  final auth = AmplifyAuthCognito();
  try {
    await Amplify.addPlugin(auth);
    await Amplify.configure(amplifyconfig);
    debugPrint('✅ Amplify configured successfully');
  } catch (e) {
    debugPrint('⚠️ Amplify configuration failed: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // flutter 엔진 초기화
  await _configureAmplify();

  // 앱 시작 시 강제 로그아웃
  try {
    await Amplify.Auth.signOut();
    print("✅ 앱 시작 시 강제 로그아웃");
  } catch (e) {
    print("❌ 로그아웃 실패: $e");
  }

  runApp(FlutterApp()); // 앱 실행
}

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      home: FirstScreen(), // 첫 번째 화면을 FirstScreen으로 설정
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  // 화면의 너비
    double screenHeight = MediaQuery.of(context).size.height; // 화면의 높이

    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      appBar: AppBar(
        title: Container(), // AppBar 제목을 빈 컨테이너로 설정하여 숨김
        backgroundColor: Colors.transparent, // AppBar의 배경을 투명하게 설정
        elevation: 0, // AppBar의 그림자를 없앰
        automaticallyImplyLeading: false, // 기본 back 버튼 숨기기
      ),
      body: Center(
        child: Container(
          width: screenWidth, // 화면 너비에 맞게 설정
          height: screenHeight, // 화면 높이에 맞게 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 화면 중앙에 위치
            children: [
              Text(
                'Aircraft Safety Check', // 화면에 표시될 텍스트
                style: TextStyle(
                  color: Color(0xFF1E1E1E), // 텍스트 색상
                  fontSize: 30, // 폰트 크기
                  fontFamily: 'Inter', // 폰트 스타일
                ),
              ),
              SizedBox(height: 204), // 텍스트와 버튼 간의 간격
              ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 로그인 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // LoginScreen으로 이동
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EC4E3), // 버튼 배경색
                  padding: EdgeInsets.symmetric(horizontal: 56, vertical: 8), // 버튼 패딩
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 버튼 모서리 둥글게
                  ),
                  elevation: 4, // 버튼 그림자 효과
                ),
                child: Text(
                  'CLICK', // 버튼 텍스트
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 20, // 폰트 크기
                    fontFamily: 'Inter', // 폰트 스타일
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
