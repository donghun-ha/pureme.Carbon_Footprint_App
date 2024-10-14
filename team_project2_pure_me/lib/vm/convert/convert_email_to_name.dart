import 'dart:convert';

import 'package:http/http.dart' as http;

class ConvertEmailToName {
  var userNameMap = {};
  Future getUserName() async {
    var url = Uri.parse("http://10.0.2.2:8000/user/userNames");
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
