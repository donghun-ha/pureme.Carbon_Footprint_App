import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/calc/calc_handler.dart';

class CalcFood extends StatelessWidget {
  CalcFood({super.key});
  final TextEditingController meatController = TextEditingController();
  final TextEditingController vegetableController = TextEditingController();
  final TextEditingController milkController = TextEditingController();
  final TextEditingController plantController = TextEditingController();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(CalcHandler());
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'),
        )),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GetBuilder<CalcHandler>(
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 70, 25, 50),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFFB8F2B4),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            IconButton(
                                                onPressed: () => Get.back(),
                                                icon: Icon(Icons.arrow_back_ios))
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            '식습관 정보 입력',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text('당신의 식습관 정보를 통해 절감된 탄소량을 계산합니다.'),
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.7,
                                        color: Colors.white,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: meatController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: '주간 육류 소비량(kg)',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: vegetableController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: '주간 채식 소비량',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: milkController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: '주간 유제품 소비량 (kg)',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: plantController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: '주간 식물성 대체 식품 소비량',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20.0),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        insertCarbonGen(vmHandler);
                                                      },
                                                      child:
                                                          const Text('식습관 정보 입력')),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
        ));
  }

  insertCarbonGen(CalcHandler vmHandler) {
    double? meat = double.tryParse(meatController.text);
    double? vegetarian = double.tryParse(vegetableController.text);
    double? dairy = double.tryParse(milkController.text);
    double? plant = double.tryParse(plantController.text);

    if (meat != null || vegetarian != null || dairy != null || plant != null) {
      vmHandler.giveData(vmHandler, vmHandler.foodlist[0],
          meatController.text.trim(), box.read('pureme_id'));
      vmHandler.giveData(vmHandler, vmHandler.foodlist[1],
          vegetableController.text.trim(), box.read('pureme_id'));
      vmHandler.giveData(vmHandler, vmHandler.foodlist[2],
          milkController.text.trim(), box.read('pureme_id'));
      vmHandler.giveData(vmHandler, vmHandler.foodlist[3],
          plantController.text.trim(), box.read('pureme_id'));
      Get.back();
    } else {
      Get.snackbar('경고', '숫자를 모두 입력해주세요.');
    }
  }

  _errorSnackBar() {
    Get.snackbar(
      "경고",
      "값을 입력하세요.",
      snackPosition: SnackPosition.TOP,
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '입력',
      middleText: '입력하였습니다.',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// 텍스트필드의 내용을 insertCarbonGen(String kind, String amount)에 넣어준다.
