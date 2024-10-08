import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/login_signin/sign_up.dart';
import 'package:team_project2_pure_me/view/tabbar_page.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final GetStorage box = GetStorage();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        hintText: 'pureme@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextField(
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
                        onPressed: () {
                          // 로그인 로직

                          // 로그인 성공시 페이지 이동
                          box.write('pureme_id', idController.text);
                          Get.to(() => TabbarPage());
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
          ),
        ),
      ),
    );
  }
}
