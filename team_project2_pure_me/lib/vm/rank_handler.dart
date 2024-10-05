import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/manage_handler.dart';

class RankHandler extends ManageHandler {
  List<User> rankList = <User>[].obs;
  int myrank = 0;

  fetchRank(){
    /// 10등까지의를 fetch하는 알고리즘을 구현해서 
    /// LIst<User>의 형태로 rankList에 저장하기
  }

  fetchMyRank(){
    /// 내 등수를 Myrank 변수에 저장하고 update()하기 
  }
}