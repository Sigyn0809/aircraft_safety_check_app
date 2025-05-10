import 'package:flutter/material.dart';
import 'flight_edit_screen.dart';

class AdminLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  // 화면의 너비
    double screenHeight = MediaQuery.of(context).size.height; // 화면의 높이

    return Scaffold(
      backgroundColor: Color(0xFFD7EFFF), // 하늘색 배경

      // 상단 위젯 설정
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 투명 배경
        elevation: 0, // 그림자 없애기
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 클릭 시 이전 화면으로 돌아가기
          },
        ),
        centerTitle: true, // 중앙 정렬
        title: Text(
          'Aircraft Safety Check', // 제목
          style: TextStyle(
            color: Colors.black, // 검정색 텍스트
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // 메인 위젯 설정
      body: Container(
        width: MediaQuery.of(context).size.width, // 화면의 너비
        height: MediaQuery.of(context).size.height, // 화면의 높이
        child: Stack(
          children: [
            // 'Aircraft Safety Check' 텍스트 (ID 필드 바로 위)
            Positioned(
              top: screenHeight * 0.22, // 세로 위치 지정
              left: 0, // left를 0으로 설정하여, Align 위젯이 자동으로 중앙 정렬되도록 함
              right: 0, // right를 0으로 설정하여 Align이 수평 중앙에 배치되도록
              child: Align(
                alignment: Alignment.center, // 수평 중앙 정렬
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

            // ID 텍스트와 필드
            Positioned(
              top: screenHeight * 0.32, // ID 필드의 상단 위치
              left: MediaQuery.of(context).size.width * 0.5 - screenWidth * 0.67 / 2, // ID 필드 너비 273을 기준으로 중앙 정렬
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
                  SizedBox(height: 8), // 텍스트와 텍스트 필드 사이의 간격
                  Container(
                    width: screenWidth * 0.67,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD9D9D9)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter ID', // 힌트 텍스트 추가
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Password 텍스트와 필드
            Positioned(
              top: screenHeight * 0.43, // Password 필드의 상단 위치
              left: MediaQuery.of(context).size.width * 0.5 - screenWidth * 0.67 / 2, // Password 필드 너비 273을 기준으로 중앙 정렬
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
                  SizedBox(height: 8), // 텍스트와 텍스트 필드 사이의 간격
                  Container(
                    width: screenWidth * 0.67,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD9D9D9)),
                    ),
                    child: TextField(
                      obscureText: true,  // 비밀번호 입력 시 숨김 처리
                      decoration: InputDecoration(
                        hintText: 'Enter Password', // 힌트 텍스트 추가
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 로그인 버튼
            Positioned(
              top: screenHeight * 0.75, // 로그인 버튼의 상단 위치
              left: MediaQuery.of(context).size.width * 0.5 - 150 / 2, // 버튼 너비 150을 기준으로 중앙 정렬
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightEditScreen()),
                  );
                },
                child: Container(
                  width: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
