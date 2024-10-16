import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/vm/calc/calc_handler.dart';

// ignore: must_be_immutable
class CalcRecycle extends StatelessWidget {
  CalcRecycle({super.key});
  final TextEditingController paperController = TextEditingController();
  final TextEditingController plasticController = TextEditingController();
  final TextEditingController glassController = TextEditingController();
  final TextEditingController goldController = TextEditingController();
  final TextEditingController somethingelseController = TextEditingController();
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
              body: GetBuilder<CalcHandler>(builder: (controller) {
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
                                          '분리수거 소비량 입력',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('주간 분리수거 양을 통해 탄소 절감량을 계산합니다.'),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Container(
                                     height: MediaQuery.of(context).size.height*0.7,
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
                                                    hintStyle:
                                                        TextStyle(color: Colors.grey),
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
                                                    hintStyle:
                                                        TextStyle(color: Colors.grey),
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
                                                    hintStyle:
                                                        TextStyle(color: Colors.grey),
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
                                                    hintStyle:
                                                        TextStyle(color: Colors.grey),
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
                                                    child: const Text('재활용 소비량 입력')),
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
              })),
        ));
  }

  insertCarbonGen(CalcHandler vmHandler) {
    double? paper = double.tryParse(paperController.text);
    double? plastic = double.tryParse(plasticController.text);
    double? glass = double.tryParse(glassController.text);
    double? metal = double.tryParse(goldController.text);
    double? other = double.tryParse(somethingelseController.text);

    if (paper != null ||
        plastic != null ||
        glass != null ||
        metal != null ||
        other != null) {
      if (paper != null) {
        vmHandler.giveData(vmHandler, vmHandler.recylist[0],
            paperController.text.trim(), box.read('pureme_id'));
      }

      if (plastic != null) {
        vmHandler.giveData(vmHandler, vmHandler.recylist[1],
            plasticController.text.trim(), box.read('pureme_id'));
      }

      if (glass != null) {
        vmHandler.giveData(vmHandler, vmHandler.recylist[2],
            glassController.text.trim(), box.read('pureme_id'));
      }

      if (metal != null) {
        vmHandler.giveData(vmHandler, vmHandler.recylist[3],
            goldController.text.trim(), box.read('pureme_id'));
      }

      if (other != null) {
        vmHandler.giveData(vmHandler, vmHandler.recylist[4],
            somethingelseController.text.trim(), box.read('pureme_id'));
      }
    } else {
      Get.snackbar('경고', '숫자를 하나라도 입력해주세요.');
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