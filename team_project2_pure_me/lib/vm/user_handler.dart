import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/lev.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/db_handler.dart';

class UserHandler extends DbHandler {
  final Rx<User> curUser = User(
          eMail: '1234@gmail.com',
          nickName: 'TjPureMe',
          password: '1234',
          phone: '010-1234-5678',
          createDate: DateTime.now(),
          point: 0,
          profileImage: 'sample.png')
      .obs;

  final RxList<Lev> levList = <Lev>[].obs;
  final RxInt curLev = 0.obs;
  final RxBool eMailUnique = false.obs;
  final Rx<String?> profileImageName = Rx<String?>(null);

  Future<bool> loginVerify(String eMail, String password) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      if (eMail == '1234@gmail.com' && password == '1234') {
        curUser.update((val) {
          val?.eMail = eMail;
          val?.password = password;
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error in loginVerify: $e');
      return false;
    }
  }

  Future<void> eMailVerify(String eMail) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      eMailUnique.value = eMail != '1234@gmail.com';
    } catch (e) {
      print('Error in eMailVerify: $e');
    }
  }

  Future<bool> signIn(String eMail, String password, String passwordVerify,
      String nickName, String phone) async {
    if (password != passwordVerify) return false;

    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      curUser.update((val) {
        val?.eMail = eMail;
        val?.nickName = nickName;
        val?.password = password;
        val?.phone = phone;
        val?.createDate = DateTime.now();
        val?.point = 0;
      });
      return true;
    } catch (e) {
      print('Error in signIn: $e');
      return false;
    }
  }

  Future<void> fetchUserLev() async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      levList.assignAll([
        Lev(
            levName: 'Beginner',
            levImageName: 'beginner.png',
            requiredPoint: 0),
        Lev(
            levName: 'Intermediate',
            levImageName: 'intermediate.png',
            requiredPoint: 100),
        Lev(
            levName: 'Advanced',
            levImageName: 'advanced.png',
            requiredPoint: 200),
      ]);
      changeCurLev();
    } catch (e) {
      print('Error in fetchUserLev: $e');
    }
  }

  void changeCurLev() {
    for (int i = 0; i < levList.length; i++) {
      if (curUser.value.point >= levList[i].requiredPoint) {
        curLev.value = i + 1;
      } else {
        break;
      }
    }
  }

  Future<void> userUpdate(String nickName, String eMail, String phone) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      curUser.update((val) {
        val?.nickName = nickName;
        val?.eMail = eMail;
        val?.phone = phone;
      });
    } catch (e) {
      print('Error in userUpdate: $e');
    }
  }

  Future<void> userUpdateAll(
      String profileImage, String nickName, String eMail, String phone) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      curUser.update((val) {
        val?.profileImage = profileImage;
        val?.nickName = nickName;
        val?.eMail = eMail;
        val?.phone = phone;
      });
    } catch (e) {
      print('Error in userUpdateAll: $e');
    }
  }

  Future<void> userImagePicker() async {
    // Implement image picker logic here
    // After picking the image, update profileImageName
    // For example:
    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   profileImageName.value = pickedFile.path.split('/').last;
    // }
  }

  Future<void> userUpdatePwd(String password) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      curUser.update((val) {
        val?.password = password;
      });
    } catch (e) {
      print('Error in userUpdatePwd: $e');
    }
  }
}
