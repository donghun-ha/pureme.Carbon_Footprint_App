import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

class UserCarbonChart extends StatelessWidget {
  final chartHandler = Get.put(RankHandler());

  @override
  Widget build(BuildContext context) {
    chartHandler.fetchUserCarbonData();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/main_background_plain.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (chartHandler.carbonData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildCarbonFootprintChart(),
                      _buildTotalCarbonInfo(),
                      _buildCategoryComparisonChart(),
                      _buildAdditionalInfo(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          Text(
            '${chartHandler.curUser.value.nickName}님의 탄소 발자국',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonFootprintChart() {
    return Container(
      height: 300,
      child: SfCircularChart(
        title: const ChartTitle(
          text: '탄소 발자국 분석',
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries>[
          DoughnutSeries<MapEntry<String, double>, String>(
            dataSource: chartHandler.getSortedCarbonData(),
            xValueMapper: (MapEntry<String, double> data, _) => data.key,
            yValueMapper: (MapEntry<String, double> data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }

  Widget _buildTotalCarbonInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '총 탄소 발자국: ${chartHandler.getFormattedValue(chartHandler.chartTotalCarbonFootprint.value)} kg CO2',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '총 절감량: ${chartHandler.getFormattedValue(chartHandler.totalCarbonReduction.value)} kg CO2',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryComparisonChart() {
    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        title: const ChartTitle(text: '카테고리별 탄소 발자국 비교'),
        legend: const Legend(isVisible: true),
        series: <CartesianSeries>[
          ColumnSeries<MapEntry<String, double>, String>(
            dataSource: chartHandler.getSortedCarbonData(),
            xValueMapper: (MapEntry<String, double> data, _) => data.key,
            yValueMapper: (MapEntry<String, double> data, _) => data.value,
            name: '사용자 배출량',
          ),

          ColumnSeries<MapEntry<String, double>, String>(
            dataSource: chartHandler.getAverageCarbonData(),
            xValueMapper: (MapEntry<String, double> data, _) => data.key,
            yValueMapper: (MapEntry<String, double> data, _) => data.value,
            name: '세계 평균 배출량',
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '에너지 절감량: ${chartHandler.getFormattedValue(chartHandler.chartTtotalEnergyReduction.value)} MWh',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
              '심은 나무 수: ${chartHandler.getFormattedValue(chartHandler.treesPlanted.value)} 그루',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
