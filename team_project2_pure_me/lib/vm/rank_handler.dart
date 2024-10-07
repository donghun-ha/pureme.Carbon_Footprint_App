import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/db_handler.dart';

class RankHandler extends GetxController {
  final DbHandler _dbHandler = Get.find<DbHandler>();
  
  RxList<User> rankList = <User>[].obs;
  RxInt myrank = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRank();
    fetchMyRank();
  }

  Future<void> fetchRank() async {
    try {
      // 데이터베이스에서 상위 10명의 사용자 정보를 가져옴
      var users = await _dbHandler.getTopUsers(10);
      rankList.assignAll(users);
    } catch (e) {
      print('Error fetching rank: $e');
    }
  }

  Future<void> fetchMyRank() async {
    try {
      // 현재 사용자의 ID를 가져옴
      String currentUserId = _dbHandler.getCurrentUserId();
      
      // 현재 사용자의 랭크를 계산
      int rank = await _dbHandler.getUserRank(currentUserId);
      myrank.value = rank;
    } catch (e) {
      print('Error fetching my rank: $e');
    }
  }

  // 랭킹 정보 새로고침
  Future<void> refreshRankings() async {
    await fetchRank();
    await fetchMyRank();
  }
}