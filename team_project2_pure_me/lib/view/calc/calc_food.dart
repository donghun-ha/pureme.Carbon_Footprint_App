import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';

class CalcFood extends StatelessWidget {
  CalcFood({super.key});
  final TextEditingController meatController = TextEditingController();
  final TextEditingController vegetableController = TextEditingController();
  final TextEditingController milkController = TextEditingController();
  final TextEditingController plantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(Vmhandler());
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'),
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GetBuilder<Vmhandler>(
            builder: (controller) {
              
                  // FutureBuilder(
                  //   future: controller.,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } else if (snapshot.hasError) {
                  //       return Center(
                  //         child: Text('Error : ${snapshot.error}'),
                  //       );
                  //     } else {
                  //       return
                  
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Stack(children: [
                          Container(
                              color: Colors.greenAccent,
                              height: 850,
                              width: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child:
                                                  const Icon(Icons.arrow_back)),
                                          const Text('BACK'),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          '식습관 정보 입력',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('당신의 식습관 정보를 통해 절감된 탄소량을 계산합니다.')
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 105, 0, 0),
                            child: Container(
                              width: 350,
                              height: 730,
                              color: Colors.white,
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Tip: 식습관 정보 입력 방법\n\n'),
                                      const Text(
                                          '최근 식물성 대체 식품의 구매 내역을 확인하세요. 이 정보\n를 통해 소비량을 더 정확하게 입력할 수 있습니다. 예를 \n들어, 슈퍼마켓 영수증이나 온라인 쇼핑 기록을 참고합니다.\n'),
                                      const Text(
                                        '육류 소비량\n',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('예) 5kg'),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: meatController,
                                          decoration: const InputDecoration(
                                            hintText: '주간 육류 소비량(kg)',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '채식 소비량\n',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('예) 10kg'),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: vegetableController,
                                          decoration: const InputDecoration(
                                            hintText: '주간 채식 소비량',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '유제품 소비량\n',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('예) 20리터'),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: vegetableController,
                                          decoration: const InputDecoration(
                                            hintText: '주간 유제품 소비량 (kg)',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '식품성 대체 식품 소비량\n',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('예) 8kg'),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: vegetableController,
                                          decoration: const InputDecoration(
                                            hintText: '주간 식물성 대체 식품 소비량',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              //
                                            },
                                            child: const Text('식습관 정보 입력')),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  );
                },
              )));
              //   }
              // },
            }
          
        
  }

// 텍스트필드의 내용을 insertCarbonGen(String kind, String amount)에 넣어준다.
