import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CalcHandler extends GetxController {
  double curTotalCarbon = 0; // 현재 TotalCarborn의 양을 나타내는 변수

  var transDropdown = <String>['대중교통', '자동차', '자전거', '도보'].obs;
  var transDropdownEn = <String>['public', 'car', 'bicycle', 'walk'];
  int currentTranIndex = 0;
  String? curtransDropValue;

  var recylist = <String>['paper', 'plastic', 'glass', 'metal', 'other'];
  int recyIndex = 1;

  var foodlist = <String>['meat', 'vegetarian', 'dairy', 'plant'];

  var electricitylist = <String>['electricity', 'gas'];

  fetchTotalCarbon() {
    /// DB에서 식을 구현해 myCarbon이 어느정도인지 알아온다
    ///
    curTotalCarbon = 0;
    update();
  }

  insertCarbonGen(String kind, double amount) {
    // CarbonGen table에 kind와 amount, datetime.now()로 날짜까지 넣는다.
  }

  transDropChange(value) {
    curtransDropValue = value;
    update();
    // 수정 불필요
  }

  giveData(
      CalcHandler vmHandler, String kind, String amount, String email) async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/footprint/insert?category_kind=$kind&user_eMail=$email&createDate=${DateTime.now()}&amount=$amount');
    await http.get(url);
    // var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    // result = dataConvertedJSON['message'];
  }
}
