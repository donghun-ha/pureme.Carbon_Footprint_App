import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:team_project2_pure_me/vm/rank_handler.dart';
// import 'dart:io' show Platform;
import 'package:team_project2_pure_me/vm/user_handler.dart';

class ChartHandler extends UserHandler {
  RxMap<String, double> carbonData = <String, double>{}.obs;
  RxMap<String, double> averageCarbonData = <String, double>{}.obs;


  RxMap<String, Map<String, double>> averageComparison =
      <String, Map<String, double>>{}.obs;


  RxDouble chartTotalCarbonFootprint = 0.0.obs;
  RxDouble totalCarbonReduction = 0.0.obs;
  RxDouble chartTtotalEnergyReduction = 0.0.obs;
  RxDouble treesPlanted = 0.0.obs;

  Future<void> fetchUserCarbonData() async {
    try {
      String userEmail = curUser.value.eMail;
      print(userEmail);
      var url = Uri.parse(
          "$baseUrl/footprint/calculate_with_reduction?user_eMail=$userEmail");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print("서버 응답: $data");
        print(data['summary']['total_energy_reduction']);

        if (data['summary']['average_comparison'] != null) {
          chartTtotalEnergyReduction.value = data['summary']['total_energy_reduction'];
          treesPlanted.value = data['summary']['total_trees_planted'];
          chartTotalCarbonFootprint.value = data['summary']['total_carbon_footprint'];
          totalCarbonReduction.value = data['summary']['total_carbon_reduction'];
          print('성공');
        }

          carbonData.value = {
            '교통': data['summary']['average_comparison']['trafic']['사용자 배출량'] ?? 0.0,
            '고기': data['summary']['average_comparison']['meat']['사용자 배출량'] ?? 0.0,
            '전기': data['summary']['average_comparison']['electricity']['사용자 배출량'] ?? 0.0,
            '가스': data['summary']['average_comparison']['gas']['사용자 배출량'] ?? 0.0,
          };

          averageCarbonData.value = {
            '교통': data['summary']['average_comparison']['trafic']['전세계 평균 배출량'] ?? 0.0,
            '고기': data['summary']['average_comparison']['meat']['전세계 평균 배출량'] ?? 0.0,
            '전기': data['summary']['average_comparison']['electricity']['전세계 평균 배출량'] ?? 0.0,
            '가스': data['summary']['average_comparison']['gas']['전세계 평균 배출량'] ?? 0.0,
          };



      } else {
        print("탄소 발자국 데이터를 불러오는 데 실패했습니다: ${response.statusCode}");
      }
    } catch (e) {
      print("탄소 발자국 데이터를 불러오는 중 오류 발생: $e");
    }

    // try {
    //   String userEmail = curUser.value.eMail;
    //   print(userEmail);
    //   var url = Uri.parse("$baseUrl/footprint/chart?user_eMail=$userEmail");
    //   var response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     final data = json.decode(utf8.decode(response.bodyBytes));
    //     print("서버 응답: $data");

    //     // 서버로부터 받아온 결과를 carbonData에 저장
    //     if (data['result'] != null && data['result'] is Map) {
    //       carbonData.value = {
    //         '교통': data['result']['transport'] ?? 0.0,
    //         '전기': data['result']['energy'] ?? 0.0,
    //         '음식': data['result']['food'] ?? 0.0,
    //         '쓰레기': data['result']['other'] ?? 0.0,
    //       };
    //       print("탄소 데이터 저장 완료: $carbonData");
    //     }
    //   } else {
    //     print("탄소 발자국 데이터를 불러오는 데 실패했습니다: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("탄소 발자국 데이터를 불러오는 중 오류 발생: $e");
    // }
  }

  Future<void> fetchAndStoreCarbonData() async {}

  String getFormattedValue(double value) {
    return value.toStringAsFixed(2);
  }

  List<MapEntry<String, double>> getSortedCarbonData() {
    var sortedEntries = carbonData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  List<MapEntry<String, double>> getAverageCarbonData() {
    var sortedEntries = averageCarbonData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }





}
