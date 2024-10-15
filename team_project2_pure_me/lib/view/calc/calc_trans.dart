import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/vm/calc/calc_handler.dart';
import 'package:http/http.dart' as http;

class CalcTrans extends StatelessWidget {
  CalcTrans({super.key});
  final TextEditingController transController = TextEditingController();
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(CalcHandler());
    if (vmHandler.curtransDropValue == null &&
        vmHandler.transDropdown.isNotEmpty) {
      vmHandler.curtransDropValue = vmHandler.transDropdown[0];
    }

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'),
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GetBuilder<CalcHandler>(
            builder: (controller) {
              return
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
                  Obx(
                () {
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
                                          '교통 정보 입력',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('당신의 교통 수단 사용을 통해 절감된 탄소량을 계산합니다.')
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 105, 0, 0),
                            child: Container(
                              width: 350,
                              height: 730,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      dropdownColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      iconEnabledColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      value: controller.curtransDropValue ??
                                          vmHandler.transDropdown[0],
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: controller.transDropdown
                                          .map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        controller.currentTranIndex = controller
                                            .transDropdown
                                            .indexOf(value);

                                        if (value != null) {
                                          controller.transDropChange(value);
                                        }
                                      },
                                    ),
                                    const Text(
                                      '사용한 교통수단을 선택하세요.\n\n',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const Text(
                                        'Tip: 당신의 이동 방식이 환경에 미치는 영향\n\n'),
                                    const Text(
                                        '대중교통: 버스나 지하철을 자주 이용하면 탄소 발\n자국을 크게 줄일 수 있습니다.\n\n'),
                                    const Text(
                                        '차량 이용: 운전한 거리를 입력할 때, 차량의 연비\n(km/L)와 주행 거리를 입력하세요. 연비가 좋을 수\n록 탄소 배출이 적습니다.\n\n'),
                                    const Text(
                                        '자전거/도보: 자전거나 도보를 통한 이동은 탄소 배\n출량이 0입니다! 지속적으로 입력하고 탄소 감축량\n을 확인하세요.\n\n'),
                                    const Text('한 번에 평균 15KM'),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: transController,
                                        decoration: const InputDecoration(
                                          hintText: '이용 시 평균 거리(KM)',
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
                                            insertCarbonGen(vmHandler);
                                          },
                                          child: const Text('교통 정보 입력')),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  );
                },
              );
              //   }
              // },
              // );
            },
          ),
        ));
  }

  // --functions ---
  transDropChange(value) {
    for (int i = 0; i <= 2; i++) {
      value = value[i];
    }
  }

  insertCarbonGen(CalcHandler vmHandler) {
    if (vmHandler.curtransDropValue != null) {
      double? amount = double.tryParse(transController.text);
      giveData(vmHandler);
      if (amount != null) {
        vmHandler.insertCarbonGen(vmHandler.curtransDropValue!, amount);
      } else {
        // 숫자가 아닌 입력에 대한 오류 처리
        Get.snackbar('오류', '올바른 숫자를 입력해주세요.');
      }
    } else {
      // 교통 수단이 선택되지 않았을 때 오류 처리
      Get.snackbar('오류', '교통 수단을 선택해주세요.');
    }
  }

  giveData(CalcHandler vmHandler) async {
    var url = Uri.parse(
        'http://10.0.2.2:8000/footprint/insert?category_kind=${vmHandler.transDropdownEn[vmHandler.currentTranIndex]}&user_eMail=${box.read('pureme_id')}&createDate=${DateTime.now()}&amount=${transController.text.trim()}');
    await http.get(url);
    Get.back();
  }
} // End
// 텍스트필드의 내용을 insertCarbonGen(String curtransDropValue를, double amount)에 넣어준다.

// trans는 추가로 dropdownButton이 있으니 transDropChange()함수를 onchanged에 넣어주고
// curtransDropValue 를 build전에 먼저 transDropdown[0]으로 해주고
// dropdownButton의 value에 curtransDropValue를 넣어준다.
