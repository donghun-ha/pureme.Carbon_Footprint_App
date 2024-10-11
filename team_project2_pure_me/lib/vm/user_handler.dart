import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
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

  RxBool profileImageChanged = false.obs;

  /// 이미지가 바뀌었음을 확인시키는 변수

  /// 회원정보 수정시 이미지 이름을 바꿔야할때 필요한 변수

  Future<bool> loginVerify(String eMail, String password) async {
    var url =
        Uri.parse("$baseUrl/user/loginVerify?eMail=$eMail&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    bool ver = result[0]['seq'];

    if (ver) {
      await curUserUpdate(eMail);
      return true;
    } else {
      return false;
    }
  }

  curUserUpdate(String eMail) async {
    var url = Uri.parse("$baseUrl/user/login?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    curUser.value = User.fromMap(result[0]);
    update();
    // print(curUser.nickName);
  }

  eMailVerify(String eMail) async {
    var url = Uri.parse("$baseUrl/user/eMailVerify?eMail=$eMail");
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
        "$baseUrl/user/signIn?eMail=$eMail&nickname=$nickName&password=$password&phone=$phone");
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
        "$baseUrl/user/update?cureMail=${curUser.value.eMail}&eMail=$eMail&nickname=$nickName&phone=$phone");
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
    await userImageDelete();
    var url = Uri.parse(
        "$baseUrl/user/updateAll?cureMail=${curUser.value.eMail}&eMail=$eMail&nickname=$nickName&phone=$phone&&profileImage=$profileImage");

    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    curUser.value.profileImage = profileImage;
    print(curUser.value.profileImage);
    curUser.value.nickName = nickName;
    curUser.value.eMail = eMail;
    curUser.value.phone = phone;
    profileImageChanged.value = !profileImageChanged.value;
    print(profileImageChanged.value);
    update();
  }

  //// handler.userImagePicker(ImageSource.gallery)로 실행시키세요
  userImagePicker(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      List preFileName = imageFile!.path.split('/');
      String fileExtention =
          preFileName[preFileName.length - 1].toString().split('.')[1];
      profileImageName = curUser.value.eMail + '.' + fileExtention;
      update();
    }
  }

  userImageInsert() async {
    var request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/user/imageUpload"));
    var multipartFile =
        await http.MultipartFile.fromPath('file', imageFile!.path);

    request.files.add(multipartFile);
    request.fields['prefix'] = curUser.value.eMail;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('success');
    } else {
      print("error");
    }
  }

  userImageUpdate() {}

  userImageDelete() async {
    if (curUser.value.profileImage != null) {
      final response = await http.delete(Uri.parse(
          "$baseUrl/user/imageDelete/${curUser.value.profileImage}"));
      if (response.statusCode == 200) {
        curUser.value.profileImage = null;
        print("Image deleted successfully");
      } else {
        print("image deletion failed");
      }
    }
  }

  userUpdatePwd(String password) async {
    var url = Uri.parse(
        "$baseUrl/user/updatePW?eMail=${curUser.value.eMail}&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    ///
    /// 비밀번호를 받아서 데이터베이스에 변경만 시킨다.
  }

  pointUpdate(int addPoint) async {
    curUser.value.point += addPoint;
    var url = Uri.parse(
        "$baseUrl/user/updatepoint?eMail=${curUser.value.eMail}&point=${curUser.value.point}");
    print(url);
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
  }


  Future<Uint8List?> fetchImage() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/view/${curUser.value.profileImage!}"),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // 바이트 배열로 반환
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
    return null; // 에러 발생 시 null 반환
  }

}
