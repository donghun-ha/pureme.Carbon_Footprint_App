import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/calc/calc_home.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final handler = Get.put(RankHandler());

  @override
  Widget build(BuildContext context) {
    print(handler.curUser.value.nickName);
    handler.fetchTotalCarbon();
    return Scaffold(
      backgroundColor: Colors.transparent,
      // 필요한 변수: curUser, curTotalCarbon
      // 필요 함수: curUser는 로그인시 이미 바뀌어서 상관없지만
      // curTotalCarbon 바꾸기 위한 vmhandler.fetchTotalCarbon 한번 불러줘야함
      // 나무 계산식, 에너지 계산식 등은 총 탄소량 curTotalCarbon 전부 계산가능하므로
      // view쪽에서 추가바람.
      // 나머지 글씨들은 전부
      body: GetBuilder<RankHandler>(builder: (controllor) {
        return Obx(
          () {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controllor.curUser.value.nickName,
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
                                      "총 ${controllor.totalReducedCarbonFootprint.value} KG",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      '탄소량을 줄이는 활동을 하셨습니다!',
                                    ),
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
                                      '총 ${controllor.totalCarbonFootprint.value} KG',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ), // 탄소량 출력
                                    const Text('탄소량을 배출했습니다!'),
                                  ],
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/bioenergy.png',
                                          width: 40,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '총 에너지\n감소량',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        Text(
                                          "${controllor.totalEnergyReduction.value} L",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ), // 총에너지 감소량
                                      ],
                                    ),
                                    const VerticalDivider(
                                      thickness: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 28.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/tree.png',
                                            width: 40,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              '심은\n나무 수',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '${controllor.treesFootprint.value} 그루',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ), // 총에너지 감소량
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 54),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: 213,
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 오늘의 탄소 발자국은 0Kg!\n
                                        Text(
                                          '지속 가능한 지구를 위해\n함께 노력해요!',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff808080),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Image.asset(
                                      'images/co2.png',
                                      width: 50,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFEF9D),
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => const CalcHome())!.then(
                                        (value) =>
                                            controllor.fetchTotalCarbon());
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'images/footprint.png',
                                        width: 60,
                                      ),
                                      const Text(
                                        '   탄소 발자국 계산하기',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
