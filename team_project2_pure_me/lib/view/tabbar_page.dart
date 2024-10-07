import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/feed/feed_home.dart';
import 'package:team_project2_pure_me/view/home.dart';
import 'package:team_project2_pure_me/view/rank_page.dart';
import 'package:team_project2_pure_me/view/user_info/user_info_home.dart';
import 'package:team_project2_pure_me/vm/tab_handler.dart';

class TabbarPage extends StatelessWidget {
  TabbarPage({super.key});
  final TabHandler tabHandler = Get.put(TabHandler());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: tabHandler.tabController.index == 0
                ? const AssetImage('images/main_background.png')
                : const AssetImage(
                    'images/main_background_plain.png'), // 배경 이미지
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabHandler.tabController,
            children: [
              // page
              const Home(),
              FeedHome(),
              RankPage(),
              UserInfoHome(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue[200],
            currentIndex: tabHandler.currentIndex.value,
            onTap: (index) {
              tabHandler.tabController.index = index;
              // tabHandler.tabController.animateTo(index);
              // tabHandler.tabSet();
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.military_tech), label: 'Rank'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
            ],
          ),
        ),
      ),
    );
  }
}
