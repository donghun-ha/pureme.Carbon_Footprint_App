import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';
import 'package:http/http.dart' as http;

class UserInfoUpdate extends StatelessWidget {
  UserInfoUpdate({super.key});

  // 더미 데이터
  final int level = 3;

  final vmhandler = Get.put(RankHandler());
  final box = GetStorage();

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 초기 더미 데이터 설정
    nicknameController.text = vmhandler.curUser.value.nickName;
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
                                  FutureBuilder(
                                      future: _fetchImage(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                "Error : ${snapshot.error}"),
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              vmhandler.imageFile == null
                                                  ? CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage: (vmhandler
                                                              .userProfileImageChanged)
                                                          ? const AssetImage(
                                                              'images/useru.jpg')
                                                          : (vmhandler
                                                                      .curUser
                                                                      .value
                                                                      .profileImage ==
                                                                  null)
                                                              ? const AssetImage(
                                                                  'images/useru.jpg')
                                                              : NetworkImage(
                                                                  "http://127.0.0.1:8000/user/view/${vmhandler.curUser.value.profileImage!}"),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          FileImage(File(
                                                              vmhandler
                                                                  .imageFile!
                                                                  .path)),
                                                    ),
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      vmhandler.userImagePicker(
                                                          ImageSource.gallery);
                                                    },
                                                    child: const Text(
                                                      '사진 수정',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      vmhandler.userImageNull();
                                                    },
                                                    child: const Text(
                                                      '기본이미지',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      }),
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
                                            vmhandler.curUser.value.nickName),
                                        Text(
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                            vmhandler.curUser.value.eMail),
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
                                  if (vmhandler.imageFile != null ||
                                      (vmhandler.curUser.value.profileImage !=
                                              null &&
                                          vmhandler.imageFile == null)) {
                                    if (vmhandler.imageFile != null) {
                                      vmhandler.userImageInsert();
                                    }
                                    vmhandler.userUpdateAll(
                                        vmhandler.curUser.value.eMail,
                                        nicknameController.text.trim(),
                                        phoneController.text.trim(),
                                        vmhandler.userProfileImageChanged
                                            ? 'null'
                                            : vmhandler.profileImageName!);
                                  } else {
                                    vmhandler.userUpdate(
                                      vmhandler.curUser.value.eMail,
                                      nicknameController.text.trim(),
                                      phoneController.text.trim(),
                                    );
                                  }
                                  _showDialog();
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

  Future<Uint8List?> _fetchImage() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://127.0.0.1:8000/user/view/${vmhandler.curUser.value.profileImage!}"),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // 바이트 배열로 반환
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
    return null; // 에러 발생 시 null 반환
  }

  _showDialog() {
    Get.defaultDialog(
      title: '회원정보 수정',
      middleText: '수정이 완료되었습니다.',
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
}//End
