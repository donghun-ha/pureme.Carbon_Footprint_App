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
    String userEmail = curUser.value.eMail;

    var url = Uri.parse(
    "$baseUrl/footprint/calculate_with_reduction?user_eMail=$userEmail");
    var response = await http.get(url);

      final data = json.decode(utf8.decode(response.bodyBytes));



      if (data['summary']['average_comparison'] != null) {
        chartTtotalEnergyReduction.value = data['summary']['total_energy_reduction'];
        treesPlanted.value = data['summary']['total_trees_planted'];
        chartTotalCarbonFootprint.value = data['summary']['total_carbon_footprint'];
        totalCarbonReduction.value = data['summary']['total_carbon_reduction'];

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
