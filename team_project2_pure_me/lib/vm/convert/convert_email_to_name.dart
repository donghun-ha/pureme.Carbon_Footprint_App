import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

/// 유저의 이메일을 닉네임으로 변경하기 위한 클래스
class ConvertEmailToName {
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  var userNameMap = {};

  /// 유저의 {이메일(key), 닉네임(value)} Map을 가져옴
  Future getUserName() async {
    var url = Uri.parse("$baseUrl/user/userNames");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    userNameMap = result;
  }

  /// 유저의 이메일이 키값과 일치하면 닉네임 반환
  String changeAction(String email) {
    if (userNameMap.containsKey(email)) {
      var name = userNameMap[email]!;
      return name;
    } else {
      return email;
    }
  }
}
