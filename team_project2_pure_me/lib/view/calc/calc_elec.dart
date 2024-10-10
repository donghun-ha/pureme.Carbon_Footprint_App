import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';
import 'package:http/http.dart' as http;

class CalcElec extends StatelessWidget {
  CalcElec({super.key});
  final TextEditingController electricController = TextEditingController();
  final TextEditingController gasController = TextEditingController();
  late String? result = '__';

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
            body: GetBuilder<Vmhandler>(builder: (controller) {
              
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
                                        '전기 사용량 입력',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text('당신의 전기 사용량을 통해 절감된 탄소량을 계산합니다.')
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
                                  const Text('Tip: 전기 사용량 입력 하는 법\n\n'),
                                  const Text(
                                      '전기 사용량 : 전기 청구서를 확인하여 월간 kWh 사용량을 \n입력하세요. 청구서가 없다면, 에어컨이나 가전 제품 사용\n시간을 추정할 수 있습니다.\n\n'),
                                  const Text(
                                    '가정 내 전기 사용량\n',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('예) 300kWh'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: electricController,
                                      decoration: const InputDecoration(
                                        hintText: '월간 전기 사용량(kWh)',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '가스 사용량\n',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('예) 50m3'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: gasController,
                                      decoration: const InputDecoration(
                                        hintText: '월간 가스 사용량(m3)',
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
                                        child: const Text('전기 사용량 입력')),
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
              })));
            }
          

          insertCarbonGen(Vmhandler vmHandler) {

            double? electricity = double.tryParse(electricController.text.trim());
            double? gas = double.tryParse(gasController.text.trim());
            
            if (electricity != null || gas != null) {
              giveData(vmHandler, vmHandler.electricitylist[0], electricController.text.trim(), "aaa");
              giveData(vmHandler, vmHandler.electricitylist[1], gasController.text.trim(), "aaa");
            } else {
              Get.snackbar('경고', '숫자를 모두 입력해주세요.');
            }
          }

          giveData(Vmhandler vmHandler, String kind, String amount, String email) async {
              var url = Uri.parse('http://127.0.0.1:8000/footprint/insert?category_kind=$kind&user_eMail=aaa&createDate=${DateTime.now()}&amount=$amount');
              var response = await http.get(url);
              var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
              result = dataConvertedJSON['message'];
              Get.back();
          }







  }

