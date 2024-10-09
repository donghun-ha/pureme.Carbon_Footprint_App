import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/feed/feed_insert.dart';
import 'user_info_config.dart';

class UserInfoHome extends StatelessWidget {
  UserInfoHome({super.key});

  // 더미 데이터
  final String profileImage = 'images/earth.png';
  final String nickName = 'Pureus';
  final String email = 'tjexample@email.com';
  final int level = 3;
  final List<String> posts = List.generate(6, (index) => 'Post ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 65,
                                    backgroundImage: AssetImage(profileImage),
                                  ),
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
                                                    const UserInfoConfig());
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
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(width: 8),
                                            Image.asset('images/sprout.png',
                                                width: 24, height: 24),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          nickName,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          email,
                                          style: const TextStyle(fontSize: 16),
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage('images/earth.png'),
                                    fit: BoxFit.cover)),
                            child: Center(
                                child: Text(posts[index],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
