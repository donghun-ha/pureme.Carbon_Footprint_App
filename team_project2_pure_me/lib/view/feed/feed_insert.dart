import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedInsert extends StatelessWidget {
  FeedInsert({super.key});

  final TextEditingController contentController = TextEditingController();
  final feedHandler = Get.put(FeedHandler());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedHandler>(
      builder: (controller) {
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
              // imagePicker : feedImagePicker
              // 피드 추가하는 함수 : insertFeed(String content(내용))
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 65, 40, 65),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),
                                const Text(
                                  '새 게시물',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: GestureDetector(
                              onTap: () => controller
                                  .getImageFromGallery(ImageSource.gallery),
                              child: Container(
                                width: 270,
                                height: 270,
                                color: Colors.grey[300],
                                child: Center(
                                  child: controller.imageFile == null
                                      ? const Text('화면을 눌러 이미지를 추가해주세요')
                                      : Image.file(
                                          File(controller.imageFile!.path)),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('글의 내용을 작성해주세요'),
                                SizedBox(
                                  height: 200,
                                  child: TextField(
                                    controller: contentController,
                                    maxLines: null,
                                    expands: true,
                                    decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 0,
                                          color: Colors.transparent,
                                        )),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        hintText: '문구를 작성해주세요'),
                                  ),
                                ),
                                IntrinsicHeight(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                        // 등록 동작
                                        insertButton();
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFD6C4FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        '등록',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
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
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Function ---
  insertButton() {
    if (feedHandler.imageFile != null &&
        contentController.text.trim().isNotEmpty) {
      feedHandler.addFeed(contentController.text);
      Get.back();
    } else {
      buttonSnackBar();
    }
  }

  buttonSnackBar() {
    Get.snackbar(
      '입력 오류',
      '사진 및 문구를 추가해주세요',
      duration: const Duration(seconds: 1), // 애니메이션 시간
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
} // End
