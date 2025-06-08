import 'package:flutter/material.dart';
import 'admin_login_screen.dart'; // AdminLoginScreen을 import
import 'user_login_screen.dart'; // UserLoginScreen을 import

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  // 화면의 너비
    double screenHeight = MediaQuery.of(context).size.height; // 화면의 높이

    return Scaffold(
      backgroundColor: Color(0xFFD7EFFF), // 하늘색 배경

      // 메인 위젯 설정
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              // 배경 이미지 (화면의 60% 차지)
              Container(
                width: screenWidth,
                height: screenHeight * 0.6, // 화면의 60% 차지
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_bg.png"), // 배경 이미지
                    fit: BoxFit.cover, // 이미지를 비율에 맞게 꽉 채우기
                  ),
                ),
                child: Stack(
                  children: [
                    // 'Login' 텍스트 추가 (이미지 위에 배치)
                    Positioned(
                      top: screenHeight * 0.043, // 세로 위치 지정
                      left: 0, // left를 0으로 설정하여, Align 위젯이 자동으로 중앙 정렬되도록 함
                      right: 0, // right를 0으로 설정하여 Align이 수평 중앙에 배치되도록
                      child: Align(
                        alignment: Alignment.center, // 수평 중앙 정렬
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black, // 검정색 텍스트
                            fontSize: 20,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 하단 영역 (40% 차지)
              Container(
                width: screenWidth,
                height: screenHeight * 0.4, // 화면의 40% 차지
                color: Color(0xFFD7EFFF), // 하늘색 배경 유지
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    // 로그인 텍스트
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 20), // 텍스트와 버튼 사이 간격
                    // 'Admin Login' 버튼 클릭 시 AdminLoginScreen으로 이동
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLoginScreen()), // 관리자 로그인 화면으로 이동
                        );
                      },
                      child: Container(
                        width: 230,
                        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Color(0xFF7EC4E3), // 버튼 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // 버튼 둥글기 설정
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000), // 그림자 색상
                              blurRadius: 4, // 그림자 흐림 정도
                              offset: Offset(0, 4), // 그림자 위치
                              spreadRadius: 0, // 그림자 퍼짐 정도
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Admin Login',
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
                    SizedBox(height: 20), // 버튼 간 간격
                    // 'User Login' 버튼 클릭 시 UserLoginScreen으로 이동
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserLoginScreen()), // 사용자 로그인 화면으로 이동
                        );
                      },
                      child: Container(
                        width: 230,
                        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Color(0xFF7EC4E3), // 버튼 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // 버튼 둥글기 설정
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000), // 그림자 색상
                              blurRadius: 4, // 그림자 흐림 정도
                              offset: Offset(0, 4), // 그림자 위치
                              spreadRadius: 0, // 그림자 퍼짐 정도
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'User Login',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
