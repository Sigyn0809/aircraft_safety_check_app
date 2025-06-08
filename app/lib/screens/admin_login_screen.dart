import 'package:flutter/material.dart';
import 'flight_edit_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final id = _usernameController.text.trim();
    final pw = _passwordController.text.trim();

    print("🔑 로그인 시도: username=$id, password=$pw");

    try {
      final result = await Amplify.Auth.signIn(
        username: id,
        password: pw,
      );

      print("📡 로그인 결과: ${result.isSignedIn}");

      if (result.isSignedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlightEditScreen()),
        );
      } else {
        _showError('로그인에 실패했습니다.');
      }
    } on AuthException catch (e) {
      print("❌ 로그인 에러: ${e.message}");
      _showError(e.message);
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Admin Login',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.22,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Aircraft Safety Check',
                  style: TextStyle(
                    color: Color(0xFF1B84B1),
                    fontSize: 24,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.32,
              left: screenWidth * 0.5 - screenWidth * 0.67 / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: screenWidth * 0.67,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD9D9D9)),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter ID',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.43,
              left: screenWidth * 0.5 - screenWidth * 0.67 / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: screenWidth * 0.67,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD9D9D9)),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.5 - 150 / 2,
              child: GestureDetector(
                onTap: _signIn,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Color(0xFF7EC4E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
