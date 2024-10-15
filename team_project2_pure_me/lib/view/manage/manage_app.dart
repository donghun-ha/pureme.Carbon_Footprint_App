import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageApp extends StatelessWidget {
  ManageApp({super.key});

  final vmhandler = Get.put(ManageHandler());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/main_background_plain.png',
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'APP 통계',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
            ),

            /// update 추적을 위한 겟빌더
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<ManageHandler>(
                builder: (controller) {
                  //// async를 위한 퓨처빌더
                  return FutureBuilder(
                    ///signInUserList, madeFeedList 를 가져오는 함수
                    future: vmhandler.fetchAppManage(),
                    builder: (ccc, snapshot) {
                      //// if문: 예외처리들
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error : ${snapshot.error}"),
                        );
                      } else {
                        return Column(
                          children: [
                            /// List observing을 위한 Obx, Listview당 하나.
                            Obx(() {
                              return _buildUserComparisonChart(vmhandler);
                            }),
                            Obx(() {
                              return _buildFeedComparisonChart(vmhandler);
                            }),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildUserComparisonChart(ManageHandler manageHandler) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        title: const ChartTitle(text: '회원가입하는 유저 수'),
        legend: const Legend(isVisible: true),
        series: <CartesianSeries>[
          ColumnSeries<MapEntry<String, int>, String>(
            dataSource: manageHandler.acountGen(),
            xValueMapper: (MapEntry<String, int> data, _) => data.key,
            yValueMapper: (MapEntry<String, int> data, _) => data.value,
            name: '유저 생성수',
          ),
          ColumnSeries<MapEntry<String, double>, String>(
            dataSource: manageHandler.acountGenAverage(),
            xValueMapper: (MapEntry<String, double> data, _) => data.key,
            yValueMapper: (MapEntry<String, double> data, _) => data.value,
            name: '유저 생성수 평균',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedComparisonChart(ManageHandler manageHandler) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        title: const ChartTitle(text: '피드 생성수'),
        legend: const Legend(isVisible: true),
        series: <CartesianSeries>[
          ColumnSeries<MapEntry<String, int>, String>(
            dataSource: manageHandler.feedGen(),
            xValueMapper: (MapEntry<String, int> data, _) => data.key,
            yValueMapper: (MapEntry<String, int> data, _) => data.value,
            name: '피드 생성수',
          ),
          ColumnSeries<MapEntry<String, double>, String>(
            dataSource: manageHandler.feedGenAverage(),
            xValueMapper: (MapEntry<String, double> data, _) => data.key,
            yValueMapper: (MapEntry<String, double> data, _) => data.value,
            name: '피드 생성수 평균',
          ),
        ],
      ),
    );
  }
} //End
