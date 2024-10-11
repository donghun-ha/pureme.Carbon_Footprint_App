import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/login_signin/login.dart';
import 'package:team_project2_pure_me/view/user_info/user_carbon_chart.dart';
import 'user_info_update.dart';
import 'user_info_password.dart';

class UserInfoConfig extends StatelessWidget {
  UserInfoConfig({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/main_background_plain.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 컨텐츠
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Get.back(),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '설정',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('images/post.png',
                                width: 24, height: 24),
                            title: const Text('회원정보 수정'),
                            onTap: () => Get.to(() => UserInfoUpdate()),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('images/settings.png',
                                width: 24, height: 24),
                            title: const Text('비밀번호 변경'),
                            onTap: () => Get.to(() => UserInfoPassword()),
                          ),
                          const Divider(),
                          ListTile(
                            leading:
                                Icon(Icons.insert_chart, color: Colors.blue),
                            title: const Text('나의 차트'),
                            onTap: () => Get.to(() => UserCarbonChart()),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('images/ranking.png',
                                width: 24, height: 24),
                            title: const Text('로그아웃'),
                            onTap: () {
                              _showDialog();
                            },
                          ),
                          const Divider(),
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '로그아웃',
      middleText: '로그아웃이 완료되었습니다.',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            box.remove('pureme_id');
            Get.offAll(
              () => Login(),
            );
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
