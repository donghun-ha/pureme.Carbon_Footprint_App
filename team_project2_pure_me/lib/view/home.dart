import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/calc/calc_home.dart';
import 'package:team_project2_pure_me/vm/user_handler.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';

class Home extends StatelessWidget {
  Home({super.key}) {
    Get.put(UserHandler());
  }

  @override
  Widget build(BuildContext context) {
    final UserHandler userHandler = Get.find<UserHandler>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      // 필요한 변수: curUser, curTotalCarbon
      // 필요 함수: curUser는 로그인시 이미 바뀌어서 상관없지만
      // curTotalCarbon 바꾸기 위한 vmhandler.fetchTotalCarbon 한번 불러줘야함
      // 나무 계산식, 에너지 계산식 등은 총 탄소량 curTotalCarbon 전부 계산가능하므로
      // view쪽에서 추가바람.
      // 나머지 글씨들은 전부
      body: GetBuilder<Vmhandler>(builder: (controllor) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(userHandler.curUser.nickName),
                                  Text('비기너'),
                                ],
                              ),
                            ),
                          ),
                          const Text('총 탄소 0KG을'), // 탄소량 출력
                          const Text('줄이는 히어로 활동을 하셨습니다!'),
                          Image.asset(
                            'images/earth.png',
                            width: 100,
                          ),
                          const Text('0KG'), // 탄소량 출력
                          const Text('총 탄소량 감소'),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/bioenergy.png',
                                      width: 40,
                                    ),
                                    const Text('총 에너지\n감소량'),
                                    const Text('  0L'), // 총에너지 감소량
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
                                      const Text('심은\n나무 수'),
                                      const Text('  0그루'), // 총에너지 감소량
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
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '오늘의 탄소 발자국은 0Kg!\n지속 가능한 지구를 위해\n함께 노력해요!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff808080),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'images/co2.png',
                                width: 50,
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
                                Get.to(() => const CalcHome());
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
      }),
    );
  }
}
