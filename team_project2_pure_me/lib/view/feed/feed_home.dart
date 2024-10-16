import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/view/feed/feed_detail.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedHome extends StatelessWidget {
  FeedHome({super.key});

  final feedHandler = Get.put(FeedHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경 설정을 투명
      backgroundColor: Colors.transparent,
      body: Obx(
        () {
          return Padding(
            padding: const EdgeInsets.fromLTRB(25, 100, 25, 25),
            child: DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ]),
              // 피드가 보여질 공간
              child: Card(
                elevation: 3,
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
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: GridView.builder(
                          itemCount: feedHandler.feedList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 한줄당 갯수
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            Feed feed = feedHandler.feedList[index];
                            return GestureDetector(
                              // 클릭시 클릭한 피드의 정보를 argument로 보냄
                              onTap: () {
                                Get.to(
                                  () => FeedDetail(),
                                  arguments: feed,
                                )!
                                    .then(
                                  (value) {
                                    feedHandler.imgFile = null;
                                    feedHandler.imageFile = null;
                                  },
                                );
                              },
                              // 화면 구성
                              child: Card(
                                elevation: 2,
                                color: const Color(0xFFB1B1B1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(feed.feedImagePath),
                                ), // 이미지 변경
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
