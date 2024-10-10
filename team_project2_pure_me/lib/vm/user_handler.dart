import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project2_pure_me/model/lev.dart';
import 'package:team_project2_pure_me/model/user.dart';

import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class UserHandler extends FeedHandler {
  RxList<User> userList = <User>[].obs;

  final curUser = User(
          eMail: '1234@gmail.com',
          nickName: '',
          password: '1234',
          phone: '010-1234-5678',
          createDate: DateTime.now(),
          point: 0,
          profileImage: 'sample.png')
      .obs; // fetch해오기 위한 User class

  List<Lev> levList = <Lev>[].obs;
  int curLev = 0; // point를 통해 계산한 레벨을 저장할 변수

  bool eMailUnique = false; // 회원가입시 이메일 확인을 위한 변수

  String? profileImageName;

  /// 회원정보 수정시 이미지 이름을 바꿔야할때 필요한 변수

  Future<bool> loginVerify(String eMail, String password) async {
    var url = Uri.parse(
        "http://127.0.0.1:8000/user/loginVerify?eMail=$eMail&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    bool ver = result[0]['seq'];

    if (ver) {
      await curUserUpdate(eMail);
      print(curUser.eMail);
      // print(curUser.point);
      // await pointUpdate(1);
      // print(curUser.point);
      return true;
    } else {
      return false;
    }
  }

  curUserUpdate(String eMail)async{
    var url = Uri.parse("http://127.0.0.1:8000/user/login?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    curUser = User.fromMap(result[0]);
    update();
    print(curUser.nickName);

  }


  eMailVerify(String eMail) async {
    var url = Uri.parse("http://127.0.0.1:8000/user/eMailVerify?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    eMailUnique = result[0]['result'];
    update(); 
  }

  signIn(String eMail, String password, String passwordVerify, String nickName,
      String phone) async {
    if (password != passwordVerify) {
      return false;
    } else {}
    var url = Uri.parse(
        "http://127.0.0.1:8000/user/signIn?eMail=$eMail&nickname=$nickName&password=$password&phone=$phone");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    return true;
  }

  fetchUserLev() {
    /// firebase의 레벨table을 참조해서 유저의 레벨을 fetch해오는 함수
    /// LevList에 lev들을 저장한다.
  }

  changeCurLev() {
    // curLev를 바꿔준다 LevList에 맞게 바꿔준 뒤 update()하는 로직을 짠다.
  }

  userUpdate(String eMail, String nickName, String phone) async {
    var url = Uri.parse(
        "http://127.0.0.1:8000/user/update?cureMail=${curUser.value.eMail}&eMail=$eMail&nickname=$nickName&phone=$phone");
    print(url);
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    curUser.value.nickName = nickName;
    curUser.value.eMail = eMail;
    curUser.value.phone = phone;
    update();
  }

  userUpdateAll(
      String eMail, String nickName, String phone, String profileImage) async {

    var url = Uri.parse(
        "http://127.0.0.1:8000/user/updateAll?cureMail=${curUser.eMail}&eMail=$eMail&nickname=$nickName&phone=$phone&&profileImage=$profileImage");

    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    curUser.profileImage = profileImage;
    print(curUser.profileImage);
    curUser.nickName = nickName;
    curUser.eMail = eMail;
    curUser.phone = phone;
    update();
  }

  //// handler.userImagePicker(ImageSource.gallery)로 실행시키세요
  userImagePicker(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    List preFileName = imageFile!.path.split('/');
    profileImageName = preFileName[preFileName.length - 1];
    update();
  }

  userImageInsert() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://127.0.0.1:8000/user/imageUpload"));
    var multipartFile =
        await http.MultipartFile.fromPath('file', imageFile!.path);
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      print('success');
    } else {
      print("error");
    }
  }

  userImageUpdate(String fileName) {}

  userUpdatePwd(String password) async {
    var url = Uri.parse(
        "http://127.0.0.1:8000/user/updatePW?eMail=${curUser.eMail}&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    ///
    /// 비밀번호를 받아서 데이터베이스에 변경만 시킨다.
  }

  pointUpdate(int addPoint)async{
    curUser.point += addPoint;
    var url = Uri.parse(
      "http://127.0.0.1:8000/user/updatepoint?eMail=${curUser.eMail}&point=${curUser.point}");
    print(url);
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];


  }




}
