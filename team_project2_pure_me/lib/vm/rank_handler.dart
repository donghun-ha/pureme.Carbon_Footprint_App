import 'dart:convert';

import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;

class RankHandler extends GetxController {
  RxList<User> rankList = <User>[].obs;
  RxInt myrank = 0.obs;

  RankHandler() {
    fetchRank();
  }

  final String defaultUrl = "http://127.0.0.1:8000/footprint";

  @override
  void onInit() {
    super.onInit();
    fetchRank();
    fetchMyRank();
  }

  // 랭킹 데이터 가져오기
  Future<void> fetchRank() async {
    var url = Uri.parse("$defaultUrl/rankings");
    final response = await http.get(url); // GET 요청

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      print('Response data: ${response.body}'); // 응답 데이터 확인
      final data = json.decode(response.body);
      List<User> users = (data['rankings'] as List)
          .map((user) => User(
                eMail: user['user_eMail'], // eMail 매핑
                nickName: user['nickName'] ?? '', // 닉네임
                password: '', // 패스워드는 API에서 제공되지 않으므로 빈 문자열
                phone: '', // 핸드폰 정보가 없으므로 빈 문자열
                createDate: DateTime.now(), // 생성일 기본값 (API에서 제공되지 않음)
                point: user['total_reduction'], // 포인트를 총 절감량으로 설정
                profileImage: user['profileImage'], // 이미지가 없으면 null
              ))
          .toList();
      rankList.assignAll(users); // 랭킹 리스트 업데이트
    } else {
      // 에러 발생 시 처리
      ('랭킹을 불러오는 데 실패했습니다: ${response.statusCode}');
    }
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
