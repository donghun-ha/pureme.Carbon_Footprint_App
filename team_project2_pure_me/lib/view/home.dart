import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/calc/calc_home.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final handler = Get.put(RankHandler());
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      initPlatformState();
    } else {
      print("Activity Recognition 권한이 거부되었습니다.");
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    print(handler.curUser.value.nickName);
    handler.fetchTotalCarbon();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<RankHandler>(builder: (controller) {
        return Obx(
          () {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfoCard(controller),
                    SizedBox(height: 20),
                    _buildBottomSection(controller),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildUserInfoCard(RankHandler controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 3,
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
                    Text(
                      "총 ${controller.totalReducedCarbonFootprint.value} KG",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('탄소량을 줄이는 활동을 하셨습니다!'),
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
                      '총 ${controller.totalCarbonFootprint.value} KG',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('탄소량을 배출했습니다!'),
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
                          child: Text('총 에너지\n감소량', style: TextStyle(fontSize: 12)),
                        ),
                        Text(
                          "${controller.totalEnergyReduction.value} L",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Row(
                        children: [
                          Image.asset('images/tree.png', width: 40),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('심은\n나무 수', style: TextStyle(fontSize: 12)),
                          ),
                          Text(
                            '${controller.treesFootprint.value} 그루',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildBottomSection(RankHandler controller) {
    return Row(
      children: [
        Expanded(
          child: _buildCarbonFootprintCalculator(controller),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStepCounter(),
        ),
      ],
    );
  }

  Widget _buildCarbonFootprintCalculator(RankHandler controller) {
  return SizedBox(
    height: 300,
    child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지속 가능한 지구를 위해\n함께 노력해요!',
              style: TextStyle(fontSize: 14, color: Color(0xff808080)),
            ),
            SizedBox(height: 58),
            Row(
              children: [
                Image.asset('images/co2.png', width: 40),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEF9D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => const CalcHome())!
                          .then((value) => controller.fetchTotalCarbon());
                    },
                    child: const Text('탄소 발자국 계산하기', 
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStepCounter() {
  return SizedBox(
    height: 300,
    child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '오늘의 걸음 수',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              _steps,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: requestPermission,
              child: Text('걸음 수 갱신', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    ),
  );
}}