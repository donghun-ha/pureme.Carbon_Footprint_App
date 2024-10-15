// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/view/feed/feed_detail.dart';
import 'package:team_project2_pure_me/view/feed/feed_insert.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';
import 'user_info_config.dart';
// import 'package:http/http.dart' as http;

class UserInfoHome extends StatelessWidget {
  UserInfoHome({super.key});

  final vmhandler = Get.put(RankHandler());
  final box = GetStorage();

  // 더미 데이터

  final int level = 3;
  final List<String> posts = List.generate(6, (index) => 'Post ${index + 1}');

  @override
  Widget build(BuildContext context) {
    vmhandler.fetchFeed();
    return GetBuilder<RankHandler>(builder: (con) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(
            () {
              return SafeArea(
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
                              Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE9FCE7),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder(
                                              future: vmhandler.fetchImage(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        "Error : ${snapshot.error}"),
                                                  );
                                                } else {
                                                  return CircleAvatar(
                                                    radius: 65,
                                                    backgroundImage: vmhandler
                                                                .curUser
                                                                .value
                                                                .profileImage ==
                                                            null
                                                        ? const AssetImage(
                                                            'images/co2.png')
                                                        : MemoryImage(
                                                            snapshot.data!),
                                                  );
                                                }
                                              }),
                                          const SizedBox(width: 22),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            UserInfoConfig());
                                                      },
                                                      child: Image.asset(
                                                          'images/settings.png',
                                                          width: 24,
                                                          height: 24),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Level $level',
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Image.asset(
                                                        'images/sprout.png',
                                                        width: 24,
                                                        height: 24),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  vmhandler
                                                      .curUser.value.nickName,
                                                  style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  vmhandler.curUser.value.eMail,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 16,
                                    bottom: 10,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // 글쓰기 기능 구현
                                        Get.to(() => FeedInsert());
                                      },
                                      icon: Image.asset('images/post.png',
                                          width: 24, height: 24),
                                      label: const Text('게시글 작성'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              vmhandler.userFeedList.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(16),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10),
                                      itemCount: vmhandler.userFeedList.length,
                                      itemBuilder: (context, index) {
                                        Feed feed =
                                            vmhandler.userFeedList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => FeedDetail(),
                                              arguments: feed,
                                            )!
                                                .then(
                                              (value) {
                                                vmhandler.imgFile = null;
                                                vmhandler.imageFile = null;
                                              },
                                            );
                                          },
                                          child: Card(
                                            color: const Color(0xFFB1B1B1),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                  feed.feedImagePath),
                                            ), // 이미지 변경
                                          ),
                                        );
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.grey[300],
                                        //       borderRadius: BorderRadius.circular(10),
                                        //       image: const DecorationImage(
                                        //           image: AssetImage('images/earth.png'),
                                        //           fit: BoxFit.cover)),
                                        //   child: Center(
                                        //       child: Text(posts[index],
                                        //           style: const TextStyle(
                                        //               color: Colors.white,
                                        //               fontWeight: FontWeight.bold))),
                                        // );
                                      },
                                    )
                                  : const SizedBox(
                                      height: 200,
                                      child: Center(child: Text('피드를 추가해보세요!')),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ));
    });
  }
}//End
