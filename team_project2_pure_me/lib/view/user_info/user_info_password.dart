import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoPassword extends StatelessWidget {
  UserInfoPassword({super.key}) ;

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
                        color: const Color(0xFFE9FCE7),
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
                                  '비밀번호 변경',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: currentPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: '현재 비밀번호'),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: newPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: '새로운 비밀번호'),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: '비밀번호 확인'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // 비밀번호 변경 로직
                                if (newPasswordController.text == confirmPasswordController.text) {
                                  // TODO: 실제 비밀번호 변경 로직 구현
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.green,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('비밀번호 변경'),
                            ),
                          ),
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
}