import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/calc/calc_elec.dart';
import 'package:team_project2_pure_me/view/calc/calc_food.dart';
import 'package:team_project2_pure_me/view/calc/calc_recycle.dart';
import 'package:team_project2_pure_me/view/calc/calc_trans.dart';

class CalcHome extends StatelessWidget {
  const CalcHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/main_background_plain.png')),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // 함수불필요
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 100, 25, 50),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xffB8F2B4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          const Text(
                            '탄소 발자국 계산',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Text('당신의 일상 속 작은 실천이 환경에 큰 변화를 만듭니다.'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(27, 10, 27, 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '교통',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/traffic.png',
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        const Text(
                                            '대중교통 이용, 자가용 사용 등\n이동 수단 관련 정보를 입력하세요'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF91C1F5),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.to(() => CalcTrans()),
                                            child: const Text(
                                              '교통 정보 입력',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(27, 10, 27, 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '에너지 사용',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/energy.png',
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        const Text(
                                            '가정 내 전기, 가스 사용량을 입력\n하여 에너지 절감을 확인하세요'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFFFE454),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.to(() => CalcElec()),
                                            child: const Text(
                                              '전기 사용량 입력',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(27, 10, 27, 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '식습관',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/meal.png',
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        const Text(
                                            '육류 소비, 채식 등 식습관에 따른\n탄소 발자국을 계산하세요'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF4BAF4B),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.to(() => CalcFood()),
                                            child: const Text(
                                              '식습관 정보 입력',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(27, 10, 27, 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '분리수거',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/separate.png',
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        const Text(
                                            '재활용 소비량을 입력하여 절감효\n과를 확인하세요'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFFFEF9D),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.to(() => CalcRecycle()),
                                            child: const Text(
                                              '재활용 소비량 입력',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
