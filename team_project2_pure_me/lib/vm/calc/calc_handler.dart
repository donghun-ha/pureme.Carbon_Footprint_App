import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CalcHandler extends GetxController {
  var transDropdown = <String>['대중교통', '자동차', '자전거', '도보'].obs;
  var transDropdownEn = <String>['public', 'car', 'bicycle', 'walk'];
  int currentTranIndex = 0;
  String? curtransDropValue;
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  var recylist = <String>['paper', 'plastic', 'glass', 'metal', 'other'];
  int recyIndex = 0;

  var foodlist = <String>['meat', 'vegetarian', 'dairy', 'plant'];

  var electricitylist = <String>['electricity', 'gas'];

  transDropChange(value) {
    curtransDropValue = value;
    update();
    // 수정 불필요
  }

  // 데이터 전송 함수
  giveData(
      CalcHandler vmHandler, String kind, String amount, String email) async {
    var url = Uri.parse(
        '$baseUrl/footprint/insert?category_kind=$kind&user_eMail=$email&createDate=${DateTime.now()}&amount=$amount');
    await http.get(url);
  }
}
