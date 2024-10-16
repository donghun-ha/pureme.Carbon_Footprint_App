import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ConvertEmailToName {
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  var userNameMap = {};
  Future getUserName() async {
    var url = Uri.parse("$baseUrl/user/userNames");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    userNameMap = result;
  }

  String changeAction(String email) {
    if (userNameMap.containsKey(email)) {
      var name = userNameMap[email]!;
      return name;
    } else {
      return email;
    }
  }

}
