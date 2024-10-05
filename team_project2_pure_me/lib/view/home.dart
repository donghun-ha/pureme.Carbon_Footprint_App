import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 필요한 변수: curUser, curTotalCarbon
      // 필요 함수: curUser는 로그인시 이미 바뀌어서 상관없지만
      // curTotalCarbon 바꾸기 위한 vmhandler.fetchTotalCarbon 한번 불러줘야함
      // 나무 계산식, 에너지 계산식 등은 총 탄소량 curTotalCarbon 전부 계산가능하므로
      // view쪽에서 추가바람.
      // 나머지 글씨들은 전부 
    );
  }
}