import 'dart:convert';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';
import 'package:team_project2_pure_me/vm/user_handler.dart';
import 'chart_handler.dart';

class RankHandler extends ChartHandler {
  // ConvertEmailToName convertEmailToName = ConvertEmailToName();
  RxList<User> rankList = <User>[].obs;
  RxInt myrank = 0.obs;

  RxString totalCarbonFootprint = '0'.obs;
  RxString totalReducedCarbonFootprint = '0'.obs;
  RxString treesFootprint = '0'.obs;
  RxString totalEnergyReduction = '0'.obs;

  RankHandler() {
    fetchRank();
    // fetchTotalCarbon();
  }

  @override
  void onInit() {
    super.onInit();
    fetchRank();
    fetchMyRank();
    // fetchTotalCarbon();
  }

  // 랭킹 데이터 가져오기
  Future<void> fetchRank() async {
    await convertEmailToName.getUserName();
    var url = Uri.parse("$baseUrl/footprint/rankings");
    final response = await http.get(url); // GET 요청

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      // print('Response data: ${response.body}'); // 응답 데이터 확인
      final data = json.decode(response.body);
      List<User> users = (data['rankings'] as List)
          .map((user) => User(
                // 이메일을 닉네임으로 변환
                nickName: convertEmailToName.changeAction(user['user_eMail']),
                eMail: user['user_eMail'], // eMail 매핑
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
      print('랭킹을 불러오는 데 실패했습니다: ${response.statusCode}');
    }
  }

  // 탄소량 불러오는 함수
  fetchTotalCarbon() async {
    var url = Uri.parse(
        "$baseUrl/footprint/calculate_with_reduction?user_eMail=${curUser.value.eMail}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      final totalFootprint = dataConvertedJSON['result'];
      print(totalFootprint);
      // if (totalFootprint[0] != 0.0 ) {
      totalCarbonFootprint.value = totalFootprint[2].toString();
      totalReducedCarbonFootprint.value = totalFootprint[3].toString();
      treesFootprint.value = totalFootprint[1].toString();
      totalEnergyReduction.value = totalFootprint[0].toString();
      // } else{
      //   totalCarbonFootprint.value = '0';
      //   totalReducedCarbonFootprint.value = '0';
      //   treesFootprint.value = '0';
      //   totalEnergyReduction.value = '0';
      // }
    } else {
      print("랭킹을 불러오는 데 실패했습니다: ${response.statusCode}");
    }
  }

  void fetchMyRank() {
    // 더미 데이터로 내 랭킹 설정
    myrank.value = 3;
  }

  void refreshRankings() {
    fetchRank();
    fetchMyRank();
    // fetchTotalCarbon();
  }

}