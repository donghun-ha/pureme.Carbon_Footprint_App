/*
Author: 하동훈
Date: 2024-10-11
Usage: 다양한 탭을 이용하여 사용자 인터페이스 내에서 화면 간 전환을 제공합니다.

이 페이지는 Flutter의 TabBar와 TabBarView를 사용하여 여러 화면을 하나의 페이지에서 관리합니다. 
각 탭은 사용자 활동과 관련된 데이터를 시각화하거나 입력하는 화면으로 연결됩니다.

구성 요소:
1. TabBar - 상단의 탭을 통해 각기 다른 화면을 전환합니다.
2. TabBarView - 각 탭에 해당하는 내용을 표시하는 영역입니다.

이 페이지는 GetX와 GetSingleTickerProviderStateMixin을 사용하여 상태 관리를 하며, 
TabController를 통해 탭을 제어합니다.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 각 탭에 해당하는 페이지들을 임포트합니다.
import 'package:team_project2_pure_me/view/feed/feed_home.dart';
import 'package:team_project2_pure_me/view/home.dart';
import 'package:team_project2_pure_me/view/rank_page.dart';
import 'package:team_project2_pure_me/view/user_info/user_info_home.dart';
// TabHandler는 탭 상태를 관리하는 GetX 컨트롤러입니다.
import 'package:team_project2_pure_me/vm/tabbar/tab_handler.dart';

/// `TabbarPage`는 앱의 메인 탭 네비게이션을 담당하는 위젯입니다.
/// `GetX`를 사용하여 상태 관리를 수행합니다.
class TabbarPage extends StatelessWidget {
  // 생성자에 `key`를 전달할 수 있도록 설정합니다.
  TabbarPage({super.key});

  // `TabHandler` 인스턴스를 GetX의 의존성 주입을 통해 생성하거나 기존 인스턴스를 가져옵니다.
  final TabHandler tabHandler = Get.put(TabHandler());

  @override
  Widget build(BuildContext context) {
    tabHandler.tabbarInit();
    return Stack(
      children: [
        // 배경 이미지를 업데이트하기 위해 Obx로 감쌉니다.
        Obx(
          () => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  tabHandler.currentIndex.value == 0
                      ? 'images/main_background.png' // 첫 번째 탭일 때 배경 이미지
                      : 'images/main_background_plain.png', // 그 외의 탭일 때 배경 이미지
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          // Scaffold의 배경을 투명하게 설정하여 Stack의 배경 이미지가 보이도록 합니다.
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // `TabBarView`를 확장하여 남은 공간을 채우도록 합니다.
              Expanded(
                child: TabBarView(
                  // 스와이프를 통한 페이지 전환을 비활성화합니다.
                  physics: const NeverScrollableScrollPhysics(),
                  // `TabController`를 연결하여 탭과 뷰를 동기화합니다.
                  controller: tabHandler.tabController,
                  children: [
                    // 각 탭에 해당하는 페이지를 나열합니다.
                    Home(), // 첫 번째 탭: 홈 페이지
                    FeedHome(), // 두 번째 탭: 피드 페이지
                    const RankPage(), // 세 번째 탭: 랭크 페이지
                    UserInfoHome(), // 네 번째 탭: 사용자 정보 페이지
                  ],
                ),
              ),
              // 하단에 `TabBar`를 배치합니다.
              Container(
                // 탭 바의 사이즈를 설정합니다.
                height: 100,
                // 탭 바의 배경색을 설정합니다.
                color: Colors.white,
                child: TabBar(
                  // `TabController`를 연결하여 탭과 뷰를 동기화합니다.
                  controller: tabHandler.tabController,
                  // 각 탭의 아이콘과 라벨을 정의합니다.
                  tabs: [
                    Tab(
                      // Home Icon Image
                      icon: Image.asset('images/home.png', height: 40),
                      text: 'Home', // 홈 라벨
                    ),
                    Tab(
                      // Feed Icon Image
                      icon: Image.asset('images/community.png', width: 40),
                      text: 'Feed', // 피드 라벨
                    ),
                    Tab(
                      // Rank Icon Image
                      icon: Image.asset('images/trophy.png', width: 40),
                      text: 'Rank', // 랭크 라벨
                    ),
                    Tab(
                      // User Icon Image
                      icon: Image.asset('images/user.png', width: 40),
                      text: 'User', // 사용자 라벨
                    ),
                  ],
                  // 선택된 탭의 라벨 색상을 설정합니다.
                  labelColor: Colors.blue[200],
                  // 선택되지 않은 탭의 라벨 색상을 설정합니다.
                  unselectedLabelColor: Colors.grey,
                  // 선택된 탭의 인디케이터 색상을 설정합니다.
                  indicatorColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
