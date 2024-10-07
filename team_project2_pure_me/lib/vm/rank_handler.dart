
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';

class RankHandler extends GetxController {
  RxList<User> rankList = <User>[].obs;
  RxInt myrank = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRank();
    fetchMyRank();
  }

  void fetchRank() {
    // 더미 데이터로 랭킹 리스트 생성
    rankList.assignAll([
      User(eMail: 'user1@example.com', nickName: 'Eco슈퍼맨', password: 'password', phone: '010-1111-1111', createDate: DateTime.now(), point: 1000),
      User(eMail: 'user2@example.com', nickName: '내가환경지킴이', password: 'password', phone: '010-2222-2222', createDate: DateTime.now(), point: 950),
      User(eMail: 'user3@example.com', nickName: '탄소왕', password: 'password', phone: '010-3333-3333', createDate: DateTime.now(), point: 900),
      User(eMail: 'user4@example.com', nickName: '더조은친구', password: 'password', phone: '010-4444-4444', createDate: DateTime.now(), point: 850),
      User(eMail: 'user5@example.com', nickName: '잘생긴성엽님', password: 'password', phone: '010-5555-5555', createDate: DateTime.now(), point: 800),
    ]);
  }

  void fetchMyRank() {
    // 더미 데이터로 내 랭킹 설정
    myrank.value = 3;
  }

  void refreshRankings() {
    fetchRank();
    fetchMyRank();
  }
}





/*
class RankHandler extends GetxController {
  final DbHandler _dbHandler = Get.put(DbHandler()); // DbHandler를 여기서 초기화
  
  RxList<User> rankList = <User>[].obs;
  RxInt myrank = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRank();
    fetchMyRank();
  }

  Future<void> fetchRank() async {
    // 데이터베이스에서 상위 10명의 사용자 정보를 가져옴
    var users = await _dbHandler.getTopUsers(10);
    rankList.assignAll(users);
  }

  Future<void> fetchMyRank() async {
    String currentUserId = _dbHandler.getCurrentUserId();
    int rank = await _dbHandler.getUserRank(currentUserId);
    myrank.value = rank;
  }
}

*/ 