import 'package:flutter/material.dart';

class CalcTrans extends StatelessWidget {
  const CalcTrans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 텍스트필드의 내용을 insertCarbonGen(String kind, String amount)에 넣어준다.

      // trans는 추가로 dropdownButton이 있으니 transDropChange()함수를 onchanged에 넣어주고
      // curtransDropValue 를 build전에 먼저 transDropdown[0]으로 해주고
      // dropdownButton의 value에 curtransDropValue를 넣어준다.
    );
  }
}