import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class UserHandler extends FeedHandler {
  // RxList<User> userList = <User>[].obs;

  // 현재 유저의 정보를 저장할 변수
  final curUser = User(
          eMail: '1234@gmail.com',
          nickName: '',
          password: '1234',
          phone: '010-1234-5678',
          createDate: DateTime.now(),
          point: 0,
          profileImage: 'sample.png')
      .obs; // fetch해오기 위한 User class

  /// 중복된 이메일을 확인해줄 변수
  bool eMailUnique = false; // 회원가입시 이메일 확인을 위한 변수

  ///
  String? profileImageName;

  // RxBool profileImageChanged = false.obs;

  bool userProfileImageChanged = false;

  /// 이미지가 바뀌었음을 확인시키는 변수
  /// 매니저 로그인 radioButton 을 위한 변수
  int manageLogin = 0;

  // 걸음수
  var step = 0.obs;

  /// 건강앱 사용을 위한 권한 요청
  Future<void> requestHealthPermission() async {
    // 권한 상태 확인
    var status = await Permission.sensors.status;

    // 허용이 아닐 경우 실행
    if (status.isDenied) {
      // 권한 요청
      if (await Permission.sensors.request().isGranted) {
        // print("Health permission granted");
        // 권한을 허용 할 경우 실행
        healthStep();
      } else {
        // print("Health permission denied");
      }
    } else if (status.isGranted) {
      healthStep();
    }
  }

  /// 건강앱에서 유저의 걸음 수를 가져옵니다.
  // Health()
  healthStep() async {
    Health().configure();
    var types = [HealthDataType.STEPS];
    // 건강앱에서 걸음수 정보 권한 요청
    bool requested = await Health().requestAuthorization(types);
    var now = DateTime.now();

    // 현재 일의 년, 월, 일
    var midnight = DateTime(now.year, now.month, now.day);
    // start, end // date
    int? steps = await Health().getTotalStepsInInterval(midnight, now);
    step.value = steps ?? 0;
  }

  /// 로그인
  /// 로그인시 curUser 정보를 가져옴
  Future<bool> loginVerify(String eMail, String password) async {
    var url =
        Uri.parse("$baseUrl/user/loginVerify?eMail=$eMail&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    bool ver = result[0]['seq'];

    if (ver) {
      // curUser의 정보를 가져오는 함수
      await curUserUpdate(eMail);
      return true;
    } else {
      return false;
    }
  }

  /// curUser의 정보를 가져오는 함수
  curUserUpdate(String eMail) async {
    var url = Uri.parse("$baseUrl/user/login?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    curUser.value = User.fromMap(result[0]);
    update();
  }

  /// 중복된 이메일 체크
  eMailVerify(String eMail) async {
    var url = Uri.parse("$baseUrl/user/eMailVerify?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    eMailUnique = result[0]['result'];
    update();
  }

  /// 회원가입
  /// 비밀번호 중복확인
  signIn(String eMail, String password, String passwordVerify, String nickName,
      String phone) async {
    if (password != passwordVerify) {
      return false;
    } else {
      var url = Uri.parse(
          "$baseUrl/user/signIn?eMail=$eMail&nickname=$nickName&password=$password&phone=$phone");
      await http.get(url);

      return true;
    }
  }

  userUpdate(String eMail, String nickName, String phone) async {
    var url = Uri.parse(
        "$baseUrl/user/update?cureMail=${curUser.value.eMail}&eMail=$eMail&nickname=$nickName&phone=$phone");
    // print(url);
    await http.get(url);

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

    await http.get(url);

    if (profileImage == 'null') {
      curUser.value.profileImage = null;
    } else {
      curUser.value.profileImage = profileImage;
    }

    // print(curUser.value.profileImage);
    curUser.value.nickName = nickName;
    curUser.value.eMail = eMail;
    curUser.value.phone = phone;
    // profileImageChanged.value = !profileImageChanged.value;
    // print(profileImageChanged.value);
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
      profileImageName = '${curUser.value.eMail}.$fileExtention';

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

    await request.send();
  }

  // 기본 이미지로 되돌리는 함수
  userImageNull() {
    imageFile = null;
    userProfileImageChanged = true;
    update();
  }

  userImageDelete() async {
    if (curUser.value.profileImage != null) {
      final response = await http.delete(
          Uri.parse("$baseUrl/user/imageDelete/${curUser.value.profileImage}"));
      if (response.statusCode == 200) {
        curUser.value.profileImage = null;
        // print("Image deleted successfully");
      } else {
        // print("image deletion failed");
      }
    }
  }

  userUpdatePwd(String password) async {
    var url = Uri.parse(
        "$baseUrl/user/updatePW?eMail=${curUser.value.eMail}&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    // ignore: unused_local_variable
    var result = dataConvertedJSON['result'];

    ///
    /// 비밀번호를 받아서 데이터베이스에 변경만 시킨다.
  }

  pointUpdate(int addPoint) async {
    curUser.value.point += addPoint;
    var url = Uri.parse(
        "$baseUrl/user/updatepoint?eMail=${curUser.value.eMail}&point=${curUser.value.point}");
    // print(url);
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    // ignore: unused_local_variable
    var result = dataConvertedJSON['result'];
  }

  Future<Uint8List?> fetchImage() async {
    if (curUser.value.profileImage != null) {
      final response = await http.get(
        Uri.parse("$baseUrl/user/view/${curUser.value.profileImage!}"),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // 바이트 배열로 반환
      } else {
        return null;
      }
    } else {
      return null; // 에러 발생 시 null 반환
    }
  }

  manageLoginChange(value) {
    manageLogin = value;
    update();
  }

  manageLoginVerify(String eMail, String password) async {
    var url = Uri.parse(
        "$baseUrl/manage/loginVerify?eMail=$eMail&password=$password");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    return result[0]['seq'] as bool;
  }

  Future<(int?, String?)> ceaseAccountVerify(String eMail) async {
    var url = Uri.parse("$baseUrl/user/reportVerify?eMail=$eMail");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    return (result[0]['diff'] as int?, result[0]['ceaseReason'] as String?);
  }
}
