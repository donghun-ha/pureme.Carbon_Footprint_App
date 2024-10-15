import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/chart_handler.dart';
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';

/* **RankHandler 클래스**

• 이 클래스는 사용자들의 탄소 절감 랭킹을 관리하는 역할을 합니다.
• `UserHandler` 클래스를 상속받아 기본적인 사용자 관리 기능을 확장하였습니다.
• FastAPI 백엔드와 통신하여 랭킹 데이터와 개인의 탄소 절감량을 가져옵니다.

**Author**: 하동훈
**Date**: 2024-10-10

**Error 수정**: 
2024-10-12
  수정된 부분:
  •  Flutter 코드에서는 dataConvertedJSON['result']를 리스트로 취급하여 인덱스로 접근하려고 시도.
  •  하지만 실제로 result는 문자열 "OK"이므로, 이를 리스트처럼 접근해 RangeError가 발생 오류 수정.
2024-10-14
	•	수정된 부분:
	•	RankHandler에서 fetchMyRank 메소드가 사용자 랭킹을 제대로 찾지 못해 myrank가 0으로 설정되는 문제를 해결.
	•	초기 curUser가 더미 이메일 '1234@gmail.com'으로 설정되어 있어, 랭킹 리스트에 해당 사용자가 포함되지 않아 발생하던 문제를 해결하기 위해 
    onInit 메소드에서 ever 함수를 사용하여 curUser의 변화를 감지하고, 
    curUser가 업데이트될 때마다 fetchRank를 호출하도록 수정.
	•	이제 로그인 후 curUser가 올바르게 업데이트되면, RankHandler가 자동으로 랭킹 데이터를 다시 가져와 myrank가 정확하게 설정됩니다.
*/

class RankHandler extends ChartHandler {
  /// 이메일을 닉네임으로 변환하는 도우미 클래스 인스턴스
  ConvertEmailToName convertEmailToName = ConvertEmailToName();

  /// 전체 랭킹 리스트를 저장하는 반응형 리스트
  RxList<User> rankList = <User>[].obs;

  /// 사용자의 자신의 랭킹을 저장하는 반응형 정수
  RxInt myrank = 0.obs;

  /// 총 탄소 발자국을 저장하는 반응형 문자열
  RxString totalCarbonFootprint = '0'.obs;

  /// 총 탄소 절감량을 저장하는 반응형 문자열
  RxString totalReducedCarbonFootprint = '0'.obs;

  /// 심은 나무 수를 저장하는 반응형 문자열
  RxString treesFootprint = '0'.obs;

  /// 에너지 감소량을 저장하는 반응형 문자열 (리터 단위)
  RxString totalEnergyReduction = '0'.obs;

  /* **생성자**
  /
  RankHandler 클래스의 인스턴스가 생성될 때 자동으로 `fetchRank` 메소드를 호출하여 랭킹 데이터를 가져옵니다.
  */

  /// 백엔드 API의 기본 URL 설정
  final String defaultUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/footprint'
      : 'http://127.0.0.1:8000/footprint';

  @override
  void onInit() {
    super.onInit();

    // 'ever' 함수는 첫 번째 인자로 주어진 Rx 변수의 변화를 감지하고,
    // 두 번째 인자로 주어진 콜백 함수를 호출합니다.
    // 여기서는 'curUser'가 변경될 때마다 'fetchRank' 메소드를 호출하도록 설정합니다.
    // 즉, 사용자가 로그인하여 'curUser'가 업데이트될 때마다 랭킹 데이터를 다시 가져옵니다.
    ever(curUser, (User? user) {
      if (user != null) {
        // 'curUser'가 null이 아닌 경우에만 'fetchRank'를 호출하여 랭킹 데이터를 가져옵니다.
        // 이는 사용자가 로그인한 상태임을 의미합니다.
        fetchRank();
        fetchUserCarbonData();
      }
    });
    requestHealthPermission();
  }

  /* 
  **fetchRank 메소드**
  백엔드의 `/rankings` 엔드포인트로 GET 요청을 보내 현재 달의 랭킹 데이터를 가져옵니다.
  응답받은 JSON 데이터를 `User` 모델로 변환하여 `rankList`에 저장합니다.
  
  **Usage**:
  http://127.0.0.1:8000/footprint/rankings?limit=랭킹수
  */

  Future<void> fetchRank() async {
    // 이메일을 닉네임으로 변환하기 위한 데이터 미리 가져오기
    await convertEmailToName.getUserName();

    // 랭킹 API의 URL 구성
    var url = Uri.parse("$defaultUrl/rankings");
    final response = await http.get(url); // GET 요청 수행

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      final data = json.decode(response.body);

      // JSON의 'rankings' 필드를 리스트로 가져와 User 모델로 매핑
      List<User> users = (data['rankings'] as List)
          .map((user) => User(
                // 이메일을 닉네임으로 변환
                nickName: convertEmailToName.changeAction(user['user_eMail']),
                eMail: user['user_eMail'], // 이메일 매핑
                password: '', // 패스워드는 API에서 제공되지 않으므로 빈 문자열
                phone: '', // 핸드폰 정보가 없으므로 빈 문자열
                createDate: DateTime.now(), // 생성일 기본값 (API에서 제공되지 않음)
                point: user['total_reduction'], // 포인트를 총 절감량으로 설정
                profileImage: user['profileImage'], // 이미지가 없으면 null
              ))
          .toList();

      // 랭킹 리스트 업데이트
      rankList.assignAll(users);
      update();

      // 랭킹 데이터가 업데이트된 후 사용자 랭킹을 가져옵니다.
      fetchMyRank();
    } else {
      // 에러 발생 시 에러 메시지 출력
      print('랭킹을 불러오는 데 실패했습니다: ${response.statusCode}');
    }
  }
  /* **fetchTotalCarbon 메소드**
  백엔드의 `/calculate_with_reduction` 엔드포인트로 GET 요청을 보내 사용자의 탄소 발자국과 절감량을 가져옵니다.
  응답받은 JSON 데이터를 반응형 변수들에 저장합니다.
  **Usage**:
  http://127.0.0.1:8000/footprint/calculate_with_reduction?user_eMail=유저이메일
  */

  Future<void> fetchTotalCarbon() async {
    // 개인 탄소 발자국 계산 API의 URL 구성
    var url = Uri.parse(
        "$defaultUrl/calculate_with_reduction?user_eMail=${curUser.value.eMail}");
    var response = await http.get(url); // GET 요청 수행

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      // 응답 데이터를 디코딩하여 JSON 형태로 변환
      final dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

      // JSON의 'result' 필드가 'OK'인지 확인
      if (dataConvertedJSON['result'] == 'OK') {
        // 'summary' 객체를 가져옴
        final summary = dataConvertedJSON['summary'];

        // 'summary'가 존재하는지 확인
        if (summary != null) {
          // 각 항목을 추출하여 문자열로 변환
          final totalCarbonFootprint =
              summary['total_carbon_footprint']?.toString();
          final totalCarbonReduction =
              summary['total_carbon_reduction']?.toString();
          final totalEnergyReduction =
              summary['total_energy_reduction']?.toString(); // 리터 단위
          final totalTreesPlanted = summary['total_trees_planted']?.toString();

          // 값들이 null이 아닌지 확인한 후 반응형 변수들에 저장
          if (totalCarbonFootprint != null &&
              totalCarbonReduction != null &&
              totalEnergyReduction != null &&
              totalTreesPlanted != null) {
            this.totalCarbonFootprint.value = totalCarbonFootprint;
            totalReducedCarbonFootprint.value = totalCarbonReduction;
            treesFootprint.value = totalTreesPlanted;
            this.totalEnergyReduction.value =
                totalEnergyReduction; // 리터 단위로 업데이트
          }
        }
      } else {
        // 'result'가 'OK'가 아닌 경우 에러 메시지 출력
        print("오류 발생: ${dataConvertedJSON['message']}");
      }
    } else {
      // HTTP 요청이 실패한 경우 에러 메시지 출력
      print("랭킹을 불러오는 데 실패했습니다: ${response.statusCode}");
    }
  }

  // **fetchMyRank 메소드**
  // 현재 사용자의 랭킹을 가져오는 메소드입니다.

  void fetchMyRank() {
    // 현재 사용자의 이메일을 가져옵니다.
    String currentUserEmail = curUser.value.eMail;

    // 랭킹 리스트에서 사용자의 이메일을 찾아서 랭킹을 설정합니다.
    int rankIndex = rankList.indexWhere(
      (user) => user.eMail == currentUserEmail,
    );

    // 사용자가 랭킹 리스트에 있는 경우, 랭킹을 설정합니다.
    if (rankIndex != -1) {
      myrank.value = rankIndex + 1; // 인덱스는 0부터 시작하므로 1을 더합니다.
      print('User found at rank index: ${myrank.value}');
    } else {
      myrank.value = 0; // 랭킹 리스트에 없으면 0으로 설정
      print('User not found in ranking list');
    }
  }
}
