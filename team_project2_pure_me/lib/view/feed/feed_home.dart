import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/feed/feed_detail.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedHome extends StatelessWidget {
  FeedHome({super.key});

  final feedHandler = Get.put(FeedHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // 사용되는 변수 : feedList -> GridView에 들어갈 imageName들
      // 사용되는 함수 : fetchFeedList() -> build 함수의 return Scafold 전에 시행하여
      // feedList를 바꿔줘야 함.
      body: GetBuilder<FeedHandler>(
        builder: (controller) {
          return FutureBuilder(
            future: controller.fetchFeedList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else {
                return Obx(
                  () {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(25, 100, 25, 25),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                              child: Text(
                                '탄소 절감, 우리의 이야기',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: GridView.builder(
                                  itemCount: feedHandler.feedList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 한줄당 갯수
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ), // 화면 구성
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(
                                        () => const FeedDetail(),
                                        arguments: feedHandler.feedList[index],
                                      ),
                                      child: Card(
                                        color: const Color(0xFFB1B1B1),
                                        child: Image.asset(
                                            'images/earth.png'), // 이미지 변경
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
