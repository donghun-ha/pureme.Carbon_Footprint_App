import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/user_handler.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwVerifyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final validText = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // 이메일 형식 정규식으로 정함.
  final validNum = RegExp(r'^[0-9]{4,}$');

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(UserHandler());

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

            /// SQL에서 이메일 중복을 확인하는 함수 : eMailVerify(String eMail)
            /// SQL에서 이메일 중복을 확인하는 변수 : eMailUnique
            /// 회원가입 시켜주는 함수 : signIn
            body: GetBuilder<UserHandler>(
              builder: (controller) {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 100, 30, 100),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    '회원가입',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: TextField(
                                    controller: idController,
                                    decoration: InputDecoration(
                                      labelText: '이메일',
                                      hintText: 'Example@naver.com',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: '닉네임',
                                      hintText: '닉네임을 입력하세요.',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: TextField(
                                    controller: pwController,
                                    decoration: InputDecoration(
                                      labelText: '비밀번호',
                                      hintText: '비밀번호를 입력하세요.',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: TextField(
                                    controller: pwVerifyController,
                                    decoration: InputDecoration(
                                      labelText: '비밀번호 확인',
                                      hintText: '비밀번호를 한번더 입력하세요.',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: '전화번호',
                                      hintText: 'ex) 01012345678',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFC9C58E),
                                          side: const BorderSide(
                                              color: Colors.black),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () async {
                                          // 빈값이 있을 경우
                                          if (nullcheck()) {
                                            _errorSnackBar("빈칸을 채워주세요.");
                                            return;
                                          }
                                          String email =
                                              idController.text.trim();
                                          // 이메일이 형식이 아닐경우
                                          if (email.isNotEmpty) {
                                            if (!validText.hasMatch(email)) {
                                              _errorSnackBar(
                                                  "이메일 형식이 올바르지 않습니다.");
                                              return;
                                            }
                                          }
                                          String number =
                                              phoneController.text.trim();
                                          // 전화번호 형식이 아닐경우
                                          if (number.isNotEmpty) {
                                            if (!validNum.hasMatch(number)) {
                                              _errorSnackBar(
                                                  "전화번호 형식이 올바르지 않습니다.");
                                              return;
                                            }
                                          }
                                          // 아이디 중복 체크
                                          if (idController.text
                                              .trim()
                                              .isNotEmpty) {
                                            // 아이디 중복 확인을 호출하는 함수
                                            await vmHandler.eMailVerify(
                                                idController.text.trim());
                                            // vm의 eMailUnique가 true일때 중복 X
                                            if (vmHandler.eMailUnique) {
                                              // 이메일이 중복되지 않았다면
                                              // 회원가입 시도
                                              bool pwCheck =
                                                  // signIn 함수에서 비밀번호 중복 확인
                                                  // 중복일 경우 false
                                                  // 중복이 아닐경우 true 및 회원가입
                                                  await vmHandler.signIn(
                                                idController.text.trim(),
                                                pwController.text.trim(),
                                                pwVerifyController.text.trim(),
                                                nameController.text.trim(),
                                                phoneController.text.trim(),
                                              );

                                              // 패스워드 중복체크
                                              if (pwCheck) {
                                                // 중복이 아니면 회원가입 완료 alert
                                                _showDialog();
                                              } else {
                                                _errorSnackBar(
                                                    '비밀번호가 일치하지 않습니다.');
                                              }
                                            } else {
                                              _errorSnackBar(
                                                  '이미 사용중인 이메일이 존재합니다!');
                                            }
                                          }
                                        },
                                        child: const Text(
                                          '회원가입',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 147, 167, 32),
                                          side: const BorderSide(
                                              color: Colors.black),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          '뒤로가기',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '회원가입',
      middleText: '회원가입이 완료되었습니다.',
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

  _errorSnackBar(String message) {
    Get.snackbar(
      "경고",
      message,
      snackPosition: SnackPosition.TOP,
    );
  }

  nullcheck() {
    if (idController.text.trim().isEmpty ||
        pwController.text.trim().isEmpty ||
        pwVerifyController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}   // End
