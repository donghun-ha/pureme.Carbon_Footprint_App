import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabHandler extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
