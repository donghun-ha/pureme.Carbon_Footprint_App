// lib/view/home.dart

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:team_project2_pure_me/view/calc/calc_home.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RankHandler handler = Get.put(RankHandler());
  int _steps = 0;
  StreamSubscription<StepCount>? _stepCountSubscription;

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  /// Pedometer 초기화 및 권한 요청
  void _initPedometer() async {
    PermissionStatus status;

    // 플랫폼별로 적절한 권한 요청
    if (Platform.isAndroid) {
      status = await Permission.activityRecognition.status;
      print("Activity Recognition Permission status: $status");
      if (!status.isGranted) {
        status = await Permission.activityRecognition.request();
        print("Activity Recognition Permission after request: $status");
      }
    } else if (Platform.isIOS) {
      status = await Permission.sensors.status;
      print("Sensors Permission status: $status");
      if (!status.isGranted) {
        status = await Permission.sensors.request();
        print("Sensors Permission after request: $status");
      }
    } else {
      // 다른 플랫폼 처리 (필요 시 추가)
      status = PermissionStatus.denied;
    }

    if (status.isGranted) {
      // 권한이 승인된 경우 Pedometer 스트림 구독 시작
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );
    } else {
      // 권한이 거부된 경우 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('걸음 수를 측정하려면 권한이 필요합니다.')),
      );
    }
  }

  /// 걸음 수 업데이트
  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
    });
    print("Current Steps: $_steps");
  }

  /// 에러 처리
  void _onStepCountError(error) {
    print('Pedometer error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('걸음 수 측정 중 오류가 발생했습니다.')),
    );
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handler.fetchTotalCarbon();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<RankHandler>(
        builder: (controller) {
          return Obx(
            () => Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfoCard(controller),
                    const SizedBox(height: 10),
                    _buildBottomSection(controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 사용자 정보 카드 위젯
  Widget _buildUserInfoCard(RankHandler controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 23,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.curUser.value.nickName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('비기너'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('지금까지', style: TextStyle(fontSize: 25)),
                    const SizedBox(height: 5),
                    Text(
                      "[ ${controller.totalReducedCarbonFootprint.value} KG ]",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Text('탄소량을 줄이는 활동을 하셨습니다!',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Image.asset(
                'images/earth.png',
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '총 탄소배출량 :  ${controller.totalCarbonFootprint.value} KG ',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset('images/bioenergy.png', width: 40),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('총 에너지\n감소량',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Text(
                          "${controller.totalEnergyReduction.value} L",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          Image.asset('images/tree.png', width: 40),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('심은\n나무 수',
                                style: TextStyle(fontSize: 12)),
                          ),
                          Text(
                            '${controller.treesFootprint.value} 그루',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 하단 섹션 위젯 (탄소 발자국 계산기 및 걸음 수 카운터)
  Widget _buildBottomSection(RankHandler controller) {
    return Row(
      children: [
        Expanded(
          child: _buildCarbonFootprintCalculator(controller),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStepCounter(),
        ),
      ],
    );
  }

  /// 탄소 발자국 계산기 위젯
  Widget _buildCarbonFootprintCalculator(RankHandler controller) {
    return SizedBox(
      height: 340,
      child: Card(
        elevation: 25,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEF9D),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Image.asset('images/co2.png', width: 50),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      '지속 가능한 \n지구를 위해\n함께 해요  :)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFEF9D).withOpacity(0.3),
                        ),
                        child: Center(
                          child: Material(
                            elevation: 8,
                            shape: const CircleBorder(),
                            color: const Color(0xFFFFEF9D),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                Get.to(() => const CalcHome())!.then(
                                    (value) => controller.fetchTotalCarbon());
                              },
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('images/footprint.png',
                                        width: 60),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '탄소 발자국\n계산하기',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 걸음 수 카운터 위젯
  Widget _buildStepCounter() {
    return SizedBox(
      height: 340,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              height: 95,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 117, 199, 120),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  '오늘의 걸음 수',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade200,
                                Colors.green.shade600
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.green.shade300, width: 4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _steps.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                Text(
                                  '걸음',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
