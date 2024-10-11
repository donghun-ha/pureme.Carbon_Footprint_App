/*
Author: 하동훈
Date: 2024-10-11
Usage: 탭바 페이지 내 탭들의 상태를 관리하고, 사용자 인터페이스와 상호작용을 처리합니다.

이 핸들러는 GetX 패키지의 Controller 기능을 사용하여 탭의 상태를 관리합니다. 
탭의 전환과 관련된 이벤트를 처리하고, 각 탭에 해당하는 데이터를 연결합니다.

기능:
1. 탭 전환 - 사용자가 탭을 전환할 때 해당 탭의 데이터를 로드합니다.
2. 상태 관리 - 각 탭의 선택 상태를 유지하며, 다른 화면으로 이동할 때 상태를 보존합니다.

특징:
- GetSingleTickerProviderStateMixin을 사용하여 탭 애니메이션을 관리합니다.
- 사용자가 탭 전환 시 필요한 데이터를 적시에 가져올 수 있도록 설계되었습니다.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// `TabHandler`는 탭의 상태를 관리하는 GetX 컨트롤러입니다.
class TabHandler extends GetxController with GetSingleTickerProviderStateMixin {
  /// 현재 선택된 탭의 인덱스를 관리하는 Rx 변수
  var currentIndex = 0.obs;

  /// TabController를 선언합니다.
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // TabController를 초기화하고 리스너를 추가합니다.
    // length: 4는 탭의 개수를 의미합니다.
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      // 탭이 변경될 때 currentIndex를 업데이트합니다.
      currentIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    // 컨트롤러가 해제될 때 TabController도 해제합니다.
    tabController.dispose();
    super.onClose();
  }
}
