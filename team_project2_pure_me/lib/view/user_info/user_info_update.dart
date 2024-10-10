import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

class UserInfoUpdate extends StatelessWidget {
  UserInfoUpdate({super.key});

  // 더미 데이터
  final int level = 3;

  final vmhandler = Get.put(RankHandler());
  final box = GetStorage();

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // String profileImage = 'images/earth.png';
    String nickName = 'Pureus';
    String email = 'pureus@example.com';
    // String phone = '010-1234-5678';

    // 초기 더미 데이터 설정
    nicknameController.text = vmhandler.curUser.value.nickName;
    emailController.text = vmhandler.curUser.value.eMail;
    phoneController.text = vmhandler.curUser.value.phone;

    return GetBuilder<RankHandler>(builder: (controller) {
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
                                    '회원정보 수정',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      vmhandler.imageFile == null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: vmhandler.curUser
                                                          .value.profileImage ==
                                                      null
                                                  ? const AssetImage(
                                                      'images/co2.png')
                                                  : NetworkImage(
                                                      "http://127.0.0.1:8000/user/view/${vmhandler.curUser.value.profileImage!}"),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: FileImage(File(
                                                  vmhandler.imageFile!.path)),
                                            ),
                                      TextButton(
                                        onPressed: () {
                                          vmhandler.userImagePicker(
                                              ImageSource.gallery);
                                        },
                                        child: const Text(
                                          '사진 수정',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 26),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                'Level $level'),
                                            const SizedBox(width: 8),
                                            Image.asset('images/sprout.png',
                                                width: 24, height: 24),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                        Text(
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                            nickName),
                                        Text(
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                            email),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: nicknameController,
                                    decoration: const InputDecoration(
                                        labelText: '닉네임 수정'),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                        labelText: '이메일 수정'),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                        labelText: '전화번호 변경'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (vmhandler.imageFile != null) {
                                    vmhandler.userImageInsert();
                                    vmhandler.userUpdateAll(
                                        emailController.text.trim(),
                                        nicknameController.text.trim(),
                                        phoneController.text.trim(),
                                        vmhandler.profileImageName!);
                                  } else {
                                    vmhandler.userUpdate(
                                      emailController.text.trim(),
                                      nicknameController.text.trim(),
                                      phoneController.text.trim(),
                                    );
                                  }
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text('수정 완료'),
                              ),
                            ),
                            const SizedBox(height: 25)
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
    });
  }
}
