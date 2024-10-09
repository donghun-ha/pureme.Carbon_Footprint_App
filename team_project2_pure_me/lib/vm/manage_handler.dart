import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/calc_handler.dart';

class ManageHandler extends CalcHandler {
  List<User> searchedUserList = <User>[].obs;

  SearchUser(String userEMail) {
    /// userEMail을 통해 user를 검색, List로 반환할 수 있는 class
    /// searchUserList 에 List<User>를 넣을수 있도록
    ///
  }

  fetchUserAmountPerDay() {}
}
