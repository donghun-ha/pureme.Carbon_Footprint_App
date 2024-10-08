import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';
import 'package:http/http.dart' as http;

class CalcRecycle extends StatelessWidget {
  CalcRecycle({super.key});
  final TextEditingController paperController = TextEditingController();
  final TextEditingController plasticController = TextEditingController();
  final TextEditingController glassController = TextEditingController();
  final TextEditingController goldController = TextEditingController();
  final TextEditingController somethingelseController = TextEditingController();
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
          
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Stack(children: [
                    Container(
                        color: const Color(0xFFB8F2B4),
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
                                        child: const Icon(Icons.arrow_back)),
                                    const Text('BACK'),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    '분리수거 소비량 입력',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Text('주간 분리수거 양을 통해 탄소 절감량을 계산합니다.')
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
                                const Text('Tip: 분리수거 정보 입력 \n\n'),
                                const Text(
                                    '최근 일주일 동안 분리수거한 종이의 총 무게를 kg 단위로\n 입력하세요!\n'),
                                const Text(
                                    '입력한 값을 다시 한번 확인하고, 누락된 항목이 없는지\n 점검하세요. 정확한 입력이 절감 효과를 높입니다!'),
                                const Text(
                                  '종이류 소비량(kg)\n',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('예) 2kg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: paperController,
                                    decoration: const InputDecoration(
                                      hintText: '종이류 소비량(kg)',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '플라스틱 소비량(kg)\n',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('예) 1.5kg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: plasticController,
                                    decoration: const InputDecoration(
                                      hintText: '플라스틱 소비량',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '유리류 소비량(kg)\n',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('예) 0.8kg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: glassController,
                                    decoration: const InputDecoration(
                                      hintText: '유리류 소비량 (kg)',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '금속류 소비량(kg)\n',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('예) 0.5kg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: goldController,
                                    decoration: const InputDecoration(
                                      hintText: '금속류 소비량',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '기타 폐기물 소비량(kg)\n',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('예) 0.3kg'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: somethingelseController,
                                    decoration: const InputDecoration(
                                      hintText: '기타 폐기물 소비량(kg)',
                                      hintStyle: TextStyle(color: Colors.grey),
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
                                      child: const Text('재활용 소비량 입력')),
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
          })));
        }
        
        insertCarbonGen(Vmhandler vmHandler) {

          double? paperAmount = double.tryParse(paperController.text); 
          double? plasticAmount = double.tryParse(plasticController.text);
          double? glassAmount = double.tryParse(glassController.text);
          double? goldAmount = double.tryParse(goldController.text);
          double? somethingElseAmount = double.tryParse(somethingelseController.text);

          if (paperAmount != null || plasticAmount != null || glassAmount != null ||
                goldAmount != null || somethingElseAmount != null ) {
                    giveData(vmHandler);
                } else {
                  Get.snackbar('경고', '숫자를 모두 입력해주세요.');
                }
        }


        giveData(Vmhandler vmHandler) async {
            var url = Uri.parse(
              'http://127.0.0.1:8000/footprint/insert?category_kind=Recycle&user_eMail=aaa&createDate=${DateTime.now()}&amount=${paperController.text.trim()}, ${plasticController.text.trim()}, ${glassController.text.trim()}, ${goldController.text.trim()}, ${somethingelseController.text.trim()}'
            );
            var response = await http.get(url);
            var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
            result = dataConvertedJSON['message'];
            Get.back();
        }




  }

 // 텍스트필드의 내용을 insertCarbonGen(String kind, String amount)에 넣어준다.