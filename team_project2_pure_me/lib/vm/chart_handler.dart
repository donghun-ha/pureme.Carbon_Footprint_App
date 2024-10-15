import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:team_project2_pure_me/vm/rank_handler.dart';
// import 'dart:io' show Platform;
import 'package:team_project2_pure_me/vm/user_handler.dart';
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';

/// **ChartHandler 클래스**
///
/// • 이 클래스는 사용자의 탄소 발자국 데이터를 관리하고, 차트에 필요한 데이터를 가져오는 역할을 합니다.
/// • `UserHandler` 클래스를 상속받아 사용자 관련 데이터를 확장합니다.
/// • 백엔드 API와 통신하여 사용자 탄소 발자국 및 평균 비교 데이터를 가져옵니다.
///
/// **Author**: 하동훈
/// **Date**: 2024-10-14
class ChartHandler extends UserHandler {
  /// 이메일을 닉네임으로 변환하는 도우미 클래스 인스턴스
  ConvertEmailToName convertEmailToName = ConvertEmailToName();

  /// 전체 탄소 발자국 데이터를 저장하는 반응형 맵
  RxMap<String, double> carbonData = <String, double>{}.obs;

  /// 전체 평균 탄소 발자국 데이터를 저장하는 반응형 맵
  RxMap<String, double> averageCarbonData = <String, double>{}.obs;

  /// 평균 비교 데이터를 저장하는 반응형 맵
  RxMap<String, Map<String, double>> averageComparison =
      <String, Map<String, double>>{}.obs;

  /// 총 탄소 발자국을 저장하는 반응형 변수
  RxDouble chartTotalCarbonFootprint = 0.0.obs;

  /// 총 탄소 절감량을 저장하는 반응형 변수
  RxDouble totalCarbonReduction = 0.0.obs;

  /// 총 에너지 절감량을 저장하는 반응형 변수 (리터 단위)
  RxDouble chartTtotalEnergyReduction = 0.0.obs;

  /// 심은 나무 수를 저장하는 반응형 변수
  RxDouble treesPlanted = 0.0.obs;

  /// 사용자 탄소 발자국 데이터를 가져오는 비동기 메소드
  Future<void> fetchUserCarbonData() async {
    // 현재 사용자의 이메일을 가져옴
    String userEmail = curUser.value.eMail;
    print("Fetching carbon data for: $userEmail");

    // 백엔드 API의 URL 구성
    var url = Uri.parse(
        "$baseUrl/footprint/calculate_with_reduction?user_eMail=$userEmail");

    // GET 요청 수행
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      final data = json.decode(utf8.decode(response.bodyBytes));
      print("서버 응답: $data");
      print(data['summary']['total_energy_reduction']);

      // 'summary'가 존재하는지 확인
      if (data['summary'] != null) {
        // 각 항목을 추출하여 반응형 변수에 저장
        chartTtotalEnergyReduction.value =
            data['summary']['total_energy_reduction'] ?? 0.0;
        treesPlanted.value = data['summary']['total_trees_planted'] ?? 0.0;
        chartTotalCarbonFootprint.value =
            data['summary']['total_carbon_footprint'] ?? 0.0;
        totalCarbonReduction.value =
            data['summary']['total_carbon_reduction'] ?? 0.0;
        print('데이터 성공적으로 가져옴');

        // 평균 비교 데이터 가져오기
        Map<String, dynamic> averageComparisonData =
            data['summary']['average_comparison'] ?? {};

        // 사용자 배출량 데이터
        carbonData.value = {
          '교통': averageComparisonData.containsKey('trafic')
              ? (averageComparisonData['trafic']['사용자 배출량'] ?? 0.0).toDouble()
              : 0.0,
          '고기': averageComparisonData.containsKey('meat')
              ? (averageComparisonData['meat']['사용자 배출량'] ?? 0.0).toDouble()
              : 0.0,
          '전기': averageComparisonData.containsKey('electricity')
              ? (averageComparisonData['electricity']['사용자 배출량'] ?? 0.0)
                  .toDouble()
              : 0.0,
          '가스': averageComparisonData.containsKey('gas')
              ? (averageComparisonData['gas']['사용자 배출량'] ?? 0.0).toDouble()
              : 0.0,
        };

        // 평균 탄소 발자국 데이터
        averageCarbonData.value = {
          '교통': averageComparisonData.containsKey('trafic')
              ? (averageComparisonData['trafic']['전세계 평균 배출량'] ?? 0.0)
                  .toDouble()
              : 0.0,
          '고기': averageComparisonData.containsKey('meat')
              ? (averageComparisonData['meat']['전세계 평균 배출량'] ?? 0.0).toDouble()
              : 0.0,
          '전기': averageComparisonData.containsKey('electricity')
              ? (averageComparisonData['electricity']['전세계 평균 배출량'] ?? 0.0)
                  .toDouble()
              : 0.0,
          '가스': averageComparisonData.containsKey('gas')
              ? (averageComparisonData['gas']['전세계 평균 배출량'] ?? 0.0).toDouble()
              : 0.0,
        };
      }
    } else {
      // 에러 발생 시 에러 메시지 출력
      print("탄소 발자국 데이터를 불러오는 데 실패했습니다: ${response.statusCode}");
    }
  }

  /// 탄소 데이터를 가져와 Firestore에 저장하는 비동기 메소드
  Future<void> fetchAndStoreCarbonData() async {
    // 구현 필요
  }

  /// 소수점 두 자리까지 형식을 지정한 문자열 반환
  String getFormattedValue(double value) {
    return value.toStringAsFixed(2);
  }

  /// 탄소 발자국 데이터를 내림차순으로 정렬하여 리스트로 반환
  List<MapEntry<String, double>> getSortedCarbonData() {
    var sortedEntries = carbonData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  /// 평균 탄소 발자국 데이터를 내림차순으로 정렬하여 리스트로 반환
  List<MapEntry<String, double>> getAverageCarbonData() {
    var sortedEntries = averageCarbonData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }
}
