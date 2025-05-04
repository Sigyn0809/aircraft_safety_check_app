import 'package:flutter/material.dart';

class AdminSafetyCheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  // 화면의 너비
    double screenHeight = MediaQuery.of(context).size.height; // 화면의 높이

    return Scaffold(
      backgroundColor: Colors.white, // 흰색 배경
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

      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // 'Enter Safety Inspection Checklist' 텍스트 (ID 필드 바로 위)
              Positioned(
                top: screenHeight * 0.22, // 세로 위치 지정
                left: 0, // left를 0으로 설정하여, Align 위젯이 자동으로 중앙 정렬되도록 함
                right: 0, // right를 0으로 설정하여 Align이 수평 중앙에 배치되도록
                child: Align(
                  alignment: Alignment.center, // 수평 중앙 정렬
                  child: Text(
                    'Enter Safety Inspection Checklist',
                    style: TextStyle(
                      color: Color(0xFF1B84B1),
                      fontSize: 22,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),

              // Flight Number 입력 필드
              Positioned(
                top: screenHeight * 0.32, // Flight Number 필드 위치 조정
                left: screenWidth * 0.5 - screenWidth * 0.67 / 2, // 가로 중앙 정렬 (273은 입력 필드의 너비)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flight Number',
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
                        decoration: InputDecoration(
                          hintText: 'Enter Flight Number', // 힌트 텍스트 추가
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Admin ID 텍스트와 필드
              Positioned(
                top: screenHeight * 0.43, // Admin ID 필드의 상단 위치
                left: MediaQuery.of(context).size.width * 0.5 - screenWidth * 0.67 / 2, // ID 필드 너비 273을 기준으로 중앙 정렬
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin ID',
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
                          hintText: 'Enter Admin ID', // 힌트 텍스트 추가
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Label 토글 스위치
              Positioned(
                top: screenHeight * 0.55, // Label 스위치 위치 조정
                left: screenWidth * 0.5 - 275 / 2, // 가로 중앙 정렬 (275는 스위치의 너비)
                child: Container(
                  width: 275,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                'Label',
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40,
                            padding: const EdgeInsets.only(top: 3, left: 19, right: 3, bottom: 3),
                            decoration: ShapeDecoration(
                              color: Color(0xFF2C2C2C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Description',
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Confirm 버튼
              Positioned(
                top: screenHeight * 0.75, // Confirm 버튼 위치 조정
                left: screenWidth * 0.5 - 150 / 2, // 가로 중앙 정렬
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
                        'Confirm',
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
      ),
    );
  }
}
