import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/login_signin/sign_up.dart';
import 'package:team_project2_pure_me/view/manage/manage_home.dart';
import 'package:team_project2_pure_me/view/tabbar_page.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});

  final GetStorage box = GetStorage();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  late String? result = '__';

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(RankHandler());

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/background_id.png'), // 배경 이미지
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // 필요한 함수: 로그인 가능 확인
              /// 또한, 매니저라면 매니지 홈으로 넘겨야함.
              // 로그인 가능해서실제로 Home으로 넘어갈때
              // getStorage의 box에 id를 쓰자.
              //아이디는 getStoarge로 넘기자.
              //
              body: GetBuilder<RankHandler>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 0,
                                groupValue: vmHandler.manageLogin,
                                onChanged: (value) {
                                  vmHandler.manageLoginChange(value);
                                },
                              ),
                              Text('유저 로그인'),
                              const SizedBox(
                                width: 60,
                              ),
                              Radio(
                                  value: 1,
                                  groupValue: vmHandler.manageLogin,
                                  onChanged: (value) {
                                    vmHandler.manageLoginChange(value);
                                  }),
                              Text('관리자 로그인'),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: idController,
                              decoration: InputDecoration(
                                labelText: '아이디',
                                hintText: '이메일을 입력해주십시오.',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: pwController,
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('이메일이 없으신가요?    '),
                              GestureDetector(
                                onTap: () {
                                  idController.text = '';
                                  pwController.text = '';
                                  // 회원가입 이동
                                  Get.to(() => SignUp());
                                },
                                child: const Text(
                                  '회원가입',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFFFEF9D),
                                side: const BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                print('');
                                if (nullcheck()) {
                                  _showalibaba();
                                  return;
                                }
                                var cease = await vmHandler.ceaseAccountVerify(
                                    idController.text.trim());
                                if (cease.$1 != null) {
                                  showCease(cease.$2!, cease.$1!);
                                  return;
                                }
                                // 로그인 로직
                                bool checkLogin = vmHandler.manageLogin == 0
                                    ? await vmHandler.loginVerify(
                                        idController.text.trim(),
                                        pwController.text.trim())
                                    : await vmHandler.manageLoginVerify(
                                        idController.text.trim(),
                                        pwController.text.trim(),
                                      );
                                if (checkLogin) {
                                  if (vmHandler.manageLogin == 0) {
                                    box.write('pureme_id', idController.text);
                                  } else {
                                    box.write('manager', idController.text);
                                  }

                                  _showDialog(vmHandler.manageLogin == 0);
                                } else {
                                  errorSnackBar();
                                }
                                // 로그인 성공시 페이지 이동
                              },
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )));
  }

  _showDialog(bool userLogin) {
    Get.defaultDialog(
      title: '로그인',
      middleText: '로그인이 완료되었습니다.',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            idController.text = '';
            pwController.text = '';
            Get.back();
            Get.to(() => userLogin ? TabbarPage() : ManageHome());
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  errorSnackBar() {
    Get.snackbar(
      "경고",
      "입력을 안했거나 아이디, 비밀번호를 확인하세요.",
      snackPosition: SnackPosition.TOP,
    );
  }

  nullcheck() {
    if (idController.text.trim().isEmpty || pwController.text.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _showalibaba() {
    Get.snackbar("경고", "빈칸을 채워주세요.");
  }

  showCease(String ceaseReason, int ceaseDate) {
    Get.defaultDialog(
      title: '귀하의 계정은 정지되었습니다.',
      content: Column(
        children: [
          Text('정지 사유: $ceaseReason'),
          Text('남은 정지일: $ceaseDate'),
        ],
      ),
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            idController.text = '';
            pwController.text = '';
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
